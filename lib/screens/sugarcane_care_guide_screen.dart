import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import 'ask_question_screen.dart';
import 'weather_screen.dart';
import 'farmer_community_screen.dart';

/// Screen 1: Sugarcane Care Guide (ऊस पीक मार्गदर्शिका)
/// Practical, full-lifecycle guidance from planting to harvest
/// with complete trilingual support (मराठी, हिंदी, English).
class SugarcaneCareGuideScreen extends StatefulWidget {
  const SugarcaneCareGuideScreen({super.key});

  @override
  State<SugarcaneCareGuideScreen> createState() =>
      _SugarcaneCareGuideScreenState();
}

class _SugarcaneCareGuideScreenState extends State<SugarcaneCareGuideScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _stagesSectionKey = GlobalKey();
  bool _isBookmarked = false;

  void _scrollToStages() {
    final context = _stagesSectionKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _toggleBookmark(AppLanguage lang) {
    setState(() => _isBookmarked = !_isBookmarked);

    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final msg = _isBookmarked
        ? (isMr
            ? 'ऊस मार्गदर्शिका ऑफलाइन वाचनासाठी सेव्ह केली!'
            : (isHi
                ? 'गन्ना गाइड ऑफलाइन पढ़ने के लिए सहेज ली गई!'
                : 'Care Guide saved for offline reading! (मार्गदर्शिका सेव्ह केली)'))
        : (isMr
            ? 'सेव्ह केलेल्या मार्गदर्शिकेतून काढून टाकली.'
            : (isHi
                ? 'सहेजी गई गाइड से हटा दी गई।'
                : 'Removed from saved guides. (मार्गदर्शिका काढून टाकली)'));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _isBookmarked
                  ? Icons.bookmark_added_rounded
                  : Icons.bookmark_border_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(msg),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF14532D),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final lang = loc.language;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF7),
      appBar: _buildAppBar(lang),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. Hero Banner
            _buildHeroBanner(lang),
            const SizedBox(height: 24),

            // 3. Crop Growth Stages
            Container(key: _stagesSectionKey, child: _buildGrowthStagesSection(lang)),
            const SizedBox(height: 28),

            // 4. Essential Crop Care
            _buildEssentialCareSection(lang),
            const SizedBox(height: 28),

            // 5. Common Crop Problems
            _buildCommonProblemsSection(lang),
            const SizedBox(height: 28),

            // 6. Expert Farming Tips
            _buildExpertTipsSection(lang),
            const SizedBox(height: 24),

            // 7. Weather-Based Advice
            _buildWeatherAdviceCard(lang),
            const SizedBox(height: 24),

            // 8. Ask an Expert
            _buildAskExpertCard(lang),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 1. Header (AppBar)
  // ==========================================
  PreferredSizeWidget _buildAppBar(AppLanguage lang) {
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final title = isMr
        ? 'ऊस पीक मार्गदर्शिका'
        : (isHi ? 'गन्ना फसल गाइड' : 'Sugarcane Care Guide');

    final subtitle = isMr
        ? 'लागवडीपासून तोडणीपर्यंतचे तुमचे संपूर्ण मार्गदर्शक'
        : (isHi
            ? 'बुवाई से कटाई तक का आपका संपूर्ण मार्गदर्शक'
            : 'Your guide from planting to harvest • ऊस पीक मार्गदर्शिका');

    return AppBar(
      backgroundColor: const Color(0xFFF8FAF7),
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Color(0xFF14532D),
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF14532D),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF16A34A),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isBookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_outline_rounded,
            color: _isBookmarked
                ? const Color(0xFF16A34A)
                : const Color(0xFF14532D),
          ),
          onPressed: () => _toggleBookmark(lang),
          tooltip: isMr ? 'मार्गदर्शिका सेव्ह करा' : 'Save Guide',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ==========================================
  // 2. Hero Banner
  // ==========================================
  Widget _buildHeroBanner(AppLanguage lang) {
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final badgeText = isMr
        ? 'वसंतदादा शुगर इन्स्टिट्यूट (VSI) कृषी तंत्रज्ञान'
        : (isHi
            ? 'वसंतदादा शुगर इंस्टीट्यूट (VSI) कृषि तकनीक'
            : 'VSI MAHARASHTRA AGRONOMY');

    final heading = isMr
        ? 'निरोगी ऊस पिकवा 🌱'
        : (isHi ? 'स्वस्थ गन्ना उगाएं 🌱' : 'Grow Healthy Sugarcane 🌱');

    final subtext = isMr
        ? 'जमीन पूर्वमशागत, बेणे प्रक्रिया, पाणी-खत व्यवस्थापन ते साखर कारखाना तोडणीपर्यंतचे शास्त्रीय मार्गदर्शन.'
        : (isHi
            ? 'खेत की तैयारी, बीज शोधन, जल-उर्वरक प्रबंधन से लेकर मिल कटाई तक का व्यावहारिक मार्गदर्शन।'
            : 'Practical guidance for every stage of your crop from land preparation to sugar mill harvest.');

    final btnLabel = isMr
        ? 'वाढीचे टप्पे पहा'
        : (isHi ? 'विकास के चरण देखें' : 'Explore Growing Stages');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF14532D).withValues(alpha: 0.15),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Background Image
            Image.asset(
              'assets/images/sugarcane_banner_hd.jpg',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 220,
                color: const Color(0xFF14532D),
              ),
            ),

            // Gradient Scrim
            Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    const Color(0xFF14532D).withValues(alpha: 0.70),
                    const Color(0xFF0F3E1E).withValues(alpha: 0.94),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subtitle pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7).withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFDCFCE7).withValues(alpha: 0.35),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.eco_rounded,
                            size: 14, color: Color(0xFFDCFCE7)),
                        const SizedBox(width: 6),
                        Text(
                          badgeText,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFDCFCE7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Main Title
                  Text(
                    heading,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Description
                  Text(
                    subtext,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFE2EBE2),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Button: Explore Growing Stages
                  ElevatedButton.icon(
                    onPressed: _scrollToStages,
                    icon: const Icon(Icons.arrow_downward_rounded, size: 16),
                    label: Text(btnLabel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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

  // ==========================================
  // 3. Crop Growth Stages (2-column Grid)
  // ==========================================
  Widget _buildGrowthStagesSection(AppLanguage lang) {
    final stages = _getGrowthStages();

    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final heading = isMr
        ? 'ऊस वाढीचे ४ मुख्य टप्पे'
        : (isHi ? 'गन्ना वृद्धि के ४ मुख्य चरण' : 'Crop Growth Stages');

    final subHeading = isMr
        ? 'महाराष्ट्रातील १२ ते १४ महिन्यांचे ऊस पीक जीवनचक्र'
        : (isHi
            ? 'महाराष्ट्र में १२ से १४ महीने का गन्ना जीवन चक्र'
            : 'Standard 12 to 14-month sugarcane cultivation lifecycle in Maharashtra');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              heading,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF14532D),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isMr ? '(वाढीचे मुख्य टप्पे)' : (isHi ? '(मुख्य चरण)' : ''),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF16A34A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subHeading,
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B8074)),
        ),
        const SizedBox(height: 14),

        // 2-column Grid of Stage Cards
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 14,
            mainAxisExtent: 275,
          ),
          itemBuilder: (context, index) {
            final stage = stages[index];
            return _buildStageCard(stage, lang);
          },
        ),
      ],
    );
  }

  Widget _buildStageCard(_GrowthStage stage, AppLanguage lang) {
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final displayTitle = isMr
        ? stage.marathiTitle
        : (isHi ? stage.hindiTitle : stage.title);

    final displayDuration = isMr
        ? stage.marathiDuration
        : (isHi ? stage.hindiDuration : stage.duration);

    final displayDesc = isMr
        ? stage.marathiDescription
        : (isHi ? stage.hindiDescription : stage.description);

    final btnLabel = isMr ? 'मार्गदर्शक पहा' : (isHi ? 'गाइड देखें' : 'View Guide');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EBE2), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Number badge
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.asset(
                  stage.imagePath,
                  height: 105,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 105,
                    color: const Color(0xFFDCFCE7),
                    child: const Icon(Icons.grass_rounded,
                        color: Color(0xFF16A34A), size: 36),
                  ),
                ),
              ),

              // Stage number badge
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF14532D).withValues(alpha: 0.90),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFFDCFCE7).withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'STAGE ${stage.number}',
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayTitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14532D),
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  displayDuration,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF16A34A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayDesc,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF475569),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _showStageDetailsModal(stage, lang),
                  borderRadius: BorderRadius.circular(6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        btnLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF14532D),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 11,
                        color: Color(0xFF14532D),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showStageDetailsModal(_GrowthStage stage, AppLanguage lang) {
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final displayTitle = isMr
        ? stage.marathiTitle
        : (isHi ? stage.hindiTitle : stage.title);

    final displayDuration = isMr
        ? stage.marathiDuration
        : (isHi ? stage.hindiDuration : stage.duration);

    final steps = isMr
        ? stage.marathiDetailedSteps
        : (isHi ? stage.hindiDetailedSteps : stage.detailedSteps);

    final modalHeader = isMr
        ? 'टप्पा ${stage.number} तपशील'
        : (isHi ? 'चरण ${stage.number} विवरण' : 'Stage ${stage.number} Details');

    final checklistHeading = isMr
        ? 'शेतकऱ्यांसाठी महत्त्वाच्या पायऱ्या:'
        : (isHi ? 'किसानों के लिए प्रमुख कदम:' : 'Key Practices & Field Checklist:');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.78,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        modalHeader,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF14532D),
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                      splashRadius: 18,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE2EBE2)),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      displayTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14532D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayDuration,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Stage Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        stage.imagePath,
                        height: 170,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 18),

                    Text(
                      checklistHeading,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 10),

                    ...steps.map(
                      (step) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 18,
                              color: Color(0xFF16A34A),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                step,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF334155),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // 4. Essential Crop Care (4 compact cards)
  // ==========================================
  Widget _buildEssentialCareSection(AppLanguage lang) {
    final items = _getCareItems();
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final heading = isMr
        ? 'अत्यावश्यक पीक काळजी'
        : (isHi ? 'आवश्यक फसल देखभाल' : 'Essential Crop Care');

    final subHeading = isMr
        ? 'उत्तम उसाच्या उत्पादनासाठी ४ प्रमुख व्यवस्थापने'
        : (isHi
            ? 'उत्कृष्ट गन्ना उत्पादन के लिए ४ मुख्य प्रबंधन'
            : 'Core management practices for maximum sugarcane yield and sugar recovery');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              heading,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF14532D),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isMr ? '(पीक काळजी)' : (isHi ? '(देखभाल)' : ''),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF16A34A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subHeading,
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B8074)),
        ),
        const SizedBox(height: 14),

        // Vertical compact cards
        ...items.map((item) => _buildCareCard(item, lang)),
      ],
    );
  }

  Widget _buildCareCard(_CareItem item, AppLanguage lang) {
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final displayTitle = isMr
        ? item.marathiTitle
        : (isHi ? item.hindiTitle : item.title);

    final displayDesc = isMr
        ? item.marathiDesc
        : (isHi ? item.hindiDesc : item.desc);

    final btnLabel = isMr ? 'अधिक माहिती' : (isHi ? 'और जानें' : 'Learn More');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EBE2), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 22),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14532D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayDesc,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF475569),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () => _showCareDetailsDialog(item, lang),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        btnLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 14,
                        color: Color(0xFF16A34A),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCareDetailsDialog(_CareItem item, AppLanguage lang) {
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final displayTitle = isMr
        ? item.marathiTitle
        : (isHi ? item.hindiTitle : item.title);

    final displayDetails = isMr
        ? item.marathiDetails
        : (isHi ? item.hindiDetails : item.details);

    final closeText = isMr ? 'समजले (बंद करा)' : (isHi ? 'ठीक है' : 'Close');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  displayTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14532D),
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              displayDetails,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Color(0xFF334155),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                closeText,
                style: const TextStyle(
                  color: Color(0xFF14532D),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // 5. Common Crop Problems (Image Cards)
  // ==========================================
  Widget _buildCommonProblemsSection(AppLanguage lang) {
    final problems = _getCommonProblems();
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final heading = isMr
        ? 'उसाच्या सामान्य समस्या'
        : (isHi ? 'गन्ने की सामान्य समस्याएं' : 'Common Crop Problems');

    final subHeading = isMr
        ? 'लक्षणे ओळखा आणि प्राथमिक शास्त्रीय उपाययोजना करा'
        : (isHi
            ? 'लक्षण पहचानें और प्राथमिक प्रबंधन उपाय करें'
            : 'Informational guidance for early symptoms (not confirmed diagnosis)');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              heading,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF14532D),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isMr ? '(सामान्य समस्या)' : (isHi ? '(समस्याएं)' : ''),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF16A34A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subHeading,
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B8074)),
        ),
        const SizedBox(height: 14),

        // Horizontal list of problem cards
        SizedBox(
          height: 275,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: problems.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final prob = problems[index];
              final displayTitle = isMr
                  ? prob.marathiTitle
                  : (isHi ? prob.hindiTitle : prob.title);

              final displayDesc = isMr
                  ? prob.marathiDesc
                  : (isHi ? prob.hindiDesc : prob.desc);

              final btnLabel = isMr
                  ? 'मार्गदर्शन पहा'
                  : (isHi ? 'मार्गदर्शन देखें' : 'View Guidance');

              return Container(
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: const Color(0xFFE2EBE2), width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.asset(
                        prob.imagePath,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayTitle,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF14532D),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            prob.tag,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            displayDesc,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF475569),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            height: 30,
                            child: OutlinedButton(
                              onPressed: () => _showProblemGuidance(prob, lang),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF16A34A),
                                side: const BorderSide(
                                    color: Color(0xFF16A34A), width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: Text(
                                btnLabel,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showProblemGuidance(_ProblemItem prob, AppLanguage lang) {
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final displayTitle = isMr
        ? prob.marathiTitle
        : (isHi ? prob.hindiTitle : prob.title);

    final displayGuidance = isMr
        ? prob.marathiGuidance
        : (isHi ? prob.hindiGuidance : prob.guidance);

    final advisoryNotice = isMr
        ? 'सूचना: ही केवळ प्राथमिक माहिती आहे. अधिक खात्रीसाठी CaneCare AI द्वारे पानाचा फोटो स्कॅन करा.'
        : (isHi
            ? 'नोट: यह प्रारंभिक जानकारी है। पुष्टि के लिए CaneCare AI से पत्ती स्कैन करें।'
            : 'Note: Informational guide only. Use CaneCare AI leaf scanner for AI disease confirmation.');

    final closeText = isMr ? 'समजले (बंद करा)' : (isHi ? 'ठीक है' : 'Close');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          title: Text(
            displayTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF14532D),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    prob.imagePath,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  displayGuidance,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          size: 16, color: Color(0xFFD97706)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          advisoryNotice,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF92400E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                closeText,
                style: const TextStyle(
                  color: Color(0xFF14532D),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // 6. Expert Farming Tips (Maharashtra relevant)
  // ==========================================
  Widget _buildExpertTipsSection(AppLanguage lang) {
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final heading = isMr
        ? 'तज्ञांच्या खास शेती टिप्स'
        : (isHi ? 'विशेषज्ञों के प्रमुख कृषि सुझाव' : 'Expert Farming Tips');

    final subHeading = isMr
        ? 'महाराष्ट्रातील ऊस उत्पादक शेतकऱ्यांसाठी सिद्ध झालेले अनुभव'
        : (isHi
            ? 'महाराष्ट्र के गन्ना किसानों के लिए व्यावहारिक अनुभव'
            : 'Field-tested agronomic practices for Western & Central Maharashtra');

    final tips = [
      {
        'title': isMr
            ? 'पाचट आच्छादन तंत्रज्ञान (Trash Mulching)'
            : (isHi
                ? 'सूखी पत्ती मल्चिंग तकनीक'
                : 'Trash Mulching for Water Conservation'),
        'desc': isMr
            ? 'पाचट न जाळता सऱ्यांमध्ये पसरल्यास ८०% तण थांबते, ३०% पाणी बचत होते आणि जमिनीतील जिवाणू वाढतात.'
            : (isHi
                ? 'पत्तियां जलाने के बजाय बिछाने से ८०% खरपतवार नियंत्रण और ३०% जल बचत होती है।'
                : 'Never burn cane trash. Spreading dry leaves in alternate furrows suppresses weeds by 80% and retains critical summer moisture.'),
        'tag': isMr ? 'पाणी बचत' : (isHi ? 'जल बचत' : 'Water Saving'),
      },
      {
        'title': isMr
            ? 'वेळेवर मोठी बांधणी करा (Earthing Up)'
            : (isHi
                ? 'समय पर मिट्टी चढ़ाना'
                : 'Earthing Up at 120-135 Days'),
        'desc': isMr
            ? '१२० ते १३५ दिवसांच्या आत मोठी बांधणी केल्याने उसाची मुळे मजबूत होतात आणि वादळी वाऱ्यात ऊस लोळत नाही.'
            : (isHi
                ? '१२० से १३५ दिनों में मिट्टी चढ़ाने से जड़ें मजबूत होती हैं और गन्ना गिरता नहीं है।'
                : 'Complete earthing up before 135 days. This provides anchorage, prevents lodging during monsoons, and buries shoot borer larvae.'),
        'tag': isMr ? 'पीक स्थैर्य' : (isHi ? 'फसल सुरक्षा' : 'Lodging Prevention'),
      },
      {
        'title': isMr
            ? 'जोडओळ पट्टा पद्धत (Paired Row Planting)'
            : (isHi
                ? 'पट्टा रोपण विधि'
                : 'Paired-Row (पट्टा पद्धत) for High Yield'),
        'desc': isMr
            ? '२.५ x ५ फूट पट्टा पद्धतीमुळे सूर्यप्रकाश भरपूर मिळतो, ट्रॅक्टर मशागत सोपी होते आणि हरभरा/सोयाबीन आंतरपीक घेता येते.'
            : (isHi
                ? '२.५ x ५ फीट पट्टा विधि से भरपूर धूप मिलती है और दलहनी अंतरफसल ली जा सकती है।'
                : 'Adopt 2.5 ft x 5 ft paired row planting. It allows tractor interculturing, saves water, and enables profitable chickpea intercropping.'),
        'tag': isMr ? 'अधिक उत्पादन' : (isHi ? 'उच्च उत्पादन' : 'High Yield'),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              heading,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF14532D),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isMr ? '(खास टिप्स)' : (isHi ? '(सुझाव)' : ''),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF16A34A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subHeading,
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B8074)),
        ),
        const SizedBox(height: 14),

        ...tips.map(
          (tip) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2EBE2), width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.eco_rounded,
                    color: Color(0xFF16A34A),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              tip['title']!,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF14532D),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tip['tag']!,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        tip['desc']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF475569),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 7. Weather-Based Advice
  // ==========================================
  Widget _buildWeatherAdviceCard(AppLanguage lang) {
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final title = isMr
        ? 'हवामान आधारित शेती सल्ला'
        : (isHi ? 'मौसम आधारित कृषि सलाह' : 'Weather-Based Advice');

    final advisory = isMr
        ? 'सध्या ढगाळ वातावरण आणि आर्द्रता जास्त असल्यामुळे तांबेरा रोगाची शक्यता आहे. दुपारनंतर फवारणी टाळा.'
        : (isHi
            ? 'वर्तमान में बादल और उच्च आर्द्रता के कारण गेरुआ रोग का खतरा है। दोपहर बाद छिड़काव से बचें।'
            : 'Moderate humidity expected this week across Western Maharashtra. Inspect for rust spores before applying top-dress urea.');

    final btnLabel = isMr ? 'हवामान पहा' : (isHi ? 'मौसम देखें' : 'View Weather');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF6FD),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD2E8F8), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0xFFD3EEFC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wb_sunny_outlined,
                  color: Color(0xFF0288D1),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF154360),
                      ),
                    ),
                    Text(
                      isMr ? 'स्थानिक हवामान अंदाज' : 'Live Local Agricultural Forecast',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            advisory,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF334155),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WeatherScreen()),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      btnLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0288D1),
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: Color(0xFF0288D1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 8. Ask an Expert
  // ==========================================
  Widget _buildAskExpertCard(AppLanguage lang) {
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final title = isMr
        ? 'पिकाबद्दल काही मदत हवी आहे का?'
        : (isHi ? 'क्या फसल से जुड़ी सहायता चाहिए?' : 'Need help with your crop?');

    final subtext = isMr
        ? 'ऊस शेतीतील शंका थेट कृषी तज्ञांना किंवा शेतकरी बांधवांना विचारा.'
        : (isHi
            ? 'गन्ना खेती के सवाल सीधे कृषि विशेषज्ञों या साथी किसानों से पूछें।'
            : 'Get guidance for your sugarcane farming questions directly from verified agronomists.');

    final btnExpert = isMr
        ? 'तज्ञांना विचारा'
        : (isHi ? 'विशेषज्ञ से पूछें' : 'Ask Expert');

    final btnCommunity = isMr ? 'कम्युनिटी' : (isHi ? 'समुदाय' : 'Community');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF14532D),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF14532D).withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF16A34A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      isMr ? 'ऊस तज्ञांचा थेट सल्ला' : 'Direct Agronomist Help',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFDCFCE7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtext,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFFE2EBE2),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AskQuestionScreen()),
                      );
                    },
                    icon: const Icon(Icons.support_agent_rounded, size: 16),
                    label: Text(btnExpert),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const FarmerCommunityScreen()),
                      );
                    },
                    icon: const Icon(Icons.forum_rounded,
                        size: 16, color: Colors.white),
                    label: Text(
                      btnCommunity,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color(0xFF22C55E), width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // DATA PROVIDERS
  // ==========================================
  List<_GrowthStage> _getGrowthStages() {
    return [
      _GrowthStage(
        number: '01',
        title: 'Land Preparation',
        marathiTitle: 'जमीन पूर्वमशागत',
        hindiTitle: 'खेत की तैयारी',
        duration: '0 - 15 Days Before',
        marathiDuration: 'लागवडीपूर्वी ० ते १५ दिवस',
        hindiDuration: 'बुवाई से ०-१५ दिन पहले',
        description:
            'Deep summer ploughing, 2-3 harrowing passes, broad ridges (4-5 ft), and 15 t/ha well-rotted FYM.',
        marathiDescription:
            'खोल उन्हाळी नांगरट, २-३ कुळवाच्या पाळ्या, रुंद सऱ्या (४-५ फूट) आणि १५ टन/हेक्टर शेणखत.',
        hindiDescription:
            'गहरी ग्रीष्मकालीन जुताई, २-३ हैरोइंग, ४-५ फीट चौड़ी नालियां और १५ टन गोबर खाद।',
        imagePath: 'assets/images/care_stage_land_prep.jpg',
        detailedSteps: [
          'Plough soil up to 35-40 cm depth to break hard subsoil pan.',
          'Apply 15-20 tonnes well decomposed cow dung manure / compost.',
          'Form ridges and furrows at 4 ft or 5 ft spacing for tractor interculturing.',
          'Perform soil testing for pH, electrical conductivity, and organic carbon.',
        ],
        marathiDetailedSteps: [
          'जमिनीतील कडक थर फोडण्यासाठी ३५ ते ४० सेमी खोल नांगरट करा.',
          'प्रति हेक्टरी १५ ते २० टन चांगले कुजलेले शेणखत किंवा कंपोस्ट मिसळा.',
          'ट्रॅक्टरने आंतरमशागत करण्यासाठी ४ किंवा ५ फूट अंतरावर सऱ्या पाडा.',
          'मातीचा सामू (pH), क्षारता व सेंद्रिय कर्ब तपासण्यासाठी माती परीक्षण करा.',
        ],
        hindiDetailedSteps: [
          'जमीन की कठोर परत तोडने के लिए ३५-४० सेमी गहरी जुताई करें।',
          'प्रति हेक्टेयर १५-२० टन अच्छी तरह सड़ा हुआ गोबर खाद मिलाएं।',
          'ट्रैक्टर संचालन के लिए ४ या ५ फीट की दूरी पर नालियां बनाएं।',
          'मृदा परीक्षण कराकर पीएच, लवणता और कार्बन की जांच करें।',
        ],
      ),
      _GrowthStage(
        number: '02',
        title: 'Planting & Germination',
        marathiTitle: 'बेणे निवड व लागवड',
        hindiTitle: 'बीज चयन और बुवाई',
        duration: 'Day 1 - 45 Days',
        marathiDuration: '१ ते ४५ दिवस',
        hindiDuration: '१ से ४५ दिन',
        description:
            'Healthy 2-bud setts treatment with Carbendazim + Malathion. Inline drip placement.',
        marathiDescription:
            'कार्बेन्डाझिम + मॅलाथिऑनने २-डोळा बेणे प्रक्रिया. इनलाईन ठिबक सिंचन.',
        hindiDescription:
            'कार्बेन्डाजिम + मैलाथियान से २-आंख बीज शोधन। इनलाइन ड्रिप सिंचाई।',
        imagePath: 'assets/images/care_stage_planting.jpg',
        detailedSteps: [
          'Select fresh 2-bud seed setts from a 9-10 month disease-free crop.',
          'Dip setts in solution of 100g Carbendazim + 150ml Malathion in 100L water for 15 mins.',
          'Place setts end-to-end in furrows with buds facing sideways.',
          'Cover with 2-3 inches soil and provide light germination irrigation immediately.',
        ],
        marathiDetailedSteps: [
          '९ ते १० महिने वयाच्या निरोगी उसाची २-डोळ्यांची ताजी बेणी निवडा.',
          '१०० लिटर पाण्यात १०० ग्रॅम कार्बेन्डाझिम + १५० मिली मॅलाथिऑन द्रावणात १५ मिनिटे बेणे बुडवा.',
          'सऱ्यांमध्ये डोळे बाजूला राहतील अशा प्रकारे बेणे सरळ जोडून लावा.',
          '२-३ इंच मातीने झाका आणि लगेच हलके ओलिताचे पाणी द्या.',
        ],
        hindiDetailedSteps: [
          '९-१० महीने की स्वस्थ फसल से २-आंख वाले ताजे बीज टुकड़े चुनें।',
          '१०० लीटर पानी में १०० ग्राम कार्बेन्डाजिम + १५० मिली मैलाथियान में १५ मिनट उपचारित करें।',
          'नालियों में आंखें अगल-बगल रखकर टुकड़े बिछाएं।',
          '२-३ इंच मिट्टी से ढककर तुरंत हल्की सिंचाई करें।',
        ],
      ),
      _GrowthStage(
        number: '03',
        title: 'Tillering & Grand Growth',
        marathiTitle: 'फुटवे व मोठी वाढ',
        hindiTitle: 'कल्ले निकलना और मुख्य वृद्धि',
        duration: '60 - 240 Days',
        marathiDuration: '६० ते २४० दिवस',
        hindiDuration: '६० से २४० दिन',
        description:
            'Earthing up (मोठी बांधणी) at 120 days, tiller thinning, trash mulching & balanced NPK splits.',
        marathiDescription:
            '१२० दिवसांनी मोठी बांधणी, फुटवे विरळणी, पाचट आच्छादन व खतांचे नियोजन.',
        hindiDescription:
            '१२० दिनों पर मिट्टी चढ़ाना, कल्लों की छंटाई, पत्ती मल्चिंग और उर्वरक प्रबंधन।',
        imagePath: 'assets/images/care_stage_growth.jpg',
        detailedSteps: [
          'Thin out weak tillers to maintain 85,000-90,000 canes per hectare.',
          'Perform Earthing Up (मोठी बांधणी) at 120-135 days to support canes against wind.',
          'Spread sugarcane trash in alternate furrows to preserve 30% soil moisture.',
          'Complete top-dress nitrogen and potash split fertilization before 150 days.',
        ],
        marathiDetailedSteps: [
          'प्रति हेक्टरी ८५,००० ते ९०,००० ऊस राहण्यासाठी कमकुवत फुटवे काढा.',
          'ऊस वादळात लोळू नये म्हणून १२० ते १३५ दिवसांनी मोठी बांधणी करा.',
          '३०% ओलावा टिकवून ठेवण्यासाठी सऱ्यांमध्ये उसाचे पाचट पसरा.',
          '१५० दिवसांच्या आत नत्र आणि पालाशच्या खतांचे हप्ते पूर्ण करा.',
        ],
        hindiDetailedSteps: [
          'प्रति हेक्टेयर ८५,०००-९०,००० गन्ने रखने हेतु कमजोर कल्ले निकालें।',
          'तेज हवा से बचाने हेतु १२०-१३५ दिनों पर अच्छी तरह मिट्टी चढ़ाएं।',
          '३०% नमी संरक्षण हेतु नालियों में सूखी पत्तियां बिछाएं।',
          '१५० दिनों से पहले यूरिया और पोटाश के चरणबद्ध डोज पूरे करें।',
        ],
      ),
      _GrowthStage(
        number: '04',
        title: 'Maturation & Harvest',
        marathiTitle: 'ऊस तोडणी व गाळप',
        hindiTitle: 'परिपक्वता और कटाई',
        duration: '12 - 14 Months',
        marathiDuration: '१२ ते १४ महिने',
        hindiDuration: '१२ से १४ महीने',
        description:
            'Hand refractometer Brix check (>18-20%). Ground-level harvesting for high sugar recovery.',
        marathiDescription:
            'हँड रिफ्रॅक्टोमीटरने ब्रिक्स तपासणी (>१८-२०%). जमिनीलगत तोडणी.',
        hindiDescription:
            'हैंड रिफ्रैक्टोमीटर से ब्रिक्स जांच (>१८-२०%)। जमीनी स्तर पर कटाई।',
        imagePath: 'assets/images/care_stage_harvest.jpg',
        detailedSteps: [
          'Stop irrigation 12-15 days before harvest to concentrate sucrose in stalks.',
          'Test cane brix with a hand refractometer (>18-20% indicates optimal maturity).',
          'Cut canes flush with ground level; the bottom 3 internodes contain highest sugar.',
          'Transport cut canes to sugar mill within 24 hours to prevent inversion loss.',
        ],
        marathiDetailedSteps: [
          'उसातील साखर वाढवण्यासाठी तोडणीपूर्वी १२-१५ दिवस पाणी देणे थांबवा.',
          'हँड रिफ्रॅक्टोमीटरने ब्रिक्स तपासा (>१८-२०% ब्रिक्स म्हणजे योग्य पक्वता).',
          'जमिनीलगत ऊस कापा; खालच्या ३ कांड्यांमध्ये सर्वाधिक साखर असते.',
          'वजन व साखर घट टाळण्यासाठी तोडलेला ऊस २४ तासांच्या आत कारखान्यात पोहोचवा.',
        ],
        hindiDetailedSteps: [
          'मिठास बढ़ाने के लिए कटाई से १२-१५ दिन पहले सिंचाई बंद करें।',
          'हैंड रिफ्रैक्टोमीटर से ब्रिक्स जांचें (>१८-२०% ब्रिक्स उपयुक्त परिपक्वता है)।',
          'गन्ने को बिल्कुल जमीन की सतह से काटें, नीचे के पोरों में अधिक शर्करा होती है।',
          'वजन और शर्करा नुकसान से बचने के लिए २४ घंटे में मिल पहुंचाएं।',
        ],
      ),
    ];
  }

  List<_CareItem> _getCareItems() {
    return [
      _CareItem(
        title: 'Irrigation Management',
        marathiTitle: 'पाणी व्यवस्थापन',
        hindiTitle: 'सिंचाई प्रबंधन',
        icon: Icons.water_drop_outlined,
        iconBg: const Color(0xFFEFF6FF),
        iconColor: const Color(0xFF2563EB),
        desc:
            'Critical intervals: formative stage (7-8 days summer) and trash mulching.',
        marathiDesc:
            'उन्हाळ्यात ७-८ दिवसांनी पाणी किंवा ठिबक सिंचनाने ६०% पाण्याची बचत.',
        hindiDesc:
            'गर्मियों में ७-८ दिनों में पानी या ड्रिप से ६०% जल बचत।',
        details:
            'Sugarcane requires 2000-2500 mm water throughout its lifecycle. Drip irrigation saves up to 55-60% water while increasing yield by 20-30%. During tillering and grand growth, avoid water stress.',
        marathiDetails:
            'उसाला संपूर्ण हंगामात २००० ते २५०० मिमी पाण्याची गरज असते. ठिबक सिंचनामुळे ५५ ते ६०% पाणी वाचते आणि २० ते ३०% उत्पादन वाढते. फुटवे फुटण्याच्या आणि वाढीच्या काळात पाण्याचा ताण पडू देऊ नका.',
        hindiDetails:
            'गन्ने को पूरे जीवनकाल में २०००-२५०० मिमी पानी की आवश्यकता होती है। ड्रिप सिंचाई से ५५-६०% पानी बचता है और पैदावार २०-३०% बढ़ती है।',
      ),
      _CareItem(
        title: 'Nutrient Management',
        marathiTitle: 'खत व पोषण व्यवस्थापन',
        hindiTitle: 'उर्वरक प्रबंधन',
        icon: Icons.grain_rounded,
        iconBg: const Color(0xFFF0FDF4),
        iconColor: const Color(0xFF16A34A),
        desc:
            'Balanced 250:115:115 kg/ha NPK split into 4 critical crop growth stages.',
        marathiDesc:
            'माती परीक्षणानुसार २५०:११५:११५ NPK खतमात्रा ४ हप्त्यांमध्ये विभागून द्या.',
        hindiDesc:
            '२५०:११५:११५ एनपीके मात्रा ४ चरणों में विभाजित कर दें।',
        details:
            'Apply 10% N at planting, 40% N + 100% P + 50% K at 6-8 weeks, 10% N at 12-14 weeks, and remaining 40% N + 50% K at final earthing up (120-135 days). Micronutrients (Zn, Fe) boost tiller vigor.',
        marathiDetails:
            'लागवडीच्या वेळी १०% नत्र, ६-८ आठवड्यांनी ४०% नत्र + १००% स्फुरद + ५०% पालाश, १२-१४ आठवड्यांनी १०% नत्र आणि मोठ्या बांधणीच्या वेळी उरलेले ४०% नत्र + ५०% पालाश द्या. झिंक व फेरसमुळे फुटवे जोमदार येतात.',
        hindiDetails:
            'बुवाई पर १०% यूरिया, ६-८ सप्ताह में ४०% यूरिया + पूरा फास्फोरस + ५०% पोटाश, और अंतिम मिट्टी चढ़ाते समय शेष उर्वरक दें।',
      ),
      _CareItem(
        title: 'Weed Management',
        marathiTitle: 'तण नियंत्रण',
        hindiTitle: 'खरपतवार नियंत्रण',
        icon: Icons.grass_rounded,
        iconBg: const Color(0xFFFEF3C7),
        iconColor: const Color(0xFFD97706),
        desc:
            'Pre-emergence Atrazine spray followed by 120-day trash mulching.',
        marathiDesc:
            'लागवडीनंतर ॲट्राझिन फवारणी व नंतर पाचट आच्छादनाने तण ८०% रोखा.',
        hindiDesc:
            'बुवाई के बाद एट्राजिन और बाद में पत्ती मल्चिंग से खरपतवार रोकें।',
        details:
            'Spray Atrazine 50% WP @ 2 kg/ha within 3-4 days of planting on moist soil. Interculturing at 30 and 60 days keeps furrows clean until canopy closure.',
        marathiDetails:
            'लागवडीनंतर ३-४ दिवसांत ओलसर जमिनीत ॲट्राझिन ५०% डब्ल्यूपी २ किलो/हेक्टर फवारा. ३० आणि ६० दिवसांनी कोळपणी करून सऱ्या स्वच्छ ठेवा.',
        hindiDetails:
            'बुवाई के ३-४ दिन के भीतर नम मिट्टी पर एट्राजिन ५०% का २ किलो/हेक्टेयर छिड़काव करें। ३० और ६० दिनों पर गुड़ाई करें।',
      ),
      _CareItem(
        title: 'Pest & Disease Monitoring',
        marathiTitle: 'कीड व रोग नियंत्रण',
        hindiTitle: 'कीट और रोग नियंत्रण',
        icon: Icons.bug_report_outlined,
        iconBg: const Color(0xFFFEE2E2),
        iconColor: const Color(0xFFDC2626),
        desc:
            'Scouting for early shoot borer, rust spores, white grub, and smut whips.',
        marathiDesc:
            'खोडकीड, तांबेरा, हुमणी व काणी रोगासाठी नियमित शेताची पाहणी करा.',
        hindiDesc:
            'तना छेदक, गेरुआ, सफेद लट और कंडुआ रोग के लिए नियमित निगरानी करें।',
        details:
            'Install pheromone traps (10/ha) for shoot borer. For rust, spray Mancozeb 75% WP @ 2.5g/L. For white grub, apply Metarhizium anisopliae bio-control with FYM.',
        marathiDetails:
            'खोडकिडीसाठी हेक्टरी १० कामगंध सापळे लावा. तांबेरा रोगासाठी मॅन्कोझेब २.५ ग्रॅम/लिटर फवारा. हुमणीसाठी मेटारायझियम बुरशी शेणखतात मिसळून द्या.',
        hindiDetails:
            'तना छेदक हेतु फेरोमोन ट्रैप लगाएं। गेरुआ के लिए मैंकोजेब २.५ ग्राम/लीटर का छिड़काव करें। सफेद लट के लिए मेटाराइजियम का प्रयोग करें।',
      ),
    ];
  }

  List<_ProblemItem> _getCommonProblems() {
    return [
      _ProblemItem(
        title: 'Leaf Discoloration',
        marathiTitle: 'पानांचा पिवळेपणा',
        hindiTitle: 'पत्तियों का पीलापन',
        tag: 'Nutritional / Chlorosis',
        desc:
            'Uniform yellowing of young leaves typically caused by iron deficiency or waterlogging.',
        marathiDesc:
            'लोहाची कमतरता किंवा पाणी साचल्यामुळे उसाची कोवळी पाने पिवळी पडतात.',
        hindiDesc:
            'आयरन की कमी या जलभराव के कारण नई पत्तियां पीली पड़ जाती हैं।',
        imagePath: 'assets/images/disease_yellow_leaf.png',
        guidance:
            'Correct iron chlorosis by spraying Ferrous Sulphate (FeSO4) @ 0.5% (5g/L) + Citric Acid (1g/L) twice at 10-day intervals. Improve drainage if standing water is observed.',
        marathiGuidance:
            'लोहाच्या कमतरतेसाठी ५ ग्रॅम हिराकस (फेरस सल्फेट) + १ ग्रॅम सायट्रिक ॲसिड प्रति लिटर पाण्यात मिसळून १० दिवसांच्या अंतराने २ फवारण्या करा. सऱ्यांमधील पाण्याचा निचरा करा.',
        hindiGuidance:
            'आयरन की कमी हेतु फेरस सल्फेट ५ ग्राम + साइट्रिक एसिड १ ग्राम प्रति लीटर पानी का छिड़काव करें। जल निकासी सुनिश्चित करें।',
      ),
      _ProblemItem(
        title: 'Leaf Spots & Rust',
        marathiTitle: 'तांबेरा व पानावरील डाग',
        hindiTitle: 'गेरुआ और धब्बे',
        tag: 'Fungal Condition',
        desc:
            'Reddish-brown pustules and elongate lesions appearing on both leaf surfaces during humid weather.',
        marathiDesc:
            'दमट वातावरणात पानाच्या दोन्ही बाजूंवर तांबूस तपकिरी डाग आणि फोड दिसतात.',
        hindiDesc:
            'आर्द्र मौसम में पत्तियों के दोनों ओर लाल-भूरे रंग के धब्बे उभरते हैं।',
        imagePath: 'assets/images/disease_rust.png',
        guidance:
            'Spray Mancozeb 75% WP @ 2.5 g/L or Propiconazole 25% EC @ 1 ml/L at first appearance. Avoid overhead sprinkler irrigation during spore outbreaks.',
        marathiGuidance:
            'तांबेरा रोगाची लक्षणे दिसताच मॅन्कोझेब ७५% डब्ल्यूपी २.५ ग्रॅम किंवा प्रोपिकोनाझोल १ मिली प्रति लिटर पाण्यातून फवारा. शेतात हवा खेळती ठेवा.',
        hindiGuidance:
            'लक्षण दिखते ही मैंकोजेब २.५ ग्राम या प्रोपिकोनाजोल १ मिली प्रति लीटर का छिड़काव करें।',
      ),
      _ProblemItem(
        title: 'Pest Damage',
        marathiTitle: 'खोडकीड व कीटक नुकसान',
        hindiTitle: 'तना छेदक नुकसान',
        tag: 'Insect Pest',
        desc:
            'Dead hearts in young shoots, boreholes with frass, or chewed leaf margins from larvae.',
        marathiDesc:
            'सुरुवातीच्या उसात मृत पोंगे (Dead Hearts) आणि पानांवर अळ्यांचा प्रादुर्भाव.',
        hindiDesc:
            'छोटे पौधों में मृत पोंगे (डेड हार्ट) और पत्तियों को खाने वाली इल्ली।',
        imagePath: 'assets/images/disease_smut.png',
        guidance:
            'Release Trichogramma chilonis egg parasitoids @ 20,000/acre weekly (total 4 releases). For chemical rescue, apply Chlorantraniliprole 18.5% SC @ 0.4 ml/L targeted at cane bases.',
        marathiGuidance:
            'खोडकिडीसाठी ट्रायकोकार्ड हेक्टरी ५०,००० या प्रमाणात आठवड्यातून एकदा लावा. प्रादुर्भाव जास्त असल्यास कोलोरँट्रानिलीप्रोल (कोराजन) ०.४ मिली प्रति लिटर बुंध्यापाशी फवारा.',
        hindiGuidance:
            'ट्राइकोग्रामा कार्ड लगाएं या क्लोरेंट्रानिलिप्रोल ०.४ मिली प्रति लीटर का तने के पास छिड़काव करें।',
      ),
      _ProblemItem(
        title: 'Slow Crop Growth',
        marathiTitle: 'मंद पीक वाढ',
        hindiTitle: 'धीमी फसल वृद्धि',
        tag: 'Soil / Environmental',
        desc:
            'Stunted stalk elongation, thin internodes, and poor tiller count from compacted soil or drought.',
        marathiDesc:
            'जमिनीची क्षारता, सेंद्रिय खतांची कमतरता किंवा पाण्याचा ताण यामुळे वाढ खुंटते.',
        hindiDesc:
            'मिट्टी की कठोरता या जल तनाव के कारण पौधों की धीमी बढ़वार।',
        imagePath: 'assets/images/care_stage_growth.jpg',
        guidance:
            'Apply Humic Acid @ 5L/acre through drip, followed by 19:19:19 water-soluble foliar spray @ 5g/L. Loosen soil compaction through shallow interculturing.',
        marathiGuidance:
            'ठिबक सिंचनातून ह्युमिक ॲसिड १ लिटर प्रति एकर सोडा, आणि १९:१९:१९ विद्राव्य खत ५ ग्रॅम/लिटर फवारा. जमिनीतील हवा खेळती राहण्यासाठी हलकी कोळपणी करा.',
        hindiGuidance:
            'ड्रिप से ह्यूमिक एसिड दें और १९:१९:१९ का ५ ग्राम/लीटर छिड़काव करें। हल्की गुड़ाई करके हवा का संचार बढ़ाएं।',
      ),
    ];
  }
}

// ==========================================
// MODELS WITH MULTILINGUAL SUPPORT
// ==========================================
class _GrowthStage {
  final String number;
  final String title;
  final String marathiTitle;
  final String hindiTitle;
  final String duration;
  final String marathiDuration;
  final String hindiDuration;
  final String description;
  final String marathiDescription;
  final String hindiDescription;
  final String imagePath;
  final List<String> detailedSteps;
  final List<String> marathiDetailedSteps;
  final List<String> hindiDetailedSteps;

  _GrowthStage({
    required this.number,
    required this.title,
    required this.marathiTitle,
    required this.hindiTitle,
    required this.duration,
    required this.marathiDuration,
    required this.hindiDuration,
    required this.description,
    required this.marathiDescription,
    required this.hindiDescription,
    required this.imagePath,
    required this.detailedSteps,
    required this.marathiDetailedSteps,
    required this.hindiDetailedSteps,
  });
}

class _CareItem {
  final String title;
  final String marathiTitle;
  final String hindiTitle;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String desc;
  final String marathiDesc;
  final String hindiDesc;
  final String details;
  final String marathiDetails;
  final String hindiDetails;

  _CareItem({
    required this.title,
    required this.marathiTitle,
    required this.hindiTitle,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.desc,
    required this.marathiDesc,
    required this.hindiDesc,
    required this.details,
    required this.marathiDetails,
    required this.hindiDetails,
  });
}

class _ProblemItem {
  final String title;
  final String marathiTitle;
  final String hindiTitle;
  final String tag;
  final String desc;
  final String marathiDesc;
  final String hindiDesc;
  final String imagePath;
  final String guidance;
  final String marathiGuidance;
  final String hindiGuidance;

  _ProblemItem({
    required this.title,
    required this.marathiTitle,
    required this.hindiTitle,
    required this.tag,
    required this.desc,
    required this.marathiDesc,
    required this.hindiDesc,
    required this.imagePath,
    required this.guidance,
    required this.marathiGuidance,
    required this.hindiGuidance,
  });
}
