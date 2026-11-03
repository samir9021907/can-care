import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/farmer_avatar_widget.dart';
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
    final fullName = (user != null && user.fullName.isNotEmpty) ? user.fullName : 'Samir Rahane';
    final userRole = loc.translate('profile_farmer');
    final region = user?.region;

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
                  FarmerAvatarWidget(
                    avatarPath: user?.avatarPath,
                    fullName: fullName,
                    size: 56,
                    showEditBadge: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                      );
                    },
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
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                userRole,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                            if (region != null && region.isNotEmpty) ...[
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  region,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF7A9280),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20, color: Color(0xFF2E7D32)),
                    tooltip: loc.translate('edit'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Farm & Sugarcane Overview Pill Card (Live farm context)
            _buildFarmSummaryCard(context, loc, user),
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

  Widget _buildFarmSummaryCard(
    BuildContext context,
    AppLocalizations loc,
    dynamic user,
  ) {
    final variety = user?.sugarcaneVariety ?? 'Co 86032 (Nira)';
    final rawSize = user?.farmSize ?? '5.0';
    final area = '$rawSize ${loc.translate('field_sugarcane_area').split('(').last.replaceAll(')', '').trim()}';
    final irrigation = user?.irrigationType ?? 'ठिबक सिंचन';
    final location = user?.village != null && (user!.village as String).isNotEmpty
        ? user.village as String
        : (user?.region ?? 'कोल्हापूर, महाराष्ट्र');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EFE5), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.grass_rounded, size: 16, color: Color(0xFF2E7D32)),
              const SizedBox(width: 6),
              Text(
                loc.translate('my_farm_summary'),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF14451D),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                  );
                },
                child: Text(
                  loc.translate('edit'),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildFarmChip(
                  icon: Icons.spa_outlined,
                  label: loc.translate('field_cane_variety'),
                  value: variety,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFarmChip(
                  icon: Icons.square_foot_rounded,
                  label: loc.translate('field_sugarcane_area'),
                  value: area,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildFarmChip(
                  icon: Icons.water_drop_outlined,
                  label: loc.translate('field_irrigation_type'),
                  value: irrigation,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFarmChip(
                  icon: Icons.location_on_outlined,
                  label: loc.translate('field_village_taluka'),
                  value: location,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFarmChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE8EFE5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF2E7D32)),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7A9280),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF14451D),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
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
