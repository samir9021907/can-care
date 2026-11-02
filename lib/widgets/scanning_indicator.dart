import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ScanningIndicator extends StatefulWidget {
  final String imagePath;
  final String currentStatusMessage;
  final double progress;

  const ScanningIndicator({
    super.key,
    required this.imagePath,
    required this.currentStatusMessage,
    this.progress = 0.65,
  });

  @override
  State<ScanningIndicator> createState() => _ScanningIndicatorState();
}

class _ScanningIndicatorState extends State<ScanningIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = (widget.progress * 100).toInt().clamp(0, 100);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        // Circular Leaf Viewport with Concentric Green Radar Rings
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            final scale = _pulseAnimation.value;
            return Stack(
              alignment: Alignment.center,
              children: [
                // Outer subtle thin ring
                Container(
                  width: 260 * scale,
                  height: 260 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF81C784).withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                  ),
                ),
                // Middle glowing ring
                Container(
                  width: 236 * scale,
                  height: 236 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.5),
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF81C784).withValues(alpha: 0.2),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                // Inner ring holding the leaf circle
                Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF2E7D32),
                      width: 3.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: _buildLeafImage(widget.imagePath),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 36),

        // Title: "Analyzing leaf..."
        const Text(
          'Analyzing leaf...',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF14451D),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle: "Checking leaf patterns and disease indicators."
        const Text(
          'Checking leaf patterns and\ndisease indicators.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF5A7262),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 28),

        // Linear Progress Bar with percentage (Figma: "65%")
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 8,
                    color: const Color(0xFFE0E6DC),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedFractionallySizedBox(
                        duration: const Duration(milliseconds: 300),
                        widthFactor: widget.progress.clamp(0.05, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                '$percent%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Checklist items matching Figma Screen 7:
        // • Preparing image...
        // • Examining leaf patterns...
        // • Comparing disease features...
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepRow(
                text: 'Preparing image...',
                isActive: widget.progress >= 0.25,
              ),
              const SizedBox(height: 10),
              _buildStepRow(
                text: 'Examining leaf patterns...',
                isActive: widget.progress >= 0.55,
              ),
              const SizedBox(height: 10),
              _buildStepRow(
                text: 'Comparing disease features...',
                isActive: widget.progress >= 0.85,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepRow({required String text, required bool isActive}) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFF2E7D32) : const Color(0xFFA5B8A8),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? const Color(0xFF153B28) : const Color(0xFF7A9280),
          ),
        ),
      ],
    );
  }

  Widget _buildLeafImage(String path) {
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) => _buildFallbackIcon(),
      );
    }
    if (kIsWeb) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) => _buildFallbackIcon(),
      );
    }
    try {
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (ctx, err, stack) => _buildFallbackIcon(),
        );
      }
    } catch (_) {}
    return Image.asset(
      'assets/images/leaf_in_viewfinder.png',
      fit: BoxFit.cover,
      errorBuilder: (ctx, err, stack) => _buildFallbackIcon(),
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      color: const Color(0xFFE8F5E9),
      child: const Icon(
        Icons.eco_rounded,
        color: Color(0xFF2E7D32),
        size: 72,
      ),
    );
  }
}
