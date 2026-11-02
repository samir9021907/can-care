import 'package:flutter/material.dart';
import '../models/disease_info.dart';
import '../localization/app_localizations.dart';

class DiseaseGridCard extends StatelessWidget {
  final DiseaseInfo disease;
  final VoidCallback onTap;

  const DiseaseGridCard({
    super.key,
    required this.disease,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final lang = loc.language;

    // Disease metadata mapping matching Field Identification design
    final meta = _getCardMetadata(disease.id, lang);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5EDE7), width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Photo Thumbnail with Floating Badge
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: SizedBox(
                  height: 105,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          disease.imageAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: const Color(0xFFE8F5E9),
                            child: const Center(
                              child: Icon(
                                Icons.eco_rounded,
                                color: Color(0xFF2E7D32),
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Floating Category/Severity Badge
                      Positioned(
                        top: 7,
                        left: 7,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7.5, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: meta.badgeBg.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: meta.badgeTextColor.withValues(alpha: 0.25),
                              width: 0.8,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            meta.badgeText,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: meta.badgeTextColor,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Content Details (Title, Marathi Subtitle, Snippet, Details button)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // English Title
                      Text(
                        meta.displayTitle,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF14451D),
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),

                      // Marathi Subtitle
                      Text(
                        meta.marathiSubtitle,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: meta.subtitleColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Short 2-line Description Snippet
                      Expanded(
                        child: Text(
                          meta.snippet,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF6B8074),
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // "Details →" row at bottom
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          children: [
                            Text(
                              lang == AppLanguage.marathi
                                  ? 'तपशील'
                                  : (lang == AppLanguage.hindi
                                      ? 'विवरण'
                                      : 'Details'),
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF165228),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 13,
                              color: Color(0xFF165228),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _CardMeta _getCardMetadata(String id, AppLanguage lang) {
    if (lang == AppLanguage.marathi) {
      switch (id) {
        case 'healthy':
          return const _CardMeta(
            badgeText: 'निरोगी पीक',
            badgeBg: Color(0xFFD1FAE5),
            badgeTextColor: Color(0xFF065F46),
            displayTitle: 'निरोगी ऊस',
            marathiSubtitle: 'कोणताही रोग नाही',
            subtitleColor: Color(0xFF15803D),
            snippet: 'पाने चमकदार हिरवी, समान पोत आणि कोणताही डाग नाही.',
          );
        case 'red_rot':
          return const _CardMeta(
            badgeText: 'बुरशीजन्य • गंभीर',
            badgeBg: Color(0xFFFEE2E2),
            badgeTextColor: Color(0xFF991B1B),
            displayTitle: 'काणी / लाल कुज',
            marathiSubtitle: 'Red Rot',
            subtitleColor: Color(0xFFB91C1C),
            snippet: 'पानाच्या मुख्य शिरेवर लाल डाग, अल्कोहोलचा वास, अंतर्गत भाग लाल...',
          );
        case 'rust':
          return const _CardMeta(
            badgeText: 'बुरशीजन्य तांबेरा',
            badgeBg: Color(0xFFFEF3C7),
            badgeTextColor: Color(0xFF92400E),
            displayTitle: 'पानावरील तांबेरा',
            marathiSubtitle: 'Sugarcane Rust',
            subtitleColor: Color(0xFF92400E),
            snippet: 'पानांवर तांबूस-तपकिरी रंगाचे लहान पुटकुळ्यांसारखे डाग...',
          );
        case 'yellow_leaf':
          return const _CardMeta(
            badgeText: 'विषाणूजन्य / फायटोप्लाझ्मा',
            badgeBg: Color(0xFFFFEDD5),
            badgeTextColor: Color(0xFF9A3412),
            displayTitle: 'पिवळे पान रोग',
            marathiSubtitle: 'Yellow Leaf Disease',
            subtitleColor: Color(0xFFC2410C),
            snippet: 'पानाच्या मुख्य शिरेपासून सुरू होणारा पिवळेपणा, वाढ खुंटणे...',
          );
        case 'mosaic':
          return const _CardMeta(
            badgeText: 'विषाणूजन्य रोग',
            badgeBg: Color(0xFFDCFCE7),
            badgeTextColor: Color(0xFF166534),
            displayTitle: 'मोझॅक रोग',
            marathiSubtitle: 'Sugarcane Mosaic',
            subtitleColor: Color(0xFF15803D),
            snippet: 'पानांवर फिकट हिरवे आणि गडद पट्टे, मोझॅकसारखे ठिपके...',
          );
        case 'smut':
          return const _CardMeta(
            badgeText: 'काणी बुरशी',
            badgeBg: Color(0xFFCCFBF1),
            badgeTextColor: Color(0xFF115E59),
            displayTitle: 'चाबूक काणी',
            marathiSubtitle: 'Sugarcane Smut',
            subtitleColor: Color(0xFF334155),
            snippet: 'शेंड्यातून काळ्या रंगाचा चाबकासारखा लांब दांडा बाहेर पडतो...',
          );
        default:
          return _CardMeta(
            badgeText: disease.getLocalizedPathogenType(lang),
            badgeBg: const Color(0xFFE2E8F0),
            badgeTextColor: const Color(0xFF334155),
            displayTitle: disease.getLocalizedName(lang),
            marathiSubtitle: disease.name,
            subtitleColor: const Color(0xFF15803D),
            snippet: disease.getLocalizedOverview(lang),
          );
      }
    } else if (lang == AppLanguage.hindi) {
      switch (id) {
        case 'healthy':
          return const _CardMeta(
            badgeText: 'स्वस्थ फसल',
            badgeBg: Color(0xFFD1FAE5),
            badgeTextColor: Color(0xFF065F46),
            displayTitle: 'स्वस्थ गन्ना',
            marathiSubtitle: 'कोई रोग नहीं',
            subtitleColor: Color(0xFF15803D),
            snippet: 'चमकदार हरी पत्तियां, समान संरचना, कोई धब्बे नहीं।',
          );
        case 'red_rot':
          return const _CardMeta(
            badgeText: 'कवक जनित • गंभीर',
            badgeBg: Color(0xFFFEE2E2),
            badgeTextColor: Color(0xFF991B1B),
            displayTitle: 'लाल सड़न रोग',
            marathiSubtitle: 'Red Rot',
            subtitleColor: Color(0xFFB91C1C),
            snippet: 'मुख्य शिरा पर लाल धब्बे, अल्कोहल जैसी गंध, आंतरिक भाग लाल...',
          );
        case 'rust':
          return const _CardMeta(
            badgeText: 'गेरुआ रोग',
            badgeBg: Color(0xFFFEF3C7),
            badgeTextColor: Color(0xFF92400E),
            displayTitle: 'गन्ने का तांबेरा',
            marathiSubtitle: 'Sugarcane Rust',
            subtitleColor: Color(0xFF92400E),
            snippet: 'पत्तियों पर लाल-भूरे रंग के उभरे हुए धब्बे...',
          );
        case 'yellow_leaf':
          return const _CardMeta(
            badgeText: 'पीली पत्ती रोग',
            badgeBg: Color(0xFFFFEDD5),
            badgeTextColor: Color(0xFF9A3412),
            displayTitle: 'येलो लीफ डिसीज',
            marathiSubtitle: 'Yellow Leaf Disease',
            subtitleColor: Color(0xFFC2410C),
            snippet: 'निचली सतह पर मुख्य शिरा का पीला पड़ना...',
          );
        case 'mosaic':
          return const _CardMeta(
            badgeText: 'विषाणु जनित रोग',
            badgeBg: Color(0xFFDCFCE7),
            badgeTextColor: Color(0xFF166534),
            displayTitle: 'मोज़ेक रोग',
            marathiSubtitle: 'Sugarcane Mosaic',
            subtitleColor: Color(0xFF15803D),
            snippet: 'पत्तियों पर हल्के और गहरे हरे रंग के अनियमित धब्बे...',
          );
        case 'smut':
          return const _CardMeta(
            badgeText: 'कंडुआ रोग',
            badgeBg: Color(0xFFCCFBF1),
            badgeTextColor: Color(0xFF115E59),
            displayTitle: 'चाबुक कंडुआ',
            marathiSubtitle: 'Sugarcane Smut',
            subtitleColor: Color(0xFF334155),
            snippet: 'पौधे के ऊपरी भाग से चाबुक जैसी काली संरचना निकलना...',
          );
        default:
          return _CardMeta(
            badgeText: disease.getLocalizedPathogenType(lang),
            badgeBg: const Color(0xFFE2E8F0),
            badgeTextColor: const Color(0xFF334155),
            displayTitle: disease.getLocalizedName(lang),
            marathiSubtitle: disease.name,
            subtitleColor: const Color(0xFF15803D),
            snippet: disease.getLocalizedOverview(lang),
          );
      }
    }

    switch (id) {
      case 'healthy':
        return const _CardMeta(
          badgeText: 'Healthy Crop',
          badgeBg: Color(0xFFD1FAE5),
          badgeTextColor: Color(0xFF065F46),
          displayTitle: 'Healthy Cane',
          marathiSubtitle: 'निरोगी ऊस',
          subtitleColor: Color(0xFF15803D),
          snippet: 'Bright emerald color, uniform texture, no spots',
        );
      case 'red_rot':
        return const _CardMeta(
          badgeText: 'Fungal • Severe',
          badgeBg: Color(0xFFFEE2E2),
          badgeTextColor: Color(0xFF991B1B),
          displayTitle: 'Red Rot',
          marathiSubtitle: 'लाल कूज / तांबेरा',
          subtitleColor: Color(0xFFB91C1C),
          snippet: 'Red lesions on midrib, alcoholic smell, pith...',
        );
      case 'rust':
        return const _CardMeta(
          badgeText: 'Foliar Rust',
          badgeBg: Color(0xFFFEF3C7),
          badgeTextColor: Color(0xFF92400E),
          displayTitle: 'Sugarcane Rust',
          marathiSubtitle: 'पानावरील तांबेरा',
          subtitleColor: Color(0xFF92400E),
          snippet: 'Tiny yellow flecks turning into raised reddish-brown',
        );
      case 'yellow_leaf':
        return const _CardMeta(
          badgeText: 'Phytoplasma',
          badgeBg: Color(0xFFFFEDD5),
          badgeTextColor: Color(0xFF9A3412),
          displayTitle: 'Yellow Leaf (YLD)',
          marathiSubtitle: 'पिवळे पान रोग',
          subtitleColor: Color(0xFFC2410C),
          snippet: 'Prominent yellowing along lower surface...',
        );
      case 'mosaic':
        return const _CardMeta(
          badgeText: 'Viral Disease',
          badgeBg: Color(0xFFDCFCE7),
          badgeTextColor: Color(0xFF166534),
          displayTitle: 'Sugarcane Mosaic',
          marathiSubtitle: 'मोझॅक रोग',
          subtitleColor: Color(0xFF15803D),
          snippet: 'Irregular pale green blotches and streaks...',
        );
      case 'smut':
        return const _CardMeta(
          badgeText: 'Fungal Spore',
          badgeBg: Color(0xFFCCFBF1),
          badgeTextColor: Color(0xFF115E59),
          displayTitle: 'Sugarcane Smut',
          marathiSubtitle: 'काजळी / चाबूक काणी',
          subtitleColor: Color(0xFF334155),
          snippet: 'Characteristic curved whip-like structure...',
        );
      default:
        return _CardMeta(
          badgeText: disease.pathogenType,
          badgeBg: const Color(0xFFE2E8F0),
          badgeTextColor: const Color(0xFF334155),
          displayTitle: disease.name,
          marathiSubtitle: disease.marathiName.isNotEmpty
              ? disease.marathiName
              : disease.name,
          subtitleColor: const Color(0xFF15803D),
          snippet: disease.overview,
        );
    }
  }
}

class _CardMeta {
  final String badgeText;
  final Color badgeBg;
  final Color badgeTextColor;
  final String displayTitle;
  final String marathiSubtitle;
  final Color subtitleColor;
  final String snippet;

  const _CardMeta({
    required this.badgeText,
    required this.badgeBg,
    required this.badgeTextColor,
    required this.displayTitle,
    required this.marathiSubtitle,
    required this.subtitleColor,
    required this.snippet,
  });
}

class DiseaseCard extends StatelessWidget {
  final DiseaseInfo disease;
  final VoidCallback onTap;

  const DiseaseCard({
    super.key,
    required this.disease,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DiseaseGridCard(disease: disease, onTap: onTap);
  }
}
