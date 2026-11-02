import 'package:flutter/material.dart';
import '../widgets/cane_logo.dart';
import 'privacy_policy_screen.dart';
import 'terms_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAF5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF14451D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'About CaneCare AI',
          style: TextStyle(
            color: Color(0xFF14451D),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // Logo & Title (Figma Screen 19)
              const CaneLogo(size: 64, showText: false),
              const SizedBox(height: 12),
              const Text(
                'CaneCare AI',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF14451D),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'v1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7A9280),
                ),
              ),
              const SizedBox(height: 16),

              // Subtitles
              const Text(
                'AI-Based Sugarcane Disease\nDetection Using Leaf Image Analysis.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF153B28),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Built for Maharashtra's farmers.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF5A7262),
                ),
              ),
              const SizedBox(height: 28),

              // Links: Privacy Policy & Terms of Service (Figma Screen 19)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE8EFE5), width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildRowItem(
                      icon: Icons.shield_outlined,
                      title: 'Privacy Policy',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFF0F4ED), indent: 48),
                    _buildRowItem(
                      icon: Icons.description_outlined,
                      title: 'Terms of Service',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TermsScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Footer Copyright
              const Text(
                '© 2025 CaneCare AI\nAll rights reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFA5B8A8),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF7A9280)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF14451D),
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFA5B8A8),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
