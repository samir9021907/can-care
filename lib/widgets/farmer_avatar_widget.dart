import 'dart:io';
import 'package:flutter/material.dart';

class FarmerAvatarPreset {
  final String key;
  final String nameMr;
  final String nameHi;
  final String nameEn;
  final IconData icon;
  final List<Color> gradientColors;

  const FarmerAvatarPreset({
    required this.key,
    required this.nameMr,
    required this.nameHi,
    required this.nameEn,
    required this.icon,
    required this.gradientColors,
  });

  String displayName(String langCode) {
    if (langCode == 'hi') return nameHi;
    if (langCode == 'en') return nameEn;
    return nameMr;
  }
}

class FarmerAvatarWidget extends StatelessWidget {
  final String? avatarPath;
  final String fullName;
  final double size;
  final bool showCameraBadge;
  final bool showEditBadge;
  final VoidCallback? onTap;
  final VoidCallback? onCameraTap;

  const FarmerAvatarWidget({
    super.key,
    this.avatarPath,
    this.fullName = 'Samir Rahane',
    this.size = 88,
    this.showCameraBadge = false,
    this.showEditBadge = false,
    this.onTap,
    this.onCameraTap,
  });

  static const List<FarmerAvatarPreset> presets = [
    FarmerAvatarPreset(
      key: 'avatar_farmer_pheta',
      nameMr: 'शेतकरी फेटा',
      nameHi: 'किसान साफा',
      nameEn: 'Farmer (Pheta)',
      icon: Icons.face_retouching_natural_rounded,
      gradientColors: [Color(0xFFE65100), Color(0xFFFF9800)],
    ),
    FarmerAvatarPreset(
      key: 'avatar_smart_farmer',
      nameMr: 'स्मार्ट शेतकरी',
      nameHi: 'स्मार्ट किसान',
      nameEn: 'Smart Farmer',
      icon: Icons.person_pin_rounded,
      gradientColors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
    ),
    FarmerAvatarPreset(
      key: 'avatar_sugarcane',
      nameMr: 'ऊस उत्पादक',
      nameHi: 'गन्ना उत्पादक',
      nameEn: 'Cane Grower',
      icon: Icons.grass_rounded,
      gradientColors: [Color(0xFF00695C), Color(0xFF26A69A)],
    ),
    FarmerAvatarPreset(
      key: 'avatar_tractor',
      nameMr: 'आधुनिक शेती',
      nameHi: 'आधुनिक खेती',
      nameEn: 'Agri Tractor',
      icon: Icons.agriculture_rounded,
      gradientColors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
    ),
    FarmerAvatarPreset(
      key: 'avatar_leaf',
      nameMr: 'हरित शिवार',
      nameHi: 'हरित खेत',
      nameEn: 'Green Crop',
      icon: Icons.eco_rounded,
      gradientColors: [Color(0xFF2E7D32), Color(0xFF81C784)],
    ),
    FarmerAvatarPreset(
      key: 'avatar_field',
      nameMr: 'काळी माती',
      nameHi: 'काली मिट्टी',
      nameEn: 'Rich Soil',
      icon: Icons.landscape_rounded,
      gradientColors: [Color(0xFF5D4037), Color(0xFF8D6E63)],
    ),
  ];

  static FarmerAvatarPreset? findPreset(String? key) {
    if (key == null) return null;
    for (final p in presets) {
      if (p.key == key) return p;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final initials = fullName
        .trim()
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e[0].toUpperCase())
        .take(2)
        .join();

    final preset = findPreset(avatarPath);
    final isCustomFile = avatarPath != null &&
        !avatarPath!.startsWith('avatar_') &&
        File(avatarPath!).existsSync();

    Widget avatarContent;

    if (isCustomFile) {
      avatarContent = ClipOval(
        child: Image.file(
          File(avatarPath!),
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallbackInitials(initials),
        ),
      );
    } else if (preset != null) {
      avatarContent = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: preset.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: preset.gradientColors.first.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            preset.icon,
            color: Colors.white,
            size: size * 0.52,
          ),
        ),
      );
    } else {
      avatarContent = _buildFallbackInitials(initials);
    }

    final hasBadge = showCameraBadge || showEditBadge;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF16A34A),
                width: 2.5,
              ),
            ),
            child: avatarContent,
          ),
          if (hasBadge)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onCameraTap ?? onTap,
                child: Container(
                  width: size * 0.34,
                  height: size * 0.34,
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      showEditBadge ? Icons.edit_rounded : Icons.camera_alt_rounded,
                      size: size * 0.17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFallbackInitials(String initials) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFDCFCE7), Color(0xFFBBF7D0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          initials.isNotEmpty ? initials : 'SR',
          style: TextStyle(
            fontSize: size * 0.36,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF14532D),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
