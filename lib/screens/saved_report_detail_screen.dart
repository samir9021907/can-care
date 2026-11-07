import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../localization/app_localizations.dart';
import '../models/disease_info.dart';
import '../models/recommended_product.dart';
import '../models/scan_report.dart';
import '../providers/history_provider.dart';
import '../services/agri_product_service.dart';
import '../widgets/severity_badge.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/nearby_krishi_kendras_widget.dart';
import 'ask_question_screen.dart';
import 'disease_detail_screen.dart';
import 'product_detail_screen.dart';

class SavedReportDetailScreen extends StatefulWidget {
  final ScanReport report;

  const SavedReportDetailScreen({super.key, required this.report});

  @override
  State<SavedReportDetailScreen> createState() =>
      _SavedReportDetailScreenState();
}

class _SavedReportDetailScreenState extends State<SavedReportDetailScreen> {
  bool _isOnlinePriceTab = true;

  void _handleDelete(BuildContext context) async {
    final loc = AppLocalizations.of(context);
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete Scan Report',
      message:
          'Are you sure you want to delete this report from your offline history? This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: loc.translate('back'),
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      final history = context.read<HistoryProvider>();
      final deleted = await history.deleteReport(widget.report.id);
      if (deleted && context.mounted) {
        Navigator.pop(context);
        AppSnackBar.showSuccess(context, 'Report deleted successfully.');
      }
    }
  }

  void _handleExport(BuildContext context) {
    final loc = AppLocalizations.of(context);
    AppSnackBar.showSuccess(
      context,
      '${widget.report.getLocalizedName(loc.language)} - summary ready to share.',
    );
  }

  DiseaseInfo _findDisease() {
    final diseases = DiseaseInfo.getSugarcaneDiseases();
    final resName = widget.report.diseaseName.toLowerCase();
    for (final d in diseases) {
      if (resName.contains(d.name.toLowerCase()) ||
          d.name.toLowerCase().contains(resName) ||
          (d.scientificName.isNotEmpty &&
              widget.report.scientificName
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
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy • hh:mm a');
    final disease = _findDisease();
    final recommendedProducts =
        AgriProductService.getProductsForDisease(widget.report.diseaseName);
    final actionSteps =
        AgriProductService.getActionSteps(widget.report.diseaseName);
    final nearbyKendras = AgriProductService.getNearbyKendras();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F0),
      appBar: AppBar(
        title: Text(
          loc.translate('detection_result'),
          style: const TextStyle(
            color: Color(0xFF14451D),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: const Color(0xFFF3F7F0),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF14451D)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF14451D)),
            tooltip: 'Share Report',
            onPressed: () => _handleExport(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFFD32F2F)),
            tooltip: 'Delete Report',
            onPressed: () => _handleDelete(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Thumbnail / Banner
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: _buildReportImage(widget.report.imagePath),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.bookmark_added_rounded,
                                  color: Color(0xFF2E7D32), size: 14),
                              SizedBox(width: 6),
                              Text(
                                'Saved Offline Report',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
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
              ),
              const SizedBox(height: 16),

              // Title and Severity Row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.report.getLocalizedName(loc.language),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF14451D),
                                ),
                              ),
                              if (widget.report.scientificName.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  widget.report.scientificName,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                    color: Color(0xFF5A7262),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SeverityBadge(
                          severity: widget.report.severity,
                          isDemoBadge: false,
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.analytics_outlined,
                                size: 16, color: Color(0xFF2E7D32)),
                            const SizedBox(width: 6),
                            Text(
                              '${loc.translate('confidence_score')}:',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF5A7262),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.report.confidenceDisplay,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF14451D),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            size: 15, color: Color(0xFF757575)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            dateFormat.format(widget.report.scanDate),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Field Notes
              if (widget.report.fieldNotes.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFC8E6C9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.edit_note_rounded,
                              size: 18, color: Color(0xFF2E7D32)),
                          SizedBox(width: 6),
                          Text(
                            'Field Notes (शेतकऱ्याची नोंद)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF14451D),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.report.fieldNotes,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF2E3D30),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Learn Disease Shortcut Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DiseaseDetailScreen(disease: disease),
                      ),
                    );
                  },
                  icon: const Icon(Icons.menu_book_outlined, size: 16),
                  label: const Text('Learn Disease Profile (रोगाची संपूर्ण माहिती)'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF14451D),
                    side: const BorderSide(color: Color(0xFFC8E6C9)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // What should I do next?
              _buildActionSteps(actionSteps),
              const SizedBox(height: 22),

              // Recommended Products Section
              _buildRecommendedProducts(context, recommendedProducts),
              const SizedBox(height: 20),

              // Compare Prices Section
              _buildComparePrices(context, recommendedProducts),
              const SizedBox(height: 20),

              // Find Near Me Section (जवळची कृषी सेवा केंद्रे - थेट GPS)
              const NearbyKrishiKendrasWidget(initialRadiusKm: 100.0),
              const SizedBox(height: 14),

              // Verified Dealers Registration Footer (Screenshot 6)
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

              // Buy Online Card (Screenshot 6)
              if (recommendedProducts.isNotEmpty)
                _buildBuyOnlineCard(context, recommendedProducts.first),
              const SizedBox(height: 16),

              // Ask an Expert Card (Screenshot 6)
              _buildAskExpertCard(context),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportImage(String? path) {
    if (path == null || path.isEmpty) {
      return _fallbackImage();
    }
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) => _fallbackImage(),
      );
    }
    return Image.network(
      path,
      fit: BoxFit.cover,
      errorBuilder: (ctx, err, stack) => _fallbackImage(),
    );
  }

  Widget _fallbackImage() {
    return Container(
      color: const Color(0xFFE8F5E9),
      child: const Center(
        child: Icon(Icons.eco_rounded, size: 54, color: Color(0xFF2E7D32)),
      ),
    );
  }

  Widget _buildActionSteps(List<DiseaseActionStep> steps) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.check_circle_outline_rounded,
                  color: Color(0xFF2E7D32), size: 20),
              SizedBox(width: 8),
              Text(
                'What should I do next? (पुढे काय करावे?)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF14451D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...steps.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC8E6C9),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${s.stepNumber}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF14451D),
                          ),
                        ),
                        Text(
                          s.description,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF5A7262),
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
    );
  }

  Widget _buildRecommendedProducts(
      BuildContext context, List<RecommendedProduct> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Recommended Products',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF14451D),
              ),
            ),
            Text(
              'Verified MRP',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E7D32),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...products.map(
          (p) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Image.asset(
                      p.imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(
                        Icons.agriculture_rounded,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF14451D),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        p.marathiName,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF5A7262),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${p.verifiedMrp.toInt()} • ${p.packSize}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: p),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF165228),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Details',
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComparePrices(
      BuildContext context, List<RecommendedProduct> products) {
    final nearbyKendras = AgriProductService.getNearbyKendras();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Compare Prices (किंमत तुलना)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF14451D),
                ),
              ),
              Icon(Icons.price_change_outlined,
                  color: Color(0xFF2E7D32), size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isOnlinePriceTab = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: _isOnlinePriceTab
                          ? const Color(0xFFC8E6C9)
                          : const Color(0xFFF1F5EE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Online Sellers',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: _isOnlinePriceTab
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: const Color(0xFF14451D),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isOnlinePriceTab = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: !_isOnlinePriceTab
                          ? const Color(0xFFC8E6C9)
                          : const Color(0xFFF1F5EE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Local Krishi Kendras',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: !_isOnlinePriceTab
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: const Color(0xFF14451D),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_isOnlinePriceTab) ...[
            _priceItem('MahaAgri Direct', '₹175', 'In Stock (उपलब्ध)'),
            _priceItem('KisanSeva Mart', '₹185', 'In Stock (उपलब्ध)'),
            _priceItem('AgroStar Direct', '₹190', 'In Stock (उपलब्ध)'),
          ] else ...[
            ...nearbyKendras.take(3).map(
                  (k) => _priceItem(
                    k.marathiName.isNotEmpty ? k.marathiName : k.name,
                    '₹180',
                    '${k.distanceKm} km • उपलब्ध',
                  ),
                ),
          ],
        ],
      ),
    );
  }

  Widget _priceItem(String name, String price, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '$name ($status)',
              style: const TextStyle(fontSize: 12, color: Color(0xFF2E3D30)),
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF14451D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFindNearMe(BuildContext context, List<KrishiKendra> kendras) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Find Near Me (जवळची कृषी सेवा केंद्रे)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF14451D),
                ),
              ),
              Icon(Icons.storefront_outlined,
                  color: Color(0xFF2E7D32), size: 20),
            ],
          ),
          const SizedBox(height: 10),
          ...kendras.map(
            (k) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAF5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFDCE8DC)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          k.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF14451D),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD7EBD8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Licensed',
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2E7D32))),
                      ),
                    ],
                  ),
                  Text(
                    '${k.address} • ${k.distanceKm} km away',
                    style:
                        const TextStyle(fontSize: 11, color: Color(0xFF5A7262)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              AgriProductService.callShop(context, k),
                          icon: const Icon(Icons.call, size: 14),
                          label: const Text('Call Shop'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF14451D),
                            side: const BorderSide(color: Color(0xFFC8E6C9)),
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              AgriProductService.openDirections(context, k),
                          icon: const Icon(Icons.directions, size: 14),
                          label: const Text('Directions'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF165228),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                          ),
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
    );
  }

  Widget _buildBuyOnlineCard(
      BuildContext context, RecommendedProduct product) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFC8E6C9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: Color(0xFF1B5E20),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Buy Online (ऑनलाईन खरेदी)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14451D),
                  ),
                ),
                Text(
                  '${product.name} ${product.packSize}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF5A7262),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  'From ₹175 • Doorstep delivery',
                  style: TextStyle(fontSize: 10, color: Color(0xFF757575)),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              if (product.onlineOffers.isNotEmpty) {
                AgriProductService.showOnlineBuySheet(context, product);
              }
            },
            icon: const Icon(Icons.shopping_cart_outlined, size: 14),
            label: const Text('खरेदी करा'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF165228),
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(0, 36),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              textStyle:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAskExpertCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD7EBD8),
        borderRadius: BorderRadius.circular(16),
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
                  color: Color(0xFF165228),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.support_agent_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Not sure which product is right?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14451D),
                      ),
                    ),
                    Text(
                      'कोणते औषध योग्य आहे?',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Get free guidance from a qualified agricultural officer or KVK agronomist before spraying your crop.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF2E4632),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AskQuestionScreen()),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
              label: const Text(
                'Ask an Expert (कृषी तज्ज्ञांना विचारा)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF165228),
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(0, 42),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}