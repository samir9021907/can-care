import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../localization/app_localizations.dart';
import '../services/advisory_service.dart';

class AdvisoryCategoryDetailScreen extends StatelessWidget {
  final AdvisoryCategory category;

  const AdvisoryCategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final title = loc.translate(category.titleKey);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAF5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF14451D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF14451D),
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // Category Hero Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFDCE7DA), width: 1.2),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC8E6C9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      category.icon,
                      color: const Color(0xFF1B5E20),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF14451D),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          loc.translate(category.subtitleKey),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF5A7262),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'तज्ज्ञांच्या महत्त्वाच्या शिफारशी (Key Expert Advisories)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF14451D),
              ),
            ),
            const SizedBox(height: 12),

            ...category.tips.map((tip) {
              final parts = tip.split(': ');
              final heading = parts.length > 1 ? parts[0] : '';
              final body = parts.length > 1 ? parts[1] : tip;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2EBE0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2C3E30),
                            height: 1.45,
                          ),
                          children: [
                            if (heading.isNotEmpty)
                              TextSpan(
                                text: '$heading: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF14451D),
                                ),
                              ),
                            TextSpan(text: body),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
