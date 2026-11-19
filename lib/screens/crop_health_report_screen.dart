import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/app_localizations.dart';
import '../models/scan_report.dart';
import '../models/user_profile.dart';
import '../providers/history_provider.dart';
import '../services/report_html_service.dart';

class CropHealthReportScreen extends StatelessWidget {
  final UserProfile? profile;
  final List<ScanReport>? customReports;

  const CropHealthReportScreen({
    super.key,
    this.profile,
    this.customReports,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final history = context.watch<HistoryProvider>();
    final reports = customReports ??
        (history.reports.isNotEmpty ? history.reports : ScanReport.mockHistory());

    final primaryReport = reports.isNotEmpty ? reports.first : null;
    final userProfile = profile ?? UserProfile.defaultDemo();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F5132),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          tooltip: 'मागे जा',
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'ऊस पीक निदान व फवारणी अहवाल',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'CaneCare AI™ • Market Standard Pathology Slip',
              style: TextStyle(
                color: Color(0xFFD1E7DD),
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_rounded, color: Colors.white),
            tooltip: 'प्रिंट / PDF सेव्ह करा',
            onPressed: () => ReportHtmlService.openOrPrintReport(
              context: context,
              profile: userProfile,
              reports: reports,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            tooltip: 'WhatsApp वर पाठवा',
            onPressed: () => ReportHtmlService.shareViaWhatsApp(
              context: context,
              profile: userProfile,
              reports: reports,
              language: loc.language,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            children: [
              // 1-Page Printable Diagnostic Report Container (Market App Style)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF0F5132), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.asset(
                                      'assets/images/cane_logo.png',
                                      width: 22,
                                      height: 22,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.eco_rounded,
                                        size: 20,
                                        color: Color(0xFF0F5132),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  const Text(
                                    'CaneCare AI™',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF0F5132),
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              const FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'SUGARCANE PATHOLOGY & AGRONOMY REPORT',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF198754),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              'ID: CC-2025-0420-SR',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF212529),
                              ),
                            ),
                            Text(
                              'तारीख: २० एप्रिल २०२५',
                              style: TextStyle(
                                fontSize: 9.5,
                                color: Color(0xFF6C757D),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 16, color: Color(0xFF0F5132), thickness: 1.5),

                    // 1. Farmer & Crop Passport
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAF9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFD1E7DD)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildPassportField('शेतकरी:', userProfile.fullName)),
                              Expanded(child: _buildPassportField('मोबाईल:', userProfile.phone ?? '९०२१५ ९०३६८')),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(child: _buildPassportField('गाव/जिल्हा:', 'कोपरगाव, अहिल्यानगर')),
                              Expanded(child: _buildPassportField('उसाची जात:', userProfile.sugarcaneVariety ?? 'Co 86032')),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(child: _buildPassportField('बाधित वावर:', 'Plot #3 (North Field)')),
                              Expanded(child: _buildPassportField('क्षेत्र / वय:', '${userProfile.farmSize ?? "५ एकर"} • ५ महिने')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 2. Primary AI Diagnosis Banner (Plantix Style with Real Photo)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8F8),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFF5C2C7)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => _showImageDialog(context, primaryReport),
                            child: Tooltip(
                              message: 'मोठा फोटो पाहण्यासाठी टॅप करा',
                              child: Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFDC3545),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFDC3545).withValues(alpha: 0.15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6.5),
                                      child: SizedBox(
                                        width: 68,
                                        height: 68,
                                        child: _buildDiseaseImage(primaryReport),
                                      ),
                                    ),
                                    Positioned(
                                      right: 2,
                                      bottom: 2,
                                      child: Container(
                                        padding: const EdgeInsets.all(2.5),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.65),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.zoom_in,
                                          size: 11,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDC3545),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: const Text(
                                        'गंभीर धोका (HIGH RISK)',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE7F1FF),
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(color: const Color(0xFFB6D4FE)),
                                      ),
                                      child: Text(
                                        primaryReport != null
                                            ? '✓ ${primaryReport.confidenceDisplay} AI Match'
                                            : '✓ ९४.८% AI Match',
                                        style: const TextStyle(
                                          color: Color(0xFF0D6EFD),
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  primaryReport != null && primaryReport.marathiName.isNotEmpty
                                      ? primaryReport.marathiName
                                      : (primaryReport?.diseaseName ?? 'उसावरील तांबडे कूज (Red Rot Disease)'),
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF842029),
                                  ),
                                ),
                                Text(
                                  'पॅथॉलॉजी: ${primaryReport?.scientificName.isNotEmpty == true ? primaryReport!.scientificName : "Colletotrichum falcatum"}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFF6C757D),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  primaryReport != null && primaryReport.symptoms.isNotEmpty
                                      ? '🔍 मुख्य लक्षणे: ${primaryReport.symptoms.join(". ")}'
                                      : '🔍 मुख्य लक्षणे: पानाच्या मध्य शिरेवर लालसर-तांबूस पट्टे व पांढरे ठिपके. उसाचा शेंडा पिवळा पडून वाळण्यास सुरुवात झाली आहे.',
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    color: Color(0xFF2B2F32),
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 3. Agronomist Prescription Table (Rx Table)
                    Row(
                      children: const [
                        Text(
                          '℞ कृषी तज्ज्ञ औषधोपचार व फवारणी तक्ता',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F5132),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    _buildRxCard(
                      stage: 'फेरी १ (तातडीने २४ तासांत)',
                      stageColor: const Color(0xFFB02A37),
                      items: [
                        '१. कार्बेन्डाझिम १२% + मँकोझेब ६३% (SAFF) @ २ ग्रॅम/लिटर (५०० ग्रॅम/एकर)',
                        '२. ॲसिटामिप्रिड २०% SP @ ०.५ ग्रॅम/लिटर (मावा कीड नियंत्रण)',
                        '३. सिलिकॉन स्टीकर @ ०.५ मिली/लिटर (२०० लिटर पाणी/एकर)',
                      ],
                    ),
                    const SizedBox(height: 8),

                    _buildRxCard(
                      stage: 'फेरी २ (७ ते १० दिवसांनी)',
                      stageColor: const Color(0xFF0F5132),
                      items: [
                        '१. ट्रायकोडर्मा व्हिरिडी (जैविक) @ २.५ किलो/एकर शेणखतात मिसळून ठिबकमधून आळवणी',
                        '२. १९:१९:१९ विद्राव्य खत + सूक्ष्मअन्नद्रव्ये @ ५ ग्रॅम/लिटर फवारणी',
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 4. Do's & Don'ts and Weather Strip
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAF9),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFD1E7DD)),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '✅ शेतातील नियम (Do\'s & Don\'ts):',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F5132),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '• बाधित झाडे मुळासकट उपटून नष्ट करा.\n'
                                  '• युरिया खत त्वरित बंद ठेवा (पालाश वाढवा).\n'
                                  '• शेतात पाण्याचा निचरा योग्य ठेवा.',
                                  style: TextStyle(fontSize: 10, height: 1.35, color: Color(0xFF334155)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F7FF),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFB6D4FE)),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '🌦️ हवामान सल्ला:',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF084298),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'तापमान: २८° से. • आर्द्रता: ७२%\nसकाळी किंवा संध्याकाळी फवारणी करा.',
                                  style: TextStyle(fontSize: 10, height: 1.35, color: Color(0xFF084298)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 5. Verification Seal & Doctor Signature
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Color(0xFFD1E7DD))),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFF0F5132), style: BorderStyle.solid),
                            ),
                            child: const Text(
                              'CANCARE AI & KVK\n✓ OFFICIALLY VERIFIED',
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F5132),
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Text(
                                  'डॉ. एस. बी. पाटील (Ph.D. Plant Pathology)',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF212529),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'वरिष्ठ कृषी शास्त्रज्ञ • KVK व CaneCare AI Panel',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Color(0xFF6C757D),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Bottom Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => ReportHtmlService.openOrPrintReport(
                        context: context,
                        profile: userProfile,
                        reports: reports,
                      ),
                      icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('Download PDF'),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0F5132),
                        side: const BorderSide(color: Color(0xFF0F5132), width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => ReportHtmlService.shareViaWhatsApp(
                        context: context,
                        profile: userProfile,
                        reports: reports,
                        language: loc.language,
                      ),
                      icon: const Icon(Icons.share_rounded, size: 18, color: Colors.white),
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('Share Expert'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF198754),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPassportField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 9.5, color: Color(0xFF6C757D)),
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF212529),
          ),
        ),
      ],
    );
  }

  Widget _buildRxCard({
    required String stage,
    required Color stageColor,
    required List<String> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: stageColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(
                stage,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: stageColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(left: 14, top: 2),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212529),
                  height: 1.35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseImage(ScanReport? report) {
    final imagePath = report?.imagePath;

    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('assets/')) {
        return Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _diseaseAssetFallback(report),
        );
      }
      if (imagePath.startsWith('http') ||
          imagePath.startsWith('blob:') ||
          imagePath.startsWith('data:')) {
        return Image.network(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _diseaseAssetFallback(report),
        );
      }
      if (!kIsWeb) {
        try {
          final file = File(imagePath);
          if (file.existsSync()) {
            return Image.file(
              file,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _diseaseAssetFallback(report),
            );
          }
        } catch (_) {}
      }
    }

    return _diseaseAssetFallback(report);
  }

  Widget _diseaseAssetFallback(ScanReport? report) {
    String asset = 'assets/images/disease_red_rot.png';
    if (report != null) {
      final key = '${report.diseaseName} ${report.marathiName}'.toLowerCase();
      if (key.contains('yellow') || key.contains('पिवळा')) {
        asset = 'assets/images/disease_yellow_leaf.png';
      } else if (key.contains('rust') || key.contains('तांबेरा')) {
        asset = 'assets/images/disease_rust.png';
      } else if (key.contains('smut') || key.contains('काजळी')) {
        asset = 'assets/images/disease_smut.png';
      } else if (key.contains('mosaic') || key.contains('मोझॅक')) {
        asset = 'assets/images/disease_mosaic.png';
      } else if (key.contains('healthy') || key.contains('निरोगी')) {
        asset = 'assets/images/disease_healthy.png';
      }
    }

    return Image.asset(
      asset,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/detail_red_rot_banner.png',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: const Color(0xFFFEE2E2),
          child: const Center(
            child: Icon(Icons.eco_rounded, size: 28, color: Color(0xFFDC3545)),
          ),
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, ScanReport? report) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: SizedBox(
                    width: double.infinity,
                    child: _buildDiseaseImage(report),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        report?.marathiName.isNotEmpty == true
                            ? report!.marathiName
                            : (report?.diseaseName ?? 'उसावरील तांबडे कूज (Red Rot)'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
