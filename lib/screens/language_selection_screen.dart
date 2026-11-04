import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_dimensions.dart';
import '../localization/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../widgets/language_card.dart';
import '../widgets/leaf_decoration.dart';
import 'sign_in_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final bool isFromSettings;

  const LanguageSelectionScreen({super.key, this.isFromSettings = false});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late AppLanguage _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = context.read<LocaleProvider>().currentLanguage;
  }

  void _onLanguageSelected(AppLanguage lang) {
    setState(() {
      _selectedLanguage = lang;
    });
  }

  void _saveLanguage() async {
    await context.read<LocaleProvider>().setLanguage(_selectedLanguage);
    if (mounted) {
      if (widget.isFromSettings) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignInScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF5),
      appBar: widget.isFromSettings
          ? AppBar(
              backgroundColor: const Color(0xFFF7FAF5),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF14451D)),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                loc.translate('profile_language'),
                style: const TextStyle(
                  color: Color(0xFF14451D),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : null,
      body: Stack(
        children: [
          // Watercolor foliage at bottom
          const LeafDecorationBackground(height: 160),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space24,
                vertical: AppDimensions.space20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.isFromSettings) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Choose Your Language',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14451D),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Select your preferred language\nto continue.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF5A7262),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),
                  ] else ...[
                    const SizedBox(height: 12),
                  ],

                  // 3 Language Cards matching Screen 2 & Screen 16
                  LanguageCard(
                    language: AppLanguage.english,
                    isSelected: _selectedLanguage == AppLanguage.english,
                    onTap: () => _onLanguageSelected(AppLanguage.english),
                  ),
                  LanguageCard(
                    language: AppLanguage.marathi,
                    isSelected: _selectedLanguage == AppLanguage.marathi,
                    onTap: () => _onLanguageSelected(AppLanguage.marathi),
                  ),
                  LanguageCard(
                    language: AppLanguage.hindi,
                    isSelected: _selectedLanguage == AppLanguage.hindi,
                    onTap: () => _onLanguageSelected(AppLanguage.hindi),
                  ),

                  const Spacer(),

                  if (!widget.isFromSettings) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _saveLanguage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B5E20),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          loc.translate('continue_btn'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ] else ...[
                    // Figma Screen 16: "Save" (Dark green) and "Cancel" (White)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveLanguage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF165228),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          loc.translate('save'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF14451D),
                          side: const BorderSide(color: Color(0xFFD4DEC9), width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          loc.translate('cancel'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
