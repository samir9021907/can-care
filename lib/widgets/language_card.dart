import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../localization/app_localizations.dart';

class LanguageCard extends StatelessWidget {
  final AppLanguage language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageCard({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget leadingIcon;
    String subtitleText;

    if (language == AppLanguage.english) {
      leadingIcon = Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B5E20) : const Color(0xFFEDF2EC),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.language_rounded,
          color: isSelected ? Colors.white : const Color(0xFF5A7262),
          size: 22,
        ),
      );
      subtitleText = 'Continue in English';
    } else if (language == AppLanguage.marathi) {
      leadingIcon = Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF1B5E20),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Text(
          'म',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      );
      subtitleText = 'मराठीत पुढे जा';
    } else {
      leadingIcon = Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B5E20) : const Color(0xFFDCEADF),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          'हिं',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isSelected ? Colors.white : const Color(0xFF1B5E20),
          ),
        ),
      );
      subtitleText = 'हिंदी में आगे बढ़ें';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEDF6ED) : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: isSelected ? const Color(0xFF1B5E20) : const Color(0xFFE2EBE2),
          width: isSelected ? 1.8 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                leadingIcon,
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.nativeName,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? const Color(0xFF14451D)
                              : AppColors.textMain,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitleText,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF7E9284),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? const Color(0xFF1B5E20)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF1B5E20)
                          : const Color(0xFFB0C4B4),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 15, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
