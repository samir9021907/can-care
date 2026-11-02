import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../models/crop_tip.dart';
import 'crop_tip_detail_screen.dart';

class CropTipsScreen extends StatelessWidget {
  const CropTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    // 5 tips matching Figma Screen 14 with full English, Marathi, Hindi translations
    final tipItems = [
      _FigmaTip(
        icon: Icons.wb_sunny_rounded,
        iconColor: const Color(0xFFF57C00),
        circleBg: const Color(0xFFFFF3E0),
        titleEnglish: 'Water early\nin the morning',
        titleMarathi: 'सकाळी लवकर\nपाणी द्या',
        titleHindi: 'सुबह जल्दी\nपानी दें',
        categoryEnglish: 'Irrigation',
        categoryMarathi: 'पाणी व्यवस्थापन',
        categoryHindi: 'सिंचाई',
        descEnglish:
            'Irrigating sugarcane in early morning reduces evaporative water loss and ensures deep root absorption while avoiding leaf wetness through hot midday.',
        descMarathi:
            'सकाळी लवकर पाणी दिल्याने बाष्पीभवन कमी होते आणि उसाच्या मुळांना चांगला ओलावा मिळतो.',
        descHindi:
            'सुबह जल्दी सिंचाई करने से पानी का वाष्पीकरण कम होता है और जड़ों को गहरी नमी मिलती है।',
      ),
      _FigmaTip(
        icon: Icons.eco_rounded,
        iconColor: const Color(0xFF2E7D32),
        circleBg: const Color(0xFFE8F5E9),
        titleEnglish: 'Use quality seeds',
        titleMarathi: 'दर्जेदार बेणे\nवापरा',
        titleHindi: 'गुणवत्तापूर्ण बीज\nका उपयोग करें',
        categoryEnglish: 'Seed Care',
        categoryMarathi: 'बेणे निवड',
        categoryHindi: 'बीज देखभाल',
        descEnglish:
            'Plant certified, hot-water-treated setts or tissue culture plantlets to eliminate seed-borne fungal smut and red rot pathogens before germination.',
        descMarathi:
            'प्रमाणित आणि उष्ण जल प्रक्रिया केलेले बेणे वापरल्यास काणी व तांबडे कूज रोगांचा प्रादुर्भाव टळतो.',
        descHindi:
            'प्रमाणित और उपचारित बीजों का प्रयोग करने से कंडुआ और लाल सड़न जैसे रोगों से बचाव होता है।',
      ),
      _FigmaTip(
        icon: Icons.park_rounded,
        iconColor: const Color(0xFF2E7D32),
        circleBg: const Color(0xFFE8F5E9),
        titleEnglish: 'Keep field clean',
        titleMarathi: 'शेत नेहमी\nस्वच्छ ठेवा',
        titleHindi: 'खेत को\nसाफ रखें',
        categoryEnglish: 'Sanitation',
        categoryMarathi: 'शेताची स्वच्छता',
        categoryHindi: 'स्वच्छता',
        descEnglish:
            'Routinely remove weed hosts, debris, and stubble from previous harvests to minimize shelter for borers, pyrilla, and viral vectors.',
        descMarathi:
            'शेतातील गवत, तण आणि जुने अवशेष वेळेवर काढून टाका जेणेकरून कीड व विषाणूंचा प्रसार रोखला जाईल.',
        descHindi:
            'खेत से खरपतवार और अवशेष समय पर हटाएं ताकि कीटों और विषाणुओं के फैलाव को रोका जा सके।',
      ),
      _FigmaTip(
        icon: Icons.water_drop_rounded,
        iconColor: const Color(0xFF2E7D32),
        circleBg: const Color(0xFFE8F5E9),
        titleEnglish: 'Avoid water logging',
        titleMarathi: 'पाणी साचू\nदेऊ नका',
        titleHindi: 'जलजमाव से\nबचें',
        categoryEnglish: 'Drainage',
        categoryMarathi: 'पाण्याचा निचरा',
        categoryHindi: 'जल निकासी',
        descEnglish:
            'Ensure farm furrows and main drainage channels are unobstructed. Stagnant water deprives roots of oxygen and fosters fungal rot.',
        descMarathi:
            'शेतामध्ये पाणी साचून राहू देऊ नका. चांगल्या निचऱ्याची व्यवस्था केल्यास मुळे सडत नाहीत.',
        descHindi:
            'खेत में पानी जमा न होने दें। जल निकासी की उचित व्यवस्था जड़ों को सड़ने से बचाती है।',
      ),
      _FigmaTip(
        icon: Icons.remove_red_eye_rounded,
        iconColor: const Color(0xFF2E7D32),
        circleBg: const Color(0xFFE8F5E9),
        titleEnglish: 'Regular monitoring',
        titleMarathi: 'पिकाची नियमित\nपाहणी करा',
        titleHindi: 'फसल की नियमित\nनिगरानी करें',
        categoryEnglish: 'Field Scouting',
        categoryMarathi: 'नियमित पाहणी',
        categoryHindi: 'खेत की निगरानी',
        descEnglish:
            'Inspect upper leaf whorls and midribs weekly. Early detection of spot symptoms allows bio-control interventions before disease spreads.',
        descMarathi:
            'आठवड्यातून एकदा उसाच्या पानांची काळजीपूर्वक पाहणी करा, जेणेकरून रोगाची प्राथमिक अवस्थेतच माहिती मिळेल.',
        descHindi:
            'सप्ताह में एक बार पत्तियों की जांच अवश्य करें जिससे किसी भी बीमारी का समय रहते पता चल सके।',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAF5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF14451D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          loc.translate('crop_tips_title'),
          style: const TextStyle(
            color: Color(0xFF14451D),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            children: [
              // Stylized Foliage Banner (Figma Screen 14)
              Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF81C784), Color(0xFF388E3C), Color(0xFF1B5E20)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E7D32).withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/crop_tips_banner.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => CustomPaint(
                      painter: _SugarcaneFieldBannerPainter(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // 5 Tip Cards (Figma Screen 14)
              ...tipItems.map(
                (item) {
                  final title = item.getTitle(loc.language);
                  final desc = item.getDescription(loc.language);
                  final category = item.getCategory(loc.language);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE8EFE5), width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CropTipDetailScreen(
                                  tip: CropTip(
                                    id: item.titleEnglish,
                                    title: item.titleEnglish.replaceAll('\n', ' '),
                                    marathiTitle: item.titleMarathi.replaceAll('\n', ' '),
                                    category: category,
                                    iconKey: 'seed',
                                    summary: desc,
                                    guidelines: [
                                      desc,
                                      loc.language == AppLanguage.marathi
                                          ? 'पिकाची नियमित काळजी घ्या आणि तज्ज्ञांचा सल्ला घ्या.'
                                          : loc.language == AppLanguage.hindi
                                              ? 'फसल की नियमित देखभाल करें और विशेषज्ञ से सलाह लें।'
                                              : 'Inspect crop condition regularly and seek expert advice.',
                                    ],
                                    cautionNote: loc.translate('expert_disclaimer'),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: item.circleBg,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(item.icon, color: item.iconColor, size: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF14451D),
                                      height: 1.25,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Color(0xFFA5B8A8),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _FigmaTip {
  final IconData icon;
  final Color iconColor;
  final Color circleBg;
  final String titleEnglish;
  final String titleMarathi;
  final String titleHindi;
  final String categoryEnglish;
  final String categoryMarathi;
  final String categoryHindi;
  final String descEnglish;
  final String descMarathi;
  final String descHindi;

  _FigmaTip({
    required this.icon,
    required this.iconColor,
    required this.circleBg,
    required this.titleEnglish,
    required this.titleMarathi,
    required this.titleHindi,
    required this.categoryEnglish,
    required this.categoryMarathi,
    required this.categoryHindi,
    required this.descEnglish,
    required this.descMarathi,
    required this.descHindi,
  });

  String getTitle(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.marathi:
        return titleMarathi;
      case AppLanguage.hindi:
        return titleHindi;
      case AppLanguage.english:
        return titleEnglish;
    }
  }

  String getDescription(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.marathi:
        return descMarathi;
      case AppLanguage.hindi:
        return descHindi;
      case AppLanguage.english:
        return descEnglish;
    }
  }

  String getCategory(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.marathi:
        return categoryMarathi;
      case AppLanguage.hindi:
        return categoryHindi;
      case AppLanguage.english:
        return categoryEnglish;
    }
  }
}

class _SugarcaneFieldBannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Stylized leaves shooting upwards from bottom
    final leafPaintLight = Paint()
      ..color = const Color(0xFFA5D6A7).withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final leafPaintDark = Paint()
      ..color = const Color(0xFF1B5E20).withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    void drawLeaf(double startX, double peakX, double peakY, double width, Paint p) {
      final path = Path();
      path.moveTo(startX, h);
      path.quadraticBezierTo(startX + (peakX - startX) * 0.3, peakY + (h - peakY) * 0.5, peakX, peakY);
      path.quadraticBezierTo(startX + width + (peakX - startX) * 0.4, peakY + (h - peakY) * 0.6, startX + width, h);
      path.close();
      canvas.drawPath(path, p);
    }

    // Background silhouettes
    drawLeaf(w * 0.1, w * 0.22, h * 0.2, 20, leafPaintLight);
    drawLeaf(w * 0.3, w * 0.45, h * 0.15, 24, leafPaintLight);
    drawLeaf(w * 0.6, w * 0.72, h * 0.18, 22, leafPaintLight);
    drawLeaf(w * 0.75, w * 0.88, h * 0.25, 20, leafPaintLight);

    // Foreground dense stalks
    drawLeaf(w * 0.18, w * 0.28, h * 0.35, 26, leafPaintDark);
    drawLeaf(w * 0.42, w * 0.52, h * 0.30, 28, leafPaintDark);
    drawLeaf(w * 0.68, w * 0.78, h * 0.32, 26, leafPaintDark);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
