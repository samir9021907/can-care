import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../localization/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../widgets/farmer_avatar_widget.dart';
import '../widgets/top_notification.dart';
import '../models/disease_info.dart';
import '../models/crop_tip.dart';
import 'crop_tip_detail_screen.dart';
import 'crop_tips_screen.dart';
import 'disease_detail_screen.dart';
import 'help_support_screen.dart';
import 'notifications_screen.dart';
import 'sugarcane_advisory_screen.dart';
import 'weather_screen.dart';
import 'sugarcane_care_guide_screen.dart';
import 'farmer_community_screen.dart';
import 'sugarcane_market_screen.dart';
import '../services/notification_service.dart';
import '../services/sugarcane_market_service.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToScan;
  final VoidCallback onNavigateToGallery;
  final VoidCallback onNavigateToHistory;
  final VoidCallback onNavigateToDiseases;
  final VoidCallback onNavigateToProfile;
  final VoidCallback? onOpenDrawer;

  const HomeScreen({
    super.key,
    required this.onNavigateToScan,
    required this.onNavigateToGallery,
    required this.onNavigateToHistory,
    required this.onNavigateToDiseases,
    required this.onNavigateToProfile,
    this.onOpenDrawer,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Track checked farm tasks (persisted)
  final Set<int> _completedTasks = {};
  String? _liveLocation;
  int? _liveTemp;
  bool _isLiveGps = false;
  String _marketSelectedMandiId = 'kolhapur';
  bool _marketIsDailyView = true;

  @override
  void initState() {
    super.initState();
    NotificationService().init();
    _loadLiveWeather();
    _loadCompletedTasks();
  }

  Future<void> _loadLiveWeather() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loc = prefs.getString('weather_cached_location');
      final temp = prefs.getInt('weather_cached_temp');
      final isGps = prefs.getBool('weather_cached_is_gps') ?? false;
      if (mounted && loc != null && loc.isNotEmpty) {
        setState(() {
          _liveLocation = loc;
          _liveTemp = temp;
          _isLiveGps = isGps;
        });
      }
    } catch (_) {}
  }

  Future<void> _loadCompletedTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('home_completed_farm_tasks');
      if (mounted) {
        setState(() {
          _completedTasks.clear();
          if (list != null) {
            _completedTasks.addAll(list.map((e) => int.tryParse(e) ?? 0));
          }
        });
      }
    } catch (_) {}
  }

  Future<void> _saveCompletedTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        'home_completed_farm_tasks',
        _completedTasks.map((e) => e.toString()).toList(),
      );
    } catch (_) {}
  }

  void _toggleTask(int index, String taskTitle) {
    HapticFeedback.lightImpact();
    final wasDone = _completedTasks.contains(index);
    setState(() {
      if (wasDone) {
        _completedTasks.remove(index);
      } else {
        _completedTasks.add(index);
      }
    });
    _saveCompletedTasks();

    final isNowDone = !wasDone;
    TopNotification.show(
      context,
      title: isNowDone
          ? _t('काम पूर्ण झाले!', 'कार्य पूर्ण हुआ!', 'Task completed!')
          : _t('काम प्रलंबित केले', 'कार्य लंबित किया', 'Task marked pending'),
      subtitle: taskTitle,
      icon: isNowDone ? Icons.task_alt_rounded : Icons.radio_button_unchecked,
      backgroundColor:
          isNowDone ? const Color(0xFF14451D) : const Color(0xFF37474F),
    );
  }

  void _openDiseaseByName(String id) {
    final diseases = DiseaseInfo.getSugarcaneDiseases();
    final disease = diseases.firstWhere(
      (d) => d.id == id,
      orElse: () => diseases.first,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DiseaseDetailScreen(disease: disease),
      ),
    );
  }

  String _t(String mr, String hi, String en) {
    final lang = AppLocalizations.of(context).language;
    switch (lang) {
      case AppLanguage.marathi:
        return mr;
      case AppLanguage.hindi:
        return hi;
      case AppLanguage.english:
        return en;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF5),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // 1. TOP BAR: Menu | CaneCare AI | Bell | SR
              // ==========================================
              _buildTopBar(),
              const SizedBox(height: 18),

              // ==========================================
              // 2. GREETING: Namaste, Farmer! (Original First Image Design)
              // ==========================================
              _buildNamasteGreeting(),
              const SizedBox(height: 18),

              // ==========================================
              // 3. HERO CARD: Check Your Crop (Dark Green)
              // ==========================================
              _buildCheckCropCard(loc),
              const SizedBox(height: 24),

              // ==========================================
              // 4. SECTION: Explore CaneCare & Quick help
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _t('केनकेअर एक्सप्लोर करा', 'केनकेयर देखें', 'Explore CaneCare'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14451D),
                        letterSpacing: -0.3,
                      ), 
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HelpSupportScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Row(
                        children: [
                          Text(
                            _t('त्वरित मदत', 'त्वरित मदद', 'Quick help'),
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F8A50),
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: Color(0xFF0F8A50),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Twin Cards: Sugarcane Care Guide & Farmer Community (New Features!)
              Row(
                children: [
                  Expanded(child: _buildCareGuideCard()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildFarmerCommunityCard()),
                ],
              ),
              const SizedBox(height: 12),

              // Twin Cards: Weather Info & Expert Advisory
              Row(
                children: [
                  Expanded(child: _buildWeatherCard()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildAdvisoryCard()),
                ],
              ),
              const SizedBox(height: 12),

              // Full width Recent Scans Card
              _buildRecentScansCard(),
              const SizedBox(height: 12),

              // Twin Cards: Keep field & Healthy crop tips
              Row(
                children: [
                  Expanded(child: _buildKeepFieldCard()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildHealthyCropTipsCard()),
                ],
              ),
              const SizedBox(height: 24),

              // ==========================================
              // 5. SECTION: Today's Farm Tasks
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            _t("आजची शेती कामे", "आज के कृषि कार्य", "Today's Farm Tasks"),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF14451D),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: _completedTasks.length == 3
                                ? const Color(0xFFE8F5E9)
                                : const Color(0xFFF1F5EE),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _completedTasks.length == 3
                                  ? const Color(0xFF81C784)
                                  : const Color(0xFFDCE8DC),
                            ),
                          ),
                          child: Text(
                            _completedTasks.length == 3
                                ? _t('सर्व पूर्ण ✓', 'सभी पूर्ण ✓', 'All Done ✓')
                                : '${_completedTasks.length}/3 ${_t('पूर्ण', 'पूर्ण', 'Done')}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: _completedTasks.length == 3
                                  ? const Color(0xFF165228)
                                  : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _showFarmTasksOverviewModal(context);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Text(
                        _t('सर्व पहा', 'सभी देखें', 'View all'),
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F8A50),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildFarmTasksCard(),
              const SizedBox(height: 20),

              // ==========================================
              // 6. CARD: Recent Disease Alert
              // ==========================================
              _buildDiseaseAlertCard(),
              const SizedBox(height: 20),

              // ==========================================
              // 7. CARD: My Crop Health (Overview)
              // ==========================================
              _buildMyCropHealthCard(),
              const SizedBox(height: 20),

              // ==========================================
              // 7A. NEW: Sugarcane Market Trends Card
              // ==========================================
              _buildMarketTrendsCard(),
              const SizedBox(height: 24),

              // ==========================================
              // 8. SECTION: Explore Sugarcane Diseases
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _t('ऊसावरील मुख्य रोग', 'गन्ने के मुख्य रोग', 'Explore Sugarcane Diseases'),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14451D),
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _t('महाराष्ट्र मार्गदर्शक', 'महाराष्ट्र गाइड', 'Maharashtra guide'),
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5A7265),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDiseasesCarousel(),
              const SizedBox(height: 12),

              // View all diseases button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: widget.onNavigateToDiseases,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF287948), width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.grid_view_rounded,
                          color: Color(0xFF165228),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _t('सर्व रोग पहा', 'सभी रोग देखें', 'View all diseases'),
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF165228),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF165228),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ==========================================
              // 9. CARD: Agronomy Tip
              // ==========================================
              _buildAgronomyTipCard(),
              const SizedBox(height: 24),

              // ==========================================
              // 10. SECTION: Quick Access (5 Circles)
              // ==========================================
              Text(
                _t('द्रुत पर्याय', 'त्वरित सेवाएं', 'Quick Access'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF14451D),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 12),
              _buildQuickAccessCard(),
              const SizedBox(height: 20),

              // ==========================================
              // 11. BANNER: Empowering Farmers Landscape
              // ==========================================
              _buildEmpoweringFarmersBanner(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // WIDGET BUILDERS
  // -------------------------------------------------------------

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: Menu Icon + CaneCare AI Branding
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.menu_rounded,
                  color: Color(0xFF14451D),
                  size: 28,
                ),
                onPressed: widget.onOpenDrawer,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Menu',
              ),
              const SizedBox(width: 10),
              // CaneCare Logo Icon
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF14532D),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(7),
                child: Image.asset(
                  'assets/images/cane_logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.eco_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'CaneCare AI',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF14451D),
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),

        // Right: Notification Bell & Profile Avatar (SR)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bell Button with Dynamic Notification Count Badge
            ListenableBuilder(
              listenable: NotificationService(),
              builder: (context, _) {
                final unread = NotificationService().unreadCount;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2EBE2), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.notifications_none_rounded,
                          color: Color(0xFF14451D),
                          size: 22,
                        ),
                        if (unread > 0)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Color(0xFFEF4444),
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                              child: Center(
                                child: Text(
                                  unread > 9 ? '9+' : '$unread',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 10),

            // Profile Avatar: dynamic photo/preset avatar or initials
            Builder(
              builder: (ctx) {
                AuthProvider? auth;
                try {
                  auth = Provider.of<AuthProvider>(ctx, listen: true);
                } catch (_) {
                  auth = null;
                }
                final user = auth?.currentUser;
                final fullName = (user != null && user.fullName.isNotEmpty)
                    ? user.fullName
                    : (user?.email.isNotEmpty == true ? user!.email.split('@').first : 'Farmer');
                return FarmerAvatarWidget(
                  avatarPath: user?.avatarPath,
                  fullName: fullName,
                  size: 42,
                  onTap: widget.onNavigateToProfile,
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNamasteGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t('नमस्कार, शेतकरी बांधवांनो!', 'नमस्ते, किसान भाई!', 'Namaste, Farmer!'),
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: Color(0xFF14451D),
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _t('चला, आपला ऊस निरोगी व सशक्त ठेवूया.', 'आइए, अपने गन्ने को स्वस्थ रखें।', "Let's keep your sugarcane healthy."),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B8074),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckCropCard(AppLocalizations loc) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF17532F),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF17532F).withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background concentric circular rings
            Positioned.fill(
              child: CustomPaint(
                painter: _CheckCropBackgroundPainter(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dot + CHECK YOUR CROP tag
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2EE68A),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        _t('पिकाची तपासणी', 'फसल की जांच', 'CHECK YOUR CROP'),
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2EE68A),
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Heading
                  Text(
                    _t('तुमचा ऊस निरोगी आहे का?', 'क्या आपका गन्ना स्वस्थ है?', 'Is your sugarcane healthy?'),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.22,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Subtitle
                  Text(
                    _t('स्पष्ट फोटो काढा. काही सेकंदांत अचूक माहिती मिळवा.', 'स्पष्ट फोटो लें। कुछ ही सेकंड में सटीक उत्तर पाएं।', 'Take a clear photo. Get an answer in seconds.'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFD6E8DC),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Button 1: Scan Leaf (White button)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: widget.onNavigateToScan,
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        size: 20,
                        color: Color(0xFF17532F),
                      ),
                      label: Text(
                        _t('पानाचे स्कॅन करा', 'पत्ती स्कैन करें', 'Scan Leaf'),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF17532F),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Button 2: Upload from Gallery (Outline button)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: widget.onNavigateToGallery,
                      icon: const Icon(
                        Icons.image_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                      label: Text(
                        _t('गॅलरीतून निवडा', 'गैलरी से अपलोड करें', 'Upload from Gallery'),
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFF3E8259),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareGuideCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SugarcaneCareGuideScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFBBF7D0), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCFCE7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Color(0xFF14532D),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _t('मार्गदर्शक', 'मार्गदर्शिका', 'Guide'),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14532D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _t('ऊस पीक मार्गदर्शिका', 'गन्ना देखभाल गाइड', 'Care Guide'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF14532D),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              _t('४ टप्पे • कीड व काळजी', '४ चरण • कीट व देखभाल', '4 Stages • Pest & Care'),
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF16A34A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _t('लागवड ते काढणी संपूर्ण माहिती', 'बुवाई से कटाई पूरी जानकारी', 'All Stages Crop Guidance'),
              style: const TextStyle(
                fontSize: 10.5,
                color: Color(0xFF6B8074),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmerCommunityCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FarmerCommunityScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAF5),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD4E7D7), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCFCE7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.forum_rounded,
                      color: Color(0xFF16A34A),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _t('लाइव्ह चर्चा', 'लाइव चर्चा', 'Live Community'),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _t('शेतकरी कम्युनिटी', 'किसान कम्युनिटी', 'Farmer Community'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF14532D),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              _t('इतर शेतकऱ्यांशी चर्चा करा', 'अन्य किसानों से चर्चा करें', 'Connect with farmers'),
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF16A34A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _t('प्रश्न विचारा व सल्ला मिळवा', 'प्रश्न पूछें और सीखें', 'Ask & learn from peers'),
              style: const TextStyle(
                fontSize: 10.5,
                color: Color(0xFF6B8074),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard() {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WeatherScreen()),
        );
        _loadLiveWeather();
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFEDF6FD),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD2E8F8), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD3EEFC),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wb_sunny_outlined,
                    color: Color(0xFF0288D1),
                    size: 21,
                  ),
                ),
                Text(
                  _liveTemp != null ? '$_liveTemp°C' : '28°C',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF154360),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _t('हवामान माहिती', 'मौसम की जानकारी', 'Weather Info'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF153826),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_isLiveGps)
                  Container(
                    margin: const EdgeInsets.only(left: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'GPS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              _liveLocation ?? _t('सातारा, महाराष्ट्र', 'सतारा, महाराष्ट्र', 'Satara, Maharashtra'),
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1976D2),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              _t('ऊसासाठी अनुकूल हवामान', 'गन्ने के लिए अनुकूल मौसम', 'Favorable for sugarcane'),
              style: const TextStyle(
                fontSize: 10.5,
                color: Color(0xFF6B8074),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvisoryCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SugarcaneAdvisoryScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFEFFBF4),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD0F3DD), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD6F5E3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: Color(0xFF138047),
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC7F3DC),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _t('कृषितज्ञ', 'कृषि विशेषज्ञ', 'Agronomist'),
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF116937),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _t('तज्ञांचा सल्ला', 'विशेषज्ञ सलाह', 'Expert Advisory'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF153826),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              _t('थेट तज्ञांचे मार्गदर्शन', 'सीधे विशेषज्ञ मार्गदर्शन', 'Direct expert advice'),
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1B7A43),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _t('चॅट किंवा ऑडिओ कॉल', 'चैट या ऑडियो कॉल', 'Chat or Audio call'),
              style: const TextStyle(
                fontSize: 10.5,
                color: Color(0xFF6B8074),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentScansCard() {
    return GestureDetector(
      onTap: widget.onNavigateToHistory,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5EDE7), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFE4F9EE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.description_outlined,
                color: Color(0xFF138047),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _t('अलीकडील स्कॅन', 'हाल के स्कैन', 'Recent scans'),
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF153826),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _t('या आठवड्यातील २ अहवाल (नमुना)', 'इस सप्ताह के २ स्कैन (सैंपल)', '2 reports this week (Sample data)'),
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF6B8074),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF5A7265),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeepFieldCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CropTipDetailScreen(
              tip: CropTip(
                id: 'keep_field_clean',
                title: _t(
                  'तणमुक्त शेत आणि स्वच्छता व्यवस्थापन',
                  'खरपतवार मुक्त खेत और स्वच्छता प्रबंधन',
                  'Keep Field Clean & Weed-Free',
                ),
                marathiTitle: _t(
                  'किडी व रोगांपासून संरक्षणासाठी कृषी सल्ला',
                  'कीट व रोगों से सुरक्षा हेतु कृषि सलाह',
                  'Agronomy Field Sanitation Guide',
                ),
                category: _t('तण व्यवस्थापन', 'खरपतवार प्रबंधन', 'Weed Management'),
                iconKey: 'cleaning_services',
                summary: _t(
                  'उसाच्या शेतातील तण, पालापाचोळा व रोगट अवशेष वेळेवर नष्ट केल्यास कीड व रोगांचा प्रादुर्भाव ७०% पर्यंत रोखता येतो.',
                  'गन्ने के खेत से खरपतवार और सूखे अवशेष समय पर हटाने से कीट और रोगों का प्रकोप ७०% तक कम हो जाता है।',
                  'Timely weed removal, detrashing, and field sanitation prevents up to 70% of pest infestations and viral reservoirs.',
                ),
                guidelines: [
                  _t(
                    'उसाच्या सऱ्यांमधील तण वेळेवर काढून हवा व सूर्यप्रकाश खेळता ठेवा.',
                    'गन्ने की नालियों से खरपतवार हटाकर हवा और धूप का संचार बनाए रखें।',
                    'Routinely weed sugarcane furrows to improve aeration and light penetration.',
                  ),
                  _t(
                    '५ व्या व ७ व्या महिन्यात उसाचे खालचे वाळलेले पाचट (Detrashing) काढून शेतात आच्छादन करा.',
                    '५वें और ७वें महीने में नीचे की सूखी पत्तियां हटाकर खेत में मल्चिंग करें।',
                    'Perform manual detrashing of bottom dry leaves at 5 and 7 months to prevent scale insect and mealybug build-up.',
                  ),
                  _t(
                    'तांबडे कूज किंवा काणी रोगाने बाधित झालेली झाडे मुळासकट उपटून शेताबाहेर नष्ट करा.',
                    'लाल सड़न या कंडुआ रोग से ग्रसित पौधे उखाड़कर खेत से बाहर नष्ट करें।',
                    'Rogue out clumps showing red rot or smut whips completely and destroy them outside farm channels.',
                  ),
                  _t(
                    'कापणीचे विळे व अवजारे एका प्लॉटवरून दुसऱ्या प्लॉटवर नेताना निर्जंतुक करा.',
                    'कटाई के औजार एक खेत से दूसरे खेत में ले जाते समय साफ व विसंक्रमित करें।',
                    'Disinfect harvesting knives and implements with mild bleach when shifting between plots.',
                  ),
                  _t(
                    'पाटाच्या पाण्याच्या चारी व बांधांवर तण वाढू देऊ नका, यामुळे कीटकांना आश्रय मिळतो.',
                    'सिंचाई की नालियों और मेड़ों पर खरपतवार न बढ़ने दें, इससे कीटों को बढ़ावा मिलता है।',
                    'Keep irrigation laterals and furrow ridges free of weed hosts that harbor borers and pyrilla.',
                  ),
                ],
                cautionNote: _t(
                  'पाचट शेतात जाळू नका; ते सऱ्यांमध्ये दाबून कुजवावे किंवा कंपोस्ट करावे.',
                  'खेत में पत्तियों को न जलाएं; उन्हें कंपोस्ट करें या मल्चिंग में उपयोग करें।',
                  'Avoid burning sugarcane trash in the field; shred it for in-situ soil organic mulching.',
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5EDE7), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFFE4F9EE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.public,
                color: Color(0xFF138047),
                size: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _t('तणमुक्त शेत', 'खरपतवार मुक्त खेत', 'Keep field'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF153826),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _t('पिकाचे आरोग्य तपासा', 'फसल स्वास्थ्य जांचें', 'Check your crop health'),
              style: const TextStyle(
                fontSize: 10.5,
                color: Color(0xFF6B8074),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthyCropTipsCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CropTipsScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5EDE7), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFFE4F9EE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.nightlight_outlined,
                color: Color(0xFF138047),
                size: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _t('पीक आरोग्य टिप्स', 'फसल स्वास्थ्य टिप्स', 'Healthy crop tips'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF153826),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _t('रोग प्रतिबंधक उपाय', 'रोग रोकथाम के उपाय', 'Learn disease prevention'),
              style: const TextStyle(
                fontSize: 10.5,
                color: Color(0xFF6B8074),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFarmTasksOverviewModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.checklist_rounded,
                          color: Color(0xFF165228), size: 22),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _t('दैनिक शेती कामे नियोजन', 'दैनिक कृषि कार्य योजना',
                          'Daily Farm Tasks Plan'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14451D),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon:
                      const Icon(Icons.close_rounded, color: Color(0xFF6B8074)),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _t(
                'उसाच्या दर्जेदार उत्पादनासाठी दररोज सिंचन, कीड निरीक्षण व शेताची पाहणी वेळच्या वेळी पूर्ण करा.',
                'गन्ने की अच्छी उपज के लिए नियमित सिंचाई, कीट निरीक्षण और खेत की जांच समय पर करें।',
                'Perform timely irrigation, pest surveillance, and field scouting for maximum sugarcane yield.',
              ),
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF475569),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAF5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFDCE8DC)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _t('आजची प्रगती:', 'आज की प्रगति:', 'Today\'s Progress:'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF14451D),
                    ),
                  ),
                  Text(
                    '${_completedTasks.length} / 3 ${_t('कामे पूर्ण', 'कार्य पूर्ण', 'tasks done')}',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF165228),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF165228),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _t('समजले (Got it)', 'समझ गया (Got it)', 'Got It'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmTasksCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5EDE7), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTaskItem(
            index: 0,
            iconBg: const Color(0xFFE3F2FD),
            icon: Icons.science_outlined,
            iconColor: const Color(0xFF1976D2),
            title: _t('पिकाला पाणी द्या (पाणी व्यवस्थापन)',
                'फसल को पानी दें (सिंचाई प्रबंधन)', 'Water the crop'),
            subtitle: _t('ठिबक सिंचन २ तास चालू ठेवा', 'ड्रिप सिंचाई २ घंटे चलाएं',
                'Run drip cycle for 2 hours'),
          ),
          const Divider(height: 1, color: Color(0xFFF0F4F1)),
          _buildTaskItem(
            index: 1,
            iconBg: const Color(0xFFE8F5E9),
            icon: Icons.sync,
            iconColor: const Color(0xFF2E7D32),
            title: _t('ऊसाची पाने तपासा (कीड निरीक्षण)',
                'गन्ने की पत्तियां देखें (कीट निरीक्षण)',
                'Check sugarcane leaves'),
            subtitle: _t('पानांमागील तांबूस किंवा पिवळे डाग तपासा',
                'पत्तियों पर लाल या पीले धब्बे देखें',
                'Inspect for rust/yellow spots'),
          ),
          const Divider(height: 1, color: Color(0xFFF0F4F1)),
          _buildTaskItem(
            index: 2,
            iconBg: const Color(0xFFFFF3E0),
            icon: Icons.search_rounded,
            iconColor: const Color(0xFFF57C00),
            title: _t('शेताची फेरफटका मारून पाहणी करा', 'खेत का मुआयना करें',
                'Inspect the field'),
            subtitle: _t('उसाच्या वाढीची व जमिनीतील ओलावा स्थिती',
                'पौधों की वृद्धि व नमी की स्थिति', 'Inspect cane vigor and soil'),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem({
    required int index,
    required Color iconBg,
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
  }) {
    final isDone = _completedTasks.contains(index);

    return InkWell(
      onTap: () => _toggleTask(index, title),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isDone ? const Color(0xFFF4F9F4) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDone ? const Color(0xFFE8F5E9) : iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isDone ? Icons.task_alt_rounded : icon,
                color: isDone ? const Color(0xFF165228) : iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: isDone ? FontWeight.w800 : FontWeight.w700,
                      color: isDone
                          ? const Color(0xFF14451D)
                          : const Color(0xFF153826),
                      decoration: TextDecoration.none, // Never show strikethrough line
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDone
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFF6B8074),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isDone ? const Color(0xFF2E7D32) : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDone
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFCFD8DC),
                  width: 2,
                ),
              ),
              child: isDone
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseAlertCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFDBDB), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD32F2F).withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Disease Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 58,
                  height: 58,
                  child: Image.asset(
                    'assets/images/disease_yellow_leaf.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFFFFEBEE),
                      child: const Icon(
                        Icons.eco,
                        color: Color(0xFFD32F2F),
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title, Subtitle, Severity Tag
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _t('अलीकडील रोग इशारा', 'हालिया रोग चेतावनी', 'RECENT DISEASE ALERT'),
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFD32F2F),
                              letterSpacing: 0.4,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _t('मध्यम तीव्रता', 'मध्यम जोखिम', 'Medium Severity'),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF92400E),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _t('पिवळे पान रोग (Yellow Leaf)', 'पीली पत्ती रोग (Yellow Leaf)', 'Yellow Leaf Disease'),
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF153826),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 12,
                          color: Color(0xFF6B8074),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _t('शेवटचे स्कॅन: १६ एप्रिल (नमुना)', 'अंतिम स्कैन: १६ अप्रैल (सैंपल)', 'Last scan: 16 Apr (Sample)'),
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF6B8074),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Bottom Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _t('शिफारस: पोटॅश खताची मात्रा वाढवा', 'सिफारिश: पोटाश खाद की मात्रा बढ़ाएं', 'Recommended action: Apply potassium boost'),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4D6355),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _openDiseaseByName('yellow_leaf'),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF165228),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _t('अहवाल पहा', 'रिपोर्ट देखें', 'View report'),
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyCropHealthCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8F0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCCEBD7), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _t('माझ्या पिकाचे आरोग्य', 'मेरी फसल का स्वास्थ्य', 'MY CROP HEALTH'),
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF135028),
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  _t('मासिक आढावा (नमुना)', 'मासिक समीक्षा (सैंपल)', 'Monthly overview (Sample)'),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B7A49),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3 White Sub-Cards
          Row(
            children: [
              Expanded(
                child: _buildHealthStatItem(
                  iconBg: const Color(0xFFE0F2F1),
                  icon: Icons.assignment_outlined,
                  iconColor: const Color(0xFF00796B),
                  count: '12',
                  label: _t('एकूण स्कॅन', 'कुल स्कैन', 'Total scans'),
                  numberColor: const Color(0xFF153826),
                  onTap: widget.onNavigateToHistory,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildHealthStatItem(
                  iconBg: const Color(0xFFE8F5E9),
                  icon: Icons.check_rounded,
                  iconColor: const Color(0xFF2E7D32),
                  count: '9',
                  label: _t('निरोगी', 'स्वस्थ', 'Healthy'),
                  numberColor: const Color(0xFF1B7A49),
                  onTap: widget.onNavigateToHistory,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildHealthStatItem(
                  iconBg: const Color(0xFFFFEBEE),
                  icon: Icons.warning_amber_rounded,
                  iconColor: const Color(0xFFD32F2F),
                  count: '3',
                  label: _t('लक्ष द्या', 'ध्यान दें', 'Attention'),
                  numberColor: const Color(0xFFD32F2F),
                  onTap: widget.onNavigateToHistory,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthStatItem({
    required Color iconBg,
    required IconData icon,
    required Color iconColor,
    required String count,
    required String label,
    required Color numberColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: numberColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10.5,
                color: Color(0xFF6B8074),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseasesCarousel() {
    final diseases = [
      {
        'id': 'red_rot',
        'title': _t('काणी / लाल कुज', 'लाल सड़न', 'Red Rot'),
        'category': _t('गंभीर धोका', 'गंभीर जोखिम', 'High Risk'),
        'categoryColor': const Color(0xFFD32F2F),
        'image': 'assets/images/disease_red_rot.png',
      },
      {
        'id': 'rust',
        'title': _t('तांबेरा रोग', 'गेरुआ रोग', 'Rust'),
        'category': _t('बुरशीजन्य', 'कवक जनित', 'Fungal'),
        'categoryColor': const Color(0xFFD97706),
        'image': 'assets/images/disease_rust.png',
      },
      {
        'id': 'yellow_leaf',
        'title': _t('पिवळे पान रोग', 'पीली पत्ती रोग', 'Yellow Leaf'),
        'category': _t('विषाणूजन्य', 'विषाणु जनित', 'Viral'),
        'categoryColor': const Color(0xFF7C3AED),
        'image': 'assets/images/disease_yellow_leaf.png',
      },
      {
        'id': 'mosaic',
        'title': _t('मोझॅक रोग', 'मोज़ेक रोग', 'Mosaic'),
        'category': _t('मोझॅक विषाणू', 'मोज़ेक विषाणु', 'Mottling'),
        'categoryColor': const Color(0xFF0D9488),
        'image': 'assets/images/disease_mosaic.png',
      },
    ];

    return SizedBox(
      height: 145,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: diseases.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = diseases[index];
          return GestureDetector(
            onTap: () => _openDiseaseByName(item['id'] as String),
            child: Container(
              width: 108,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5EDE7), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 72,
                      child: Image.asset(
                        item['image'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFFE8F5E9),
                          child: const Icon(
                            Icons.eco,
                            color: Color(0xFF2E7D32),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['title'] as String,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF153826),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['category'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: item['categoryColor'] as Color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAgronomyTipCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF7F0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCBEAD7), width: 1.2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _t('कृषी सल्ला', 'कृषि सलाह', 'AGRONOMY TIP'),
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF135028),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _t('भरघोस उत्पादनासाठी टिप्स', 'अधिक पैदावार के लिए टिप्स', 'Healthy Crop Tips'),
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF153826),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _t('आपल्या उसाचे कीड व रोगांपासून रक्षण करण्याचे सोपे उपाय जाणून घ्या.', 'अपने गन्ने को कीट व रोगों से बचाने के आसान उपाय जानें।', 'Learn simple ways to protect your sugarcane.'),
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF536A5D),
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CropTipsScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF165228),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _t('टिप्स पहा', 'टिप्स देखें', 'Explore tips'),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Badge on Right
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: const Color(0xFFC7F2DA),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFF135028),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.agriculture_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard() {
    final items = [
      {
        'title': _t('हवामान', 'मौसम', 'Weather'),
        'icon': Icons.cloud_outlined,
        'bg': const Color(0xFFE1F0FA),
        'color': const Color(0xFF1E88E5),
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WeatherScreen()),
            ),
      },
      {
        'title': _t('तज्ञ मदत', 'विशेषज्ञ मदद', 'Expert Help'),
        'icon': Icons.support_agent_outlined,
        'bg': const Color(0xFFDDF5E7),
        'color': const Color(0xFF28A76B),
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SugarcaneAdvisoryScreen()),
            ),
      },
      {
        'title': _t('रोग माहिती', 'रोग पुस्तकालय', 'Library'),
        'icon': Icons.menu_book_outlined,
        'bg': const Color(0xFFFEF3D6),
        'color': const Color(0xFFD97706),
        'onTap': widget.onNavigateToDiseases,
      },
      {
        'title': _t('पीक काळजी', 'फसल देखभाल', 'Crop Care'),
        'icon': Icons.auto_awesome_outlined,
        'bg': const Color(0xFFD7F5E9),
        'color': const Color(0xFF0D9488),
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CropTipsScreen()),
            ),
      },
      {
        'title': _t('अहवाल', 'रिपोर्ट्स', 'Reports'),
        'icon': Icons.bookmark_outline_rounded,
        'bg': const Color(0xFFEBEBFB),
        'color': const Color(0xFF6366F1),
        'onTap': widget.onNavigateToHistory,
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5EDE7), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          return Expanded(
            child: GestureDetector(
              onTap: item['onTap'] as VoidCallback,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: item['bg'] as Color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: item['color'] as Color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      item['title'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B6053),
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmpoweringFarmersBanner() {
    return Container(
      height: 165,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F3E22).withValues(alpha: 0.15),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/sugarcane_banner_hd.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/splash_farm_landscape.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.15),
                      const Color(0xFF072714).withValues(alpha: 0.90),
                    ],
                    stops: const [0.0, 0.40, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _t('शेतकरी समृद्धी', 'किसान समृद्धि', 'EMPOWERING FARMERS'),
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4ADE80),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _t('निरोगी ऊस, भरघोस उत्पादन!', 'स्वस्थ गन्ना, बेहतर पैदावार!', 'Healthy Sugarcane, Better Harvest!'),
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _t('योग्य माहिती • वेळेवर निर्णय • प्रगतीशील शेती', 'सही जानकारी • समय पर निर्णय • उन्नत खेती', 'Right Information • Right Decision • Better Farming'),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFD1FAE5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  // =============================================================
  // NEW FEATURE 2: SUGARCANE MARKET TRENDS CARD (WITH ATTRACTIVE CHART)
  // =============================================================
  Widget _buildMarketTrendsCard() {
    final mandi = SugarcaneMarketService.instance.getMandiById(_marketSelectedMandiId);
    final allMandis = SugarcaneMarketService.instance.getAllMandis();
    final isMr = AppLocalizations.of(context).language == AppLanguage.marathi;
    final isHi = AppLocalizations.of(context).language == AppLanguage.hindi;
    final mandiName = isMr ? mandi.nameMr : (isHi ? mandi.nameHi : mandi.nameEn);

    final prices = _marketIsDailyView
        ? mandi.dailyRates.map((d) => d.avgPrice).toList()
        : mandi.monthlyRates.map((m) => m.avgPrice).toList();

    final labels = _marketIsDailyView
        ? mandi.dailyRates.map((d) {
            return isMr ? d.dateLabelMr.split(' ')[0] : (isHi ? d.dateLabelHi.split(' ')[0] : d.dateLabelEn.split(' ')[0]);
          }).toList()
        : mandi.monthlyRates.map((m) {
            return isMr ? m.monthLabelMr : (isHi ? m.monthLabelHi : m.monthLabelEn);
          }).toList();

    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final avgPrice = (prices.reduce((a, b) => a + b) / prices.length).roundToDouble();

    final now = DateTime.now();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5EDE7), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Icon + Title & Subtitle + Daily/Season Pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Color(0xFF1B5E20),
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            _t('ऊस बाजार भाव व कल', 'गन्ना बाजार भाव व रुझान', 'Sugarcane Market Trends'),
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF14451D),
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        // 🟢 LIVE Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF86EFAC)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF15803D),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 3),
                              const Text(
                                'LIVE',
                                style: TextStyle(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF15803D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _t(
                        'दररोजचे थेट बाजार भाव (${now.day}/${now.month}/${now.year})',
                        'दैनिक लाइव मंडी भाव (${now.day}/${now.month}/${now.year})',
                        'Daily live market rates (${now.day}/${now.month}/${now.year})',
                      ),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B8074),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Daily vs Season Toggle
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F6F2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFD6E3D8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _marketIsDailyView = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _marketIsDailyView ? const Color(0xFF14451D) : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          _t('दैनिक', 'दैनिक', 'Daily'),
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: _marketIsDailyView ? FontWeight.w800 : FontWeight.w600,
                            color: _marketIsDailyView ? Colors.white : const Color(0xFF5A7265),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _marketIsDailyView = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: !_marketIsDailyView ? const Color(0xFF14451D) : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          _t('हंगाम', 'सीजन', 'Season'),
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: !_marketIsDailyView ? FontWeight.w800 : FontWeight.w600,
                            color: !_marketIsDailyView ? Colors.white : const Color(0xFF5A7265),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 2. Mandi Quick Selector Chips
          SizedBox(
            height: 28,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: allMandis.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, idx) {
                final m = allMandis[idx];
                final isSelected = m.id == _marketSelectedMandiId;
                final label = isMr ? m.districtMr : (isHi ? m.nameHi.split(' ')[0] : m.districtEn);
                return GestureDetector(
                  onTap: () => setState(() => _marketSelectedMandiId = m.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE8F5E9) : const Color(0xFFF7FAF7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF15803D) : const Color(0xFFE0EAE1),
                        width: isSelected ? 1.2 : 0.8,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? const Color(0xFF15803D) : const Color(0xFF6B8074),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // 3. Price & Trend Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FBF9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE8EFE9), width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _t('आजचा थेट सरासरी दर', 'आज का लाइव औसत भाव', 'TODAY LIVE AVERAGE RATE'),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF758A7C),
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '₹${mandi.currentAvgPrice.toInt()}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF14451D),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _t('/ टन', '/ टन', '/ tonne'),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF5A7265),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$mandiName • ${_t('उतारा', 'रिकवरी', 'Recovery')} ${mandi.baseRecovery}%',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6B8074),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Compact Trend Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8EE),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFC7EED4), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.arrow_upward_rounded,
                            size: 14,
                            color: Color(0xFF15803D),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '+₹${mandi.dailyChange.toInt()}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF15803D),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _t('आजची वाढ', 'आज की बढ़त', 'today gain'),
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 4. ATTRACTIVE PRICE TREND CHART AREA
          Container(
            width: double.infinity,
            height: 105,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: CustomPaint(
              painter: _MarketTrendLineChartPainter(
                prices: prices,
                labels: labels,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 5. Mini Stats Bar: Min / Avg / Peak
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F9F4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '${_t('किमान', 'न्यूनतम', 'Min')}: ₹${minPrice.toInt()}',
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5A7265),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('•', style: TextStyle(color: Color(0xFFA5C4AE))),
                  const SizedBox(width: 8),
                  Text(
                    '${_t('सरासरी', 'औसत', 'Avg')}: ₹${avgPrice.toInt()}',
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5A7265),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('•', style: TextStyle(color: Color(0xFFA5C4AE))),
                  const SizedBox(width: 8),
                  Text(
                    '${_t('कमाल', 'उच्चतम', 'Peak')}: ₹${maxPrice.toInt()}',
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF15803D),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 6. Bottom Action: View Daily Live Market Trends
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SugarcaneMarketScreen(initialMandiId: _marketSelectedMandiId),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _t('प्रत्येक दिवसाचा लाईव्ह दर पहा', 'प्रतिदिन का लाइव भाव देखें', 'View Daily Live Market'),
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF165228),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: Color(0xFF165228),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMarketTrendsModal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SugarcaneMarketScreen(initialMandiId: _marketSelectedMandiId),
      ),
    );
  }
}

// -------------------------------------------------------------
// CUSTOM PAINTERS FOR ARTWORK
// -------------------------------------------------------------



/// Concentric rings watermark on the dark green hero card
class _CheckCropBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 32;
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.5),
      size.height * 0.72,
      ringPaint,
    );

    final innerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.5),
      size.height * 0.44,
      innerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom Painter for the smooth and beautiful Sugarcane Market Price Trend Chart
class _MarketTrendLineChartPainter extends CustomPainter {
  final List<double> prices;
  final List<String> labels;

  _MarketTrendLineChartPainter({required this.prices, required this.labels});

  @override
  void paint(Canvas canvas, Size size) {
    if (prices.isEmpty) return;

    final minVal = prices.reduce((a, b) => a < b ? a : b);
    final maxVal = prices.reduce((a, b) => a > b ? a : b);
    final diff = maxVal - minVal;
    final paddingVal = diff == 0 ? 50.0 : diff * 0.25;
    final chartMin = minVal - paddingVal;
    final chartMax = maxVal + paddingVal;
    final range = chartMax - chartMin;

    const bottomPadding = 20.0;
    const topPadding = 12.0;
    final chartHeight = size.height - bottomPadding - topPadding;
    final chartWidth = size.width;

    // 1. Draw subtle horizontal grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFE8EFE9)
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 2; i++) {
      final y = topPadding + (chartHeight * (i / 2));
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), gridPaint);
    }

    // 2. Compute coordinate points
    final points = <Offset>[];
    final stepX = chartWidth / (prices.length - 1);

    for (int i = 0; i < prices.length; i++) {
      final x = i * stepX;
      final normalized = range == 0 ? 0.5 : (prices[i] - chartMin) / range;
      final y = topPadding + chartHeight * (1.0 - normalized);
      points.add(Offset(x, y));
    }

    // 3. Build smooth cubic Bezier spline
    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX1 = p0.dx + (p1.dx - p0.dx) / 2;
      final controlY1 = p0.dy;
      final controlX2 = p0.dx + (p1.dx - p0.dx) / 2;
      final controlY2 = p1.dy;
      linePath.cubicTo(controlX1, controlY1, controlX2, controlY2, p1.dx, p1.dy);
    }

    // 4. Fill gradient below line
    final fillPath = Path.from(linePath);
    fillPath.lineTo(points.last.dx, size.height - bottomPadding);
    fillPath.lineTo(points.first.dx, size.height - bottomPadding);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF22C55E).withValues(alpha: 0.28),
          const Color(0xFF22C55E).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, topPadding, chartWidth, chartHeight));

    canvas.drawPath(fillPath, fillPaint);

    // 5. Draw line stroke
    final strokePaint = Paint()
      ..color = const Color(0xFF15803D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(linePath, strokePaint);

    // 6. Draw data dots with glow on latest point
    final dotPaint = Paint()
      ..color = const Color(0xFF15803D)
      ..style = PaintingStyle.fill;
    final dotInner = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      if (i == points.length - 1) {
        // Glowing halo on peak point
        final haloPaint = Paint()
          ..color = const Color(0xFF22C55E).withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(p, 9, haloPaint);
        canvas.drawCircle(p, 5.5, dotPaint);
        canvas.drawCircle(p, 2.5, dotInner);
      } else {
        canvas.drawCircle(p, 3.5, dotPaint);
        canvas.drawCircle(p, 1.8, dotInner);
      }
    }

    // 7. Draw month labels along X-axis
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < labels.length; i++) {
      final isCurrent = i == labels.length - 1;
      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          fontSize: 10,
          fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
          color: isCurrent ? const Color(0xFF15803D) : const Color(0xFF758A7C),
        ),
      );
      textPainter.layout();
      final x = points[i].dx - (textPainter.width / 2);
      final clampedX = x.clamp(0.0, chartWidth - textPainter.width);
      textPainter.paint(canvas, Offset(clampedX, size.height - 14));
    }
  }

  @override
  bool shouldRepaint(covariant _MarketTrendLineChartPainter oldDelegate) =>
      oldDelegate.prices != prices || oldDelegate.labels != labels;
}
