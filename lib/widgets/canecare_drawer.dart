import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../widgets/cane_logo.dart';
import '../widgets/confirm_dialog.dart';
import '../screens/scan_camera_screen.dart';
import '../screens/language_selection_screen.dart';
import '../screens/weather_screen.dart';
import '../screens/sugarcane_advisory_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/about_screen.dart';
import '../screens/sign_in_screen.dart';
import '../screens/sugarcane_care_guide_screen.dart';
import '../screens/farmer_community_screen.dart';

/// Navigation Drawer matching Image 2 reference specifications.
class CaneCareDrawer extends StatelessWidget {
  final String activeRoute;
  final ValueChanged<int>? onSelectTab;

  const CaneCareDrawer({
    super.key,
    this.activeRoute = 'home',
    this.onSelectTab,
  });

  void _confirmLogout(BuildContext context) async {
    final loc = AppLocalizations.of(context);
    final confirmed = await ConfirmDialog.show(
      context,
      title: loc.translate('drawer_logout'),
      message: loc.translate('confirm_logout'),
      confirmText: loc.translate('drawer_logout'),
      cancelText: loc.translate('cancel'),
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final width = MediaQuery.of(context).size.width * 0.78;

    return SizedBox(
      width: width,
      child: Drawer(
        backgroundColor: const Color(0xFF0C381E),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Drawer Header matching Image 2
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CaneCare AI Logo Squircle Badge
                    const CaneLogo(size: 48),

                    const SizedBox(width: 14),

                    // App Title & Version
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CaneCare AI',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'v1.0.0',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFA5D6A7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Close '✕' Button
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white70,
                        size: 22,
                      ),
                      onPressed: () => Navigator.pop(context),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),

              const Divider(color: Color(0xFF144D2C), height: 1),

              // 2. Navigation Items List matching Image 2
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  children: [
                    // Item 1: Home
                    _buildMenuItem(
                      context: context,
                      icon: Icons.home_rounded,
                      title: loc.translate('drawer_home'),
                      isActive: activeRoute == 'home',
                      onTap: () {
                        Navigator.pop(context);
                        onSelectTab?.call(0);
                      },
                    ),

                    // Item 2: Scan Leaf / रोग ओळखा
                    _buildMenuItem(
                      context: context,
                      icon: Icons.camera_alt_outlined,
                      title: loc.translate('drawer_scan'),
                      isActive: activeRoute == 'scan',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ScanCameraScreen(),
                          ),
                        );
                      },
                    ),

                    // Item 3: Sugarcane Care Guide / ऊस पीक मार्गदर्शिका
                    _buildMenuItem(
                      context: context,
                      icon: Icons.menu_book_rounded,
                      title: loc.translate('drawer_care_guide'),
                      isActive: activeRoute == 'care_guide',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SugarcaneCareGuideScreen(),
                          ),
                        );
                      },
                    ),

                    // Item 4: Farmer Community / शेतकरी कम्युनिटी
                    _buildMenuItem(
                      context: context,
                      icon: Icons.forum_rounded,
                      title: loc.translate('drawer_community'),
                      isActive: activeRoute == 'community',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FarmerCommunityScreen(),
                          ),
                        );
                      },
                    ),

                    // Item 5: Language Selection / भाषा निवड
                    _buildMenuItem(
                      context: context,
                      icon: Icons.language_rounded,
                      title: loc.translate('drawer_language'),
                      isActive: activeRoute == 'language',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LanguageSelectionScreen(
                              isFromSettings: true,
                            ),
                          ),
                        );
                      },
                    ),

                    // Item 4: Weather Information / हवामान माहिती
                    _buildMenuItem(
                      context: context,
                      icon: Icons.wb_sunny_outlined,
                      title: loc.translate('drawer_weather'),
                      isActive: activeRoute == 'weather',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WeatherScreen(),
                          ),
                        );
                      },
                    ),

                    // Item 5: Sugarcane Advisory / तज्ञांचा सल्ला
                    _buildMenuItem(
                      context: context,
                      icon: Icons.chat_bubble_outline_rounded,
                      title: loc.translate('drawer_advisory'),
                      isActive: activeRoute == 'advisory',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SugarcaneAdvisoryScreen(),
                          ),
                        );
                      },
                    ),

                    // Item 6: History / इतिहास
                    _buildMenuItem(
                      context: context,
                      icon: Icons.history_rounded,
                      title: loc.translate('drawer_history'),
                      isActive: activeRoute == 'history',
                      onTap: () {
                        Navigator.pop(context);
                        onSelectTab?.call(2);
                      },
                    ),

                    // Item 7: Notifications / सूचना
                    _buildMenuItem(
                      context: context,
                      icon: Icons.notifications_none_rounded,
                      title: loc.translate('drawer_notifications'),
                      isActive: activeRoute == 'notifications',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationsScreen(),
                          ),
                        );
                      },
                    ),

                    // Item 8: Settings / सेटिंग्ज (Highlighted in Reference Image)
                    _buildMenuItem(
                      context: context,
                      icon: Icons.settings_outlined,
                      title: loc.translate('drawer_settings'),
                      isActive: activeRoute == 'settings',
                      onTap: () {
                        Navigator.pop(context);
                        onSelectTab?.call(4); // Switch to Profile/Settings
                      },
                    ),

                    // Item 9: About CaneCare AI / ॲपबद्दल
                    _buildMenuItem(
                      context: context,
                      icon: Icons.info_outline_rounded,
                      title: loc.translate('drawer_about'),
                      isActive: activeRoute == 'about',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AboutScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const Divider(color: Color(0xFF144D2C), height: 1),

              // 3. Logout Item at Bottom matching Image 2
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _confirmLogout(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Row(
                        children: [
                          // Red Rounded Square Badge with logout icon
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5252),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.logout_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            loc.translate('drawer_logout'),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFF8A80),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Material(
        color: isActive ? const Color(0xFF007941) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          dense: true,
          leading: Icon(
            icon,
            color: isActive ? Colors.white : const Color(0xFFE8F5E9),
            size: 22,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
              color: isActive ? Colors.white : const Color(0xFFF1F8F1),
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
