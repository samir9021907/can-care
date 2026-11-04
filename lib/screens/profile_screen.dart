import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../widgets/confirm_dialog.dart';
import 'edit_profile_screen.dart';
import 'language_selection_screen.dart';
import 'notifications_screen.dart';
import 'help_support_screen.dart';
import 'feedback_screen.dart';
import 'about_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_screen.dart';
import 'sign_in_screen.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onNavigateToHistory;

  const ProfileScreen({super.key, required this.onNavigateToHistory});

  void _handleLogout(BuildContext context) async {
    final loc = AppLocalizations.of(context);
    final confirmed = await ConfirmDialog.show(
      context,
      title: loc.translate('profile_logout'),
      message: loc.translate('confirm_logout'),
      confirmText: loc.translate('profile_logout'),
      cancelText: loc.translate('back'),
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      await context.read<AuthProvider>().signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('canecare_is_logged_in', false);
      await prefs.remove('canecare_is_logged_in');

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SignInScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final auth = context.watch<AuthProvider>();
    final currentLang = context.watch<LocaleProvider>().currentLanguage;
    final user = auth.currentUser;

    // Default to Samir Rahane / Farmer if user is null or demo
    final fullName = (user != null && user.fullName.isNotEmpty) ? user.fullName : 'Farmer';
    final userRole = loc.translate('profile_farmer');
    final initials = fullName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAF5),
        elevation: 0,
        title: Text(
          loc.translate('profile_title'),
          style: const TextStyle(
            color: Color(0xFF14451D),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          physics: const BouncingScrollPhysics(),
          children: [
            // Farmer Avatar & Header Card (Figma Screen 15)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initials.isNotEmpty ? initials : 'F',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1B5E20),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF14451D),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          userRole,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF7A9280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Grouped Menu Container (Figma Screen 15)
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
                  // 1. Account & Profile
                  _buildRowItem(
                    icon: Icons.person_outline_rounded,
                    title: loc.translate('profile_account'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                      );
                    },
                  ),
                  _buildDivider(),

                  // 2. Language (e.g. "मराठी")
                  _buildRowItem(
                    icon: Icons.language_rounded,
                    title: loc.translate('profile_language'),
                    trailingText: currentLang.nativeName,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LanguageSelectionScreen(isFromSettings: true),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),

                  // 3. Notifications
                  _buildRowItem(
                    icon: Icons.notifications_none_rounded,
                    title: loc.translate('profile_notifications'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                      );
                    },
                  ),
                  _buildDivider(),

                  // 4. Saved Reports
                  _buildRowItem(
                    icon: Icons.bookmark_border_rounded,
                    title: loc.translate('profile_saved_reports'),
                    onTap: onNavigateToHistory,
                  ),
                  _buildDivider(),

                  // 5. Help & Support
                  _buildRowItem(
                    icon: Icons.headset_mic_outlined,
                    title: loc.translate('profile_help'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                      );
                    },
                  ),
                  _buildDivider(),

                  // 6. About CaneCare AI
                  _buildRowItem(
                    icon: Icons.info_outline_rounded,
                    title: loc.translate('profile_about'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutScreen()),
                      );
                    },
                  ),
                  _buildDivider(),

                  // 7. Privacy Policy
                  _buildRowItem(
                    icon: Icons.shield_outlined,
                    title: loc.translate('privacy_policy'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                      );
                    },
                  ),
                  _buildDivider(),

                  // 8. Terms of Service
                  _buildRowItem(
                    icon: Icons.description_outlined,
                    title: loc.translate('terms_of_service'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TermsScreen()),
                      );
                    },
                  ),
                  _buildDivider(),

                  // 9. Feedback
                  _buildRowItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: loc.translate('profile_feedback'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FeedbackScreen()),
                      );
                    },
                  ),
                  _buildDivider(),

                  // 10. Log Out (Red text and icon)
                  _buildRowItem(
                    icon: Icons.logout_rounded,
                    title: loc.translate('profile_logout'),
                    titleColor: const Color(0xFFD32F2F),
                    iconColor: const Color(0xFFD32F2F),
                    showChevron: false,
                    onTap: () => _handleLogout(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRowItem({
    required IconData icon,
    required String title,
    String? trailingText,
    Color titleColor = const Color(0xFF14451D),
    Color iconColor = const Color(0xFF7A9280),
    bool showChevron = true,
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
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
              ),
              if (trailingText != null) ...[
                Text(
                  trailingText,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7A9280),
                  ),
                ),
                const SizedBox(width: 4),
              ],
              if (showChevron)
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

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF0F4ED),
      indent: 48,
    );
  }
}
