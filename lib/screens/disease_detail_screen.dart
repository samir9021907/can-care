import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../models/disease_info.dart';
import '../services/agri_product_service.dart';
import '../widgets/leaf_decoration.dart';
import 'product_detail_screen.dart';
import 'scan_camera_screen.dart';

class DiseaseDetailScreen extends StatelessWidget {
  final DiseaseInfo disease;

  const DiseaseDetailScreen({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final lang = loc.language;

    final shortName = disease.getLocalizedName(lang);
    final symptoms = disease.getLocalizedSymptoms(lang);
    final causes = disease.getLocalizedCauses(lang);
    final cultural = disease.treatment.getCulturalPractices(lang);
    final organic = disease.treatment.getOrganicMeasures(lang);
    final preventive = disease.treatment.getPreventiveSteps(lang);
    final expertNote = disease.treatment.getExpertNote(lang);

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
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: const Color(0xFFE2EFE1)),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: Image.asset(
                                            p.imageAsset,
                                            fit: BoxFit.cover,
                                            errorBuilder: (ctx, err, stack) =>
                                                const Icon(
                                              Icons.agriculture_rounded,
                                              color: Color(0xFF2E7D32),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              p.getLocalizedName(lang),
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF14451D),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '₹${p.verifiedMrp.toInt()} • ${p.packSize}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
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
                                              builder: (_) =>
                                                  ProductDetailScreen(
                                                      product: p),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF165228),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          'View',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),

                        const SizedBox(height: 16),
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
}
