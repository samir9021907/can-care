import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../models/disease_info.dart';
import '../models/recommended_product.dart';
import '../services/agri_product_service.dart';
import '../widgets/leaf_decoration.dart';
import '../widgets/nearby_krishi_kendras_widget.dart';
import 'ask_question_screen.dart';
import 'product_detail_screen.dart';
import 'scan_camera_screen.dart';

class DiseaseDetailScreen extends StatelessWidget {
  final DiseaseInfo disease;

  const DiseaseDetailScreen({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    final isOnlineNotifier = ValueNotifier<bool>(true);
    final loc = AppLocalizations.of(context);
    final lang = loc.language;

    final shortName = disease.getLocalizedName(lang);
    final symptoms = disease.getLocalizedSymptoms(lang);
    final causes = disease.getLocalizedCauses(lang);
    final cultural = disease.treatment.getCulturalPractices(lang);
    final organic = disease.treatment.getOrganicMeasures(lang);
    final preventive = disease.treatment.getPreventiveSteps(lang);
    final expertNote = disease.treatment.getExpertNote(lang);
    final recommendedProducts =
        AgriProductService.getProductsForDisease(disease.id);
    final nearbyKendras = AgriProductService.getNearbyKendras();

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
          shortName,
          style: const TextStyle(
            color: Color(0xFF14451D),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Stack(
        children: [
          // Watercolor foliage at bottom
          const LeafDecorationBackground(height: 120),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Leaf Photo Card
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            width: double.infinity,
                            height: 170,
                            child: Image.asset(
                              disease.id == 'red_rot'
                                  ? 'assets/images/detail_red_rot_banner.png'
                                  : disease.imageAsset,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: const Color(0xFFE8F5E9),
                                child: const Center(
                                  child: Icon(
                                    Icons.eco_rounded,
                                    color: Color(0xFF2E7D32),
                                    size: 48,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Section 1: Overview / ओळख व तपशील
                        Text(
                          loc.translate('section_overview'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF14451D),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          disease.getLocalizedOverview(lang),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF3B5241),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Section 2: Common Symptoms / मुख्य लक्षणे
                        Text(
                          loc.translate('section_symptoms'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF14451D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...symptoms.map(
                          (s) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: _buildBullet(s),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Section 3: Conditions / कारणे व अनुकूल परिस्थिती
                        Text(
                          loc.translate('section_causes'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF14451D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...causes.map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: _buildBullet(c),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Section 4: Treatment & Management / उपाययोजना
                        Text(
                          loc.translate('section_treatment'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF14451D),
                          ),
                        ),
                        const SizedBox(height: 10),

                        if (cultural.isNotEmpty) ...[
                          Text(
                            loc.translate('cultural_practices'),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(height: 6),
                          ...cultural.map(
                            (cp) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: _buildBullet(cp),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        if (organic.isNotEmpty) ...[
                          Text(
                            loc.translate('organic_measures'),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(height: 6),
                          ...organic.map(
                            (om) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: _buildBullet(om),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        if (preventive.isNotEmpty) ...[
                          Text(
                            loc.translate('preventive_steps'),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(height: 6),
                          ...preventive.map(
                            (ps) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: _buildBullet(ps),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],

                        // Expert Note Banner
                        if (expertNote.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFA5D6A7)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.info_outline_rounded,
                                    color: Color(0xFF1B5E20), size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    expertNote,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF14451D),
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 20),
                        // Recommended Products for this disease
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lang == AppLanguage.marathi
                                  ? 'शिफारस केलेली उत्पादने'
                                  : 'Recommended Products',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF14451D),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2EFE1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'CIBRC',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...AgriProductService.getProductsForDisease(disease.id)
                            .map((p) => Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: const Color(0xFFDCE8DC),
                                        width: 1.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF14451D)
                                            .withValues(alpha: 0.04),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                ProductDetailScreen(product: p),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Product Image
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    width: 62,
                                                    height: 62,
                                                    color:
                                                        const Color(0xFFF1F5EE),
                                                    child: Image.asset(
                                                      p.imageAsset,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (ctx, err,
                                                              stack) =>
                                                          const Center(
                                                        child: Icon(
                                                          Icons
                                                              .agriculture_rounded,
                                                          color:
                                                              Color(0xFF2E7D32),
                                                          size: 32,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                // Product Details
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // Category badge
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 6,
                                                                vertical: 2),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xFFE8F5E9),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        child: Text(
                                                          p.getLocalizedCategory(
                                                              lang),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Color(
                                                                0xFF2E7D32),
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      // Product Title
                                                      Text(
                                                        p.getLocalizedName(
                                                            lang),
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color:
                                                              Color(0xFF14451D),
                                                          height: 1.25,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      // Price & Pack Size
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '₹${p.verifiedMrp.toInt()}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              color: Color(
                                                                  0xFF165228),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 6),
                                                          Text(
                                                            '• ${p.packSize}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color(
                                                                  0xFF5A7262),
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
                                            // Purpose note
                                            if (p.getLocalizedPurpose(lang).isNotEmpty)
                                              Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 6),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFF7FAF5),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xFFE2EFE1)),
                                                ),
                                                child: Text(
                                                  p.getLocalizedPurpose(lang),
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF3B5241),
                                                    height: 1.35,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            const SizedBox(height: 10),
                                            // Full-width Action Button
                                            SizedBox(
                                              width: double.infinity,
                                              height: 38,
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          ProductDetailScreen(
                                                              product: p),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                    Icons.shopping_bag_outlined,
                                                    size: 16),
                                                label: Text(
                                                  lang == AppLanguage.marathi
                                                      ? 'तपशील व खरेदी पर्याय पहा (View Product)'
                                                      : (lang == AppLanguage.hindi
                                                          ? 'उत्पाद विवरण देखें (View Product)'
                                                          : 'View Product Details'),
                                                  style: const TextStyle(
                                                    fontSize: 12.5,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF165228),
                                                  foregroundColor: Colors.white,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )),

                        const SizedBox(height: 16),

                        // Compare Prices Section (किंमत तुलना)
                        _buildComparePrices(context, recommendedProducts, isOnlineNotifier),
                        const SizedBox(height: 18),

                        // Find Near Me Section (जवळची कृषी सेवा केंद्रे / मेडिकल - थेट GPS)
                        const NearbyKrishiKendrasWidget(initialRadiusKm: 100.0),
                        const SizedBox(height: 14),

                        // Verified Dealers Registration Footer
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
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

                        // Buy Online Card (ऑनलाईन खरेदी)
                        if (recommendedProducts.isNotEmpty)
                          _buildBuyOnlineCard(context, recommendedProducts.first),
                        const SizedBox(height: 16),

                        // Ask an Expert Card (कृषी तज्ज्ञांना विचारा)
                        _buildAskExpertCard(context),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Button: "Scan Leaf"
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ScanCameraScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.camera_alt_outlined, size: 20),
                      label: Text(
                        loc.translate('scan_leaf_button'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF153B28),
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComparePrices(
      BuildContext context, List<RecommendedProduct> products, ValueNotifier<bool> isOnlineNotifier) {
    final nearbyKendras = AgriProductService.getNearbyKendras();
    return ValueListenableBuilder<bool>(
      valueListenable: isOnlineNotifier,
      builder: (context, isOnline, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFDCE8DC)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF14451D).withValues(alpha: 0.04),
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
                      onTap: () => isOnlineNotifier.value = true,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          color: isOnline
                              ? const Color(0xFFC8E6C9)
                              : const Color(0xFFF1F5EE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Online Sellers',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: isOnline
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
                      onTap: () => isOnlineNotifier.value = false,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          color: !isOnline
                              ? const Color(0xFFC8E6C9)
                              : const Color(0xFFF1F5EE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Local Krishi Kendras',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: !isOnline
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
              if (isOnline) ...[
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
      },
    );
  }

  Widget _priceItem(String name, String price, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
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
        border: Border.all(color: const Color(0xFFDCE8DC)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF14451D).withValues(alpha: 0.04),
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
        border: Border.all(color: const Color(0xFFDCE8DC)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF14451D).withValues(alpha: 0.04),
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
