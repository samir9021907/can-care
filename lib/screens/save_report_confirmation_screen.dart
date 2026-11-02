import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../widgets/leaf_decoration.dart';
import 'main_navigation_shell.dart';
import 'saved_report_detail_screen.dart';
import '../models/scan_report.dart';

class SaveReportConfirmationScreen extends StatelessWidget {
  final ScanReport? report;

  const SaveReportConfirmationScreen({super.key, this.report});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAF5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF14451D)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Watercolor foliage at bottom
          const LeafDecorationBackground(height: 160),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Green circle with white checkmark (Figma Screen 10)
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2E7D32).withValues(alpha: 0.25),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Title: "Report Saved!"
                  Text(
                    loc.translate('report_saved_title'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF14451D),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle: "Your scan report has been saved successfully."
                  Text(
                    loc.translate('report_saved_desc'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF5A7262),
                      height: 1.4,
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Button 1: "View Report" (Dark green)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (report != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SavedReportDetailScreen(report: report!),
                            ),
                          );
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MainNavigationShell(initialIndex: 2),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF165228),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        loc.translate('view_report'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Button 2: "Back to Home" (White button with border)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MainNavigationShell(initialIndex: 0),
                          ),
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF14451D),
                        side: const BorderSide(color: Color(0xFFD4DEC9), width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        loc.translate('back_to_home'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Button 3: "View All Scan History"
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MainNavigationShell(initialIndex: 2),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.history_rounded, size: 18, color: Color(0xFF165228)),
                    label: const Text(
                      'सर्व स्कॅन इतिहास पहा (View All Scans History)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF165228),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
