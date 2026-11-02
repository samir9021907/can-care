import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../localization/app_localizations.dart';
import '../models/disease_info.dart';
import '../models/prediction_result.dart';
import '../models/recommended_product.dart';
import '../models/scan_report.dart';
import '../providers/history_provider.dart';
import '../providers/scan_provider.dart';
import '../services/agri_product_service.dart';
import 'ask_question_screen.dart';
import 'disease_detail_screen.dart';
import 'history_screen.dart';
import 'product_detail_screen.dart';
import 'save_report_confirmation_screen.dart';
import 'scan_camera_screen.dart';

enum PriceComparisonTab { online, offline }

class DiseaseResultScreen extends StatefulWidget {
  const DiseaseResultScreen({super.key});

  @override
  State<DiseaseResultScreen> createState() => _DiseaseResultScreenState();
}

class _DiseaseResultScreenState extends State<DiseaseResultScreen> {
  PriceComparisonTab _priceTab = PriceComparisonTab.online;
  String _selectedRegion = 'Satara & Kolhapur Region, Maharashtra';
  bool _isUsingGps = false;

  void _handleSaveReport() async {
    final scan = context.read<ScanProvider>();
    final history = context.read<HistoryProvider>();

    if (scan.reportSavedSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text('हा अहवाल आधीच सेव्ह झाला आहे! वरील घड्याळाच्या आयकॉनवर क्लिक करून तुम्ही तो पाहू शकता.'),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF165228),
          action: SnackBarAction(
            label: 'इतिहास (History)',
            textColor: const Color(0xFFC8E6C9),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HistoryScreen(
                    onNavigateToScan: () => Navigator.pop(context),
                  ),
                ),
              );
            },
          ),
        ),
      );
      return;
    }

    if (scan.predictionResult != null) {
      final newReport = ScanReport.fromPrediction(scan.predictionResult!);
      history.insertReport(newReport);
    }

    final success = await scan.saveCurrentReport();

    if (!mounted) return;

    if (success) {
      await history.loadReports();
      final latestReport =
          history.reports.isNotEmpty ? history.reports.first : null;
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SaveReportConfirmationScreen(report: latestReport),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('अहवाल सेव्ह करताना अडचण आली. कृपया पुन्हा प्रयत्न करा.'),
          backgroundColor: Color(0xFFC62828),
        ),
      );
    }
  }

  void _handleShareReport() async {
    final scan = context.read<ScanProvider>();
    await scan.shareCurrentReport();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Diagnosis & product recommendations ready to share!'),
          backgroundColor: Color(0xFF165228),
        ),
      );
    }
  }

  void _simulateGpsLocation() async {
    setState(() {
      _isUsingGps = true;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    if (mounted) {
      setState(() {
        _isUsingGps = false;
        _selectedRegion = 'Satara & Kolhapur Region, Maharashtra';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.gps_fixed, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text('GPS Active: Located nearby Kendras in Western Maharashtra'),
              ),
            ],
          ),
          backgroundColor: Color(0xFF165228),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showRegionPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'Select Sugar Belt Region (शेतकरी विभाग निवडा)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF14451D),
                    ),
                  ),
                ),
                const Divider(),
                ...AgriProductService.availableRegions.map(
                  (region) => ListTile(
                    leading: Icon(
                      Icons.location_on_outlined,
                      color: region == _selectedRegion
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFF757575),
                    ),
                    title: Text(
                      region,
                      style: TextStyle(
                        fontWeight: region == _selectedRegion
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: region == _selectedRegion
                            ? const Color(0xFF14451D)
                            : Colors.black87,
                      ),
                    ),
                    trailing: region == _selectedRegion
                        ? const Icon(Icons.check_circle, color: Color(0xFF2E7D32))
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedRegion = region;
                      });
                      Navigator.pop(ctx);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  DiseaseInfo _findDisease(PredictionResult res) {
    final diseases = DiseaseInfo.getSugarcaneDiseases();
    final resName = res.diseaseName.toLowerCase();
    for (final d in diseases) {
      if (resName.contains(d.name.toLowerCase()) ||
          d.name.toLowerCase().contains(resName) ||
          (d.scientificName.isNotEmpty &&
              res.scientificName
                  .toLowerCase()
                  .contains(d.scientificName.toLowerCase()))) {
        return d;
      }
    }
    return diseases.length > 1 ? diseases[1] : diseases.first;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final scan = context.watch<ScanProvider>();
    final result = scan.predictionResult;

    if (result == null) {
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
            loc.translate('detection_result'),
            style: const TextStyle(color: Color(0xFF14451D)),
          ),
        ),
        body: Center(child: Text(loc.translate('no_history'))),
      );
    }

    final disease = _findDisease(result);
    final recommendedProducts =
        AgriProductService.getProductsForDisease(result.diseaseName);
    final actionSteps = AgriProductService.getActionSteps(result.diseaseName);
    final nearbyKendras =
        AgriProductService.getNearbyKendras(region: _selectedRegion);

    // Formatted date and time
    final timeStr = DateFormat('hh:mm a').format(result.analyzedAt);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F0),
      appBar: _buildCustomHeader(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Analyzed Leaf Card (Figma Screen 1)
            _buildAnalyzedLeafCard(context, result, timeStr),
            const SizedBox(height: 16),

            // 2. Diagnostic Assessment Card (Figma Screen 1 & 2)
            _buildDiagnosticAssessmentCard(context, result, disease),
            const SizedBox(height: 22),

            // 3. What should I do next? (Figma Screen 2 & 3)
            _buildActionStepsSection(actionSteps),
            const SizedBox(height: 24),

            // 4. Recommended Products (Figma Screen 3 & 4)
            _buildRecommendedProductsSection(context, recommendedProducts),
            const SizedBox(height: 16),

            // Expert Advisory Shield Card (Figma Screen 4)
            _buildExpertAdvisoryShieldCard(),
            const SizedBox(height: 24),

            // 5. Compare Prices (Figma Screen 4 & 5)
            _buildComparePricesSection(context, recommendedProducts),
            const SizedBox(height: 24),

            // 6. Find Near Me - Krishi Seva Kendras (Figma Screen 5)
            _buildFindNearMeSection(context, nearbyKendras),
            const SizedBox(height: 10),

            // Verified Dealers Registration Footer (from Screenshot 6)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Showing verified licensed pesticide and fertilizer dealers registered with Maharashtra Agriculture Department.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B7280),
                  height: 1.35,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 7. Buy Online Card (from Screenshot 6)
            if (recommendedProducts.isNotEmpty)
              _buildBuyOnlineCard(context, recommendedProducts.first),
            const SizedBox(height: 16),

            // 8. Ask an Expert Card (from Screenshot 6)
            _buildAskExpertCard(context),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  /// Custom Figma Header with Back button, Title, Subtitle, and History Button
  PreferredSizeWidget _buildCustomHeader(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF3F7F0),
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        children: [
          // Circular Back Button
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(22),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFE2EFE1),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD0E4CF), width: 1),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF14451D),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Title & Subtitle Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Scan Result',
                  style: TextStyle(
                    color: Color(0xFF14451D),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'तपासणी निकाल • CaneCare AI Diagnostics',
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Share Button
          InkWell(
            onTap: _handleShareReport,
            borderRadius: BorderRadius.circular(22),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE2EFE1),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD0E4CF), width: 1),
              ),
              child: const Icon(
                Icons.share_outlined,
                color: Color(0xFF14451D),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // History Button on Top Right
          InkWell(
            onTap: () async {
              final scan = context.read<ScanProvider>();
              final history = context.read<HistoryProvider>();

              if (scan.predictionResult != null) {
                final rep = ScanReport.fromPrediction(scan.predictionResult!);
                history.insertReport(rep);
                await scan.saveCurrentReport();
              }
              await history.loadReports();

              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HistoryScreen(
                      onNavigateToScan: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ScanCameraScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(22),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFE2EFE1),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD0E4CF), width: 1),
              ),
              child: const Icon(
                Icons.history_rounded,
                color: Color(0xFF14451D),
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 1. Analyzed Leaf Card (Figma Screen 1)
  Widget _buildAnalyzedLeafCard(
      BuildContext context, PredictionResult result, String timeStr) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leaf Photo Container with Overlays
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: _buildLeafImage(result),
                ),
                // "● Analyzed Sample" Top Left Pill
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.circle, color: Color(0xFFD32F2F), size: 10),
                        SizedBox(width: 6),
                        Text(
                          'Analyzed Sample',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1B381E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Gradient Scrim at bottom with leaf text
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 28, 16, 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.85),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Scanned Leaf (तुमचे तपासलेले ऊस पान)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded,
                                color: Colors.white70, size: 13),
                            const SizedBox(width: 4),
                            Text(
                              'Today, $timeStr • Plot #2 (वावर क्र. २)',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Card Footer: High Clarity Image & Scan Again Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.verified_outlined,
                        color: Color(0xFF2E7D32), size: 18),
                    SizedBox(width: 6),
                    Text(
                      'High Clarity Image',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B381E),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ScanCameraScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.camera_alt_outlined, size: 16),
                  label: const Text('Scan Again (पुन्हा स्कॅन करा)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC8E6C9),
                    foregroundColor: const Color(0xFF14451D),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    textStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeafImage(PredictionResult result) {
    final path = result.imagePath;
    if (path != null && !path.startsWith('assets/')) {
      if (kIsWeb) {
        return Image.network(
          path,
          fit: BoxFit.cover,
          errorBuilder: (ctx, err, stack) => _buildLeafImageFallback(),
        );
      }
      try {
        final file = File(path);
        if (file.existsSync()) {
          return Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, stack) => _buildLeafImageFallback(),
          );
        }
      } catch (_) {}
    }

    return _buildLeafImageFallback();
  }

  Widget _buildLeafImageFallback() {
    return Image.asset(
      'assets/images/disease_red_rot.png',
      fit: BoxFit.cover,
      errorBuilder: (ctx, err, stack) => Image.asset(
        'assets/images/leaf_in_viewfinder.png',
        fit: BoxFit.cover,
        errorBuilder: (ctx2, err2, stack2) => Container(
          color: const Color(0xFFE8F5E9),
          child: const Center(
            child: Icon(Icons.eco_rounded, size: 64, color: Color(0xFF2E7D32)),
          ),
        ),
      ),
    );
  }

  /// 2. Diagnostic Assessment Card (Figma Screen 1 & 2)
  Widget _buildDiagnosticAssessmentCard(
      BuildContext context, PredictionResult result, DiseaseInfo disease) {
    final scan = context.watch<ScanProvider>();
    final confidencePct = (result.confidenceScore * 100).toInt();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Red Accent Stripe (matching Figma)
            Container(
              width: 5,
              decoration: const BoxDecoration(
                color: Color(0xFFD32F2F),
                borderRadius: BorderRadius.horizontal(left: Radius.circular(18)),
              ),
            ),
            // Main Assessment Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title
                    const Text(
                      'DIAGNOSTIC ASSESSMENT (प्राथमिक अंदाज)',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: Color(0xFF5A7262),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Disease Pill & Confidence Score Pill Row
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // Red pill for Possible Red Rot
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFFFFCDD2), width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.coronavirus_outlined,
                                  color: Color(0xFFD32F2F), size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'Possible ${disease.name} / ${disease.marathiName.split(' ')[0]}',
                                style: const TextStyle(
                                  color: Color(0xFFC62828),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Green pill for Confidence
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$confidencePct% CONFIDENCE',
                            style: const TextStyle(
                              color: Color(0xFF2E7D32),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Information highlight box (Figma Screen 1)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F8ED),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(Icons.info_outline,
                              color: Color(0xFF2E7D32), size: 16),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Model pattern matching confidence score — not a laboratory or chemical confirmation.',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF1B5E20),
                                height: 1.35,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Diagnostic clinical narrative (Figma Screen 1)
                    Text(
                      'The leaf pattern exhibits elongated lesions and midrib discoloration consistent with early-stage ${disease.name} (${disease.scientificName}). Field confirmation recommended.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF37474F),
                        height: 1.45,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Two Action Buttons: Learn Disease & Save Report (Figma Screen 2)
                    Row(
                      children: [
                        // 1. Learn Disease Button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DiseaseDetailScreen(disease: disease),
                                ),
                              );
                            },
                            icon: const Icon(Icons.menu_book_outlined, size: 16),
                            label: const Text('Learn Disease\nरोगाची माहिती',
                                textAlign: TextAlign.center),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD7EBD8),
                              foregroundColor: const Color(0xFF14451D),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              textStyle: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // 2. Save Report Button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: scan.isSavingReport ? null : _handleSaveReport,
                            icon: scan.isSavingReport
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Icon(
                                    scan.reportSavedSuccess
                                        ? Icons.check_circle_rounded
                                        : Icons.bookmark_outline_rounded,
                                    size: 16,
                                    color: scan.reportSavedSuccess
                                        ? const Color(0xFFC8E6C9)
                                        : Colors.white,
                                  ),
                            label: Text(
                              scan.isSavingReport
                                  ? 'Saving...\nसेव्ह होत आहे...'
                                  : (scan.reportSavedSuccess
                                      ? 'Saved ✓\nसेव्ह केले ✓'
                                      : 'Save Report\nअहवाल सेव्ह करा'),
                              textAlign: TextAlign.center,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: scan.reportSavedSuccess
                                  ? const Color(0xFF0F3E1E)
                                  : const Color(0xFF165228),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              textStyle: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Indicative result warning note (Figma Screen 2)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F8E9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFDCEDC8)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(Icons.error_outline_rounded,
                              color: Color(0xFF689F38), size: 16),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Indicative result only: Soil nutrition stress, borer insect damage, or rust pustules can show overlapping foliar symptoms. Always verify before chemical application.',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF33691E),
                                height: 1.35,
                              ),
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
        ),
      ),
    );
  }

  /// 3. What should I do next? (Figma Screen 2 & 3)
  Widget _buildActionStepsSection(List<DiseaseActionStep> steps) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFF2E7D32),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.eco_rounded,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'What should I do next?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF14451D),
                    ),
                  ),
                  Text(
                    'पुढे काय करावे?',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...steps.map((step) => _buildStepCard(step)),
        ],
      ),
    );
  }

  Widget _buildStepCard(DiseaseActionStep step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular number badge
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFC8E6C9),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${step.stepNumber}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1B5E20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14451D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5A7262),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 4. Recommended Products (Figma Screen 3 & 4)
  Widget _buildRecommendedProductsSection(
      BuildContext context, List<RecommendedProduct> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recommended Products',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF14451D),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFE2EFE1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'SAMPLE CATALOG',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2E7D32),
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        const Text(
          'शिफारस केलेली उत्पादने • Registered under CIBRC guidance',
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF5A7262),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 14),

        // Product Cards
        ...products.map((product) => _buildProductCard(context, product)),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, RecommendedProduct product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row with Image + Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 82,
                  height: 82,
                  color: const Color(0xFFF1F5EE),
                  child: Image.asset(
                    product.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => const Icon(
                      Icons.agriculture_rounded,
                      color: Color(0xFF2E7D32),
                      size: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Category tag, Title, Subtitle, Price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.categoryTag,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                        color: product.categoryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14451D),
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.marathiName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF5A7262),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '₹${product.verifiedMrp.toInt()}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF14451D),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Verified MRP',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF757575),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Purpose Container (Figma Screen 3 & 4)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8ED),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Purpose: ${product.purpose}',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF1B5E20),
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // View Product Details Button (Figma Screen 3 & 4)
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(product: product),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'View Product Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Expert Advisory Shield Card (Figma Screen 4)
  Widget _buildExpertAdvisoryShieldCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.shield_outlined, color: Color(0xFF2E7D32), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Consult an agricultural expert before purchasing or applying any crop protectant. Never apply chemicals without verifying local Krishi Vigyan Kendra advisory.',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF1B5E20),
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 5. Compare Prices (Figma Screen 4 & 5)
  Widget _buildComparePricesSection(
      BuildContext context, List<RecommendedProduct> products) {
    final firstProduct = products.isNotEmpty ? products.first : null;
    final isOnline = _priceTab == PriceComparisonTab.online;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with sparkline icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Compare Prices (किंमत तुलना)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF14451D),
                ),
              ),
              Icon(Icons.show_chart_rounded, color: Color(0xFF2E7D32), size: 22),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Prices updated: 24 May 2024 • Western Maharashtra Agri Markets',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF757575),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),

          // Segmented Tabs: Online Sellers vs Local Krishi Kendras
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFD7EBD8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _priceTab = PriceComparisonTab.online;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isOnline ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: isOnline
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Online Sellers',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isOnline ? FontWeight.w800 : FontWeight.w600,
                          color: const Color(0xFF14451D),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _priceTab = PriceComparisonTab.offline;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: !isOnline ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: !isOnline
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Local Krishi Kendras',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: !isOnline ? FontWeight.w800 : FontWeight.w600,
                          color: const Color(0xFF14451D),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Price Comparison Rows
          if (isOnline) ...[
            _buildPriceRow(
              seller: 'MahaAgri Direct',
              subtitle: '1 kg Pack • In Stock',
              price: 175,
              onTap: () {
                if (firstProduct != null && firstProduct.onlineOffers.isNotEmpty) {
                  AgriProductService.openOfferLink(
                      context, firstProduct.onlineOffers.first);
                }
              },
            ),
            _buildPriceRow(
              seller: 'KisanSeva Mart',
              subtitle: '1 kg Pack • In Stock',
              price: 185,
              onTap: () {
                if (firstProduct != null &&
                    firstProduct.onlineOffers.length > 1) {
                  AgriProductService.openOfferLink(
                      context, firstProduct.onlineOffers[1]);
                }
              },
            ),
            _buildPriceRow(
              seller: 'AgroStar Kolhapur',
              subtitle: '1 kg Pack • Limited Stock',
              price: 190,
              onTap: () {
                if (firstProduct != null &&
                    firstProduct.onlineOffers.length > 2) {
                  AgriProductService.openOfferLink(
                      context, firstProduct.onlineOffers[2]);
                }
              },
            ),
          ] else ...[
            _buildPriceRow(
              seller: 'Shree Ganesh Krishi Seva Kendra',
              subtitle: 'Market Yard, Satara • In Stock',
              price: 185,
              buttonLabel: 'Check Store',
              onTap: () {
                final kendras = AgriProductService.getNearbyKendras();
                if (kendras.isNotEmpty) {
                  AgriProductService.callShop(context, kendras.first);
                }
              },
            ),
            _buildPriceRow(
              seller: 'Kisan Vikas Agro Agency',
              subtitle: 'Old MIDC, Kolhapur • In Stock',
              price: 180,
              buttonLabel: 'Check Store',
              onTap: () {
                final kendras = AgriProductService.getNearbyKendras();
                if (kendras.length > 1) {
                  AgriProductService.callShop(context, kendras[1]);
                }
              },
            ),
            _buildPriceRow(
              seller: 'Baliraja Krishi Kendra',
              subtitle: 'Karad Highway • Counter Ready',
              price: 185,
              buttonLabel: 'Check Store',
              onTap: () {
                final kendras = AgriProductService.getNearbyKendras();
                if (kendras.length > 2) {
                  AgriProductService.callShop(context, kendras[2]);
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required String seller,
    required String subtitle,
    required int price,
    String buttonLabel = 'View Offer',
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8ED),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seller,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14451D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹$price',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Color(0xFF14451D),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFC8E6C9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                buttonLabel,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF14451D),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 6. Find Near Me (Figma Screen 5)
  Widget _buildFindNearMeSection(
      BuildContext context, List<KrishiKendra> kendras) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with store icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Find Near Me',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF14451D),
                ),
              ),
              Icon(Icons.storefront_outlined,
                  color: Color(0xFF2E7D32), size: 22),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'जवळची कृषी सेवा केंद्रे',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF5A7262),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),

          // Location Selector Bar (Figma Screen 5)
          GestureDetector(
            onTap: _showRegionPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F8ED),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      color: Color(0xFF2E7D32), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedRegion.split(',')[0],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF14451D),
                          ),
                        ),
                        const Text(
                          'Maharashtra',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF757575),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Use GPS Button
                  ElevatedButton.icon(
                    onPressed: _isUsingGps ? null : _simulateGpsLocation,
                    icon: _isUsingGps
                        ? const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.gps_fixed, size: 14),
                    label: Text(_isUsingGps ? 'Locating...' : 'Use GPS'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      textStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Map Preview Card (Figma Screen 5)
          Container(
            width: double.infinity,
            height: 110,
            decoration: BoxDecoration(
              color: const Color(0xFFC4DCC8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // Visual Map contours/grid lines
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MapVisualPainter(),
                  ),
                ),
                // Centered "2 Verified Centers Nearby" pill
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.circle,
                            color: Color(0xFF2E7D32), size: 10),
                        const SizedBox(width: 8),
                        Text(
                          '${kendras.length} Verified Centers Nearby',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF14451D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Nearby Stores List (Figma Screen 5)
          ...kendras.map((shop) => _buildStoreCard(context, shop)),
        ],
      ),
    );
  }

  Widget _buildStoreCard(BuildContext context, KrishiKendra shop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCE8DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and Licensed Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  shop.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14451D),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFD7EBD8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Licensed',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${shop.address} • ${shop.distanceKm} km away',
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF5A7262),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          // In Stock Pill (Figma Screen 5)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD0E4CF)),
            ),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined,
                    color: Color(0xFF2E7D32), size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    shop.inStockSummary,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF14451D),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Two Action Buttons: Call Shop & Directions (Figma Screen 5)
          Row(
            children: [
              // 1. Call Shop Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => AgriProductService.callShop(context, shop),
                  icon: const Icon(Icons.call_outlined, size: 15),
                  label: const Text('Call Shop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD7EBD8),
                    foregroundColor: const Color(0xFF14451D),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 2. Directions Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () =>
                      AgriProductService.openDirections(context, shop),
                  icon: const Icon(Icons.turn_right_rounded, size: 16),
                  label: const Text('Directions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF165228),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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

  /// 7. Buy Online Card (from Screenshot 6)
  Widget _buildBuyOnlineCard(BuildContext context, RecommendedProduct product) {
    final lowestPrice = product.onlineOffers.isNotEmpty
        ? product.onlineOffers
            .map((o) => o.price)
            .reduce((a, b) => a < b ? a : b)
            .toInt()
        : product.verifiedMrp.toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFC8E6C9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: Color(0xFF1B5E20),
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Buy Online (ऑनलाईन खरेदी)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14451D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${product.name} ${product.packSize}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5A7262),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'From ₹$lowestPrice • Doorstep delivery',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () {
              if (product.onlineOffers.isNotEmpty) {
                AgriProductService.showOnlineBuySheet(context, product);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(product: product),
                  ),
                );
              }
            },
            icon: const Icon(Icons.shopping_cart_outlined, size: 16),
            label: const Text('खरेदी करा'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF165228),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 8. Ask an Expert Card (from Screenshot 6)
  Widget _buildAskExpertCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFD7EBD8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF165228),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Not sure which product is right?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14451D),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'कोणते औषध योग्य आहे?',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Get free guidance from a qualified agricultural officer or KVK agronomist before spraying your crop.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF2E4632),
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AskQuestionScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
              label: const Text(
                'Ask an Expert (कृषी तज्ज्ञांना विचारा)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF165228),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter to draw aesthetic geographic map roads and contours
class _MapVisualPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final roadPaintThin = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Diagonal arterial roads
    final path1 = Path()
      ..moveTo(0, size.height * 0.3)
      ..cubicTo(size.width * 0.3, size.height * 0.4, size.width * 0.7,
          size.height * 0.2, size.width, size.height * 0.5);
    canvas.drawPath(path1, roadPaint);

    final path2 = Path()
      ..moveTo(size.width * 0.2, size.height)
      ..cubicTo(size.width * 0.4, size.height * 0.6, size.width * 0.6,
          size.height * 0.7, size.width * 0.8, 0);
    canvas.drawPath(path2, roadPaintThin);

    // Decorative pin points
    final pinPaint = Paint()..color = const Color(0xFF2E7D32);
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.4), 4, pinPaint);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.65), 4, pinPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
