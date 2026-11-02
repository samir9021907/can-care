import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/app_localizations.dart';
import '../models/disease_info.dart';
import '../providers/disease_library_provider.dart';
import '../widgets/disease_card.dart';
import '../widgets/empty_state_view.dart';
import 'disease_detail_screen.dart';
import 'crop_tips_screen.dart';
import 'scan_camera_screen.dart';
import 'ask_question_screen.dart';

class DiseaseLibraryScreen extends StatefulWidget {
  const DiseaseLibraryScreen({super.key});

  @override
  State<DiseaseLibraryScreen> createState() => _DiseaseLibraryScreenState();
}

class _DiseaseLibraryScreenState extends State<DiseaseLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final lang = loc.language;
    final library = context.watch<DiseaseLibraryProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAF5),
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 18),
          child: Icon(
            Icons.menu_book_outlined,
            color: Color(0xFF14451D),
            size: 24,
          ),
        ),
        leadingWidth: 46,
        title: Text(
          lang == AppLanguage.marathi
              ? 'ऊस रोग माहिती'
              : (lang == AppLanguage.hindi
                  ? 'गन्ना रोग पुस्तकालय'
                  : 'Disease Library'),
          style: const TextStyle(
            color: Color(0xFF14451D),
            fontSize: 19,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // 1. SEARCH BAR ("Search diseases...")
              // ==========================================
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border:
                      Border.all(color: const Color(0xFFE2E8F0), width: 1.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => library.setSearchQuery(val),
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF153B28),
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: lang == AppLanguage.marathi
                        ? 'रोग शोधा (उदा. तांबेरा, लाल कुज)...'
                        : (lang == AppLanguage.hindi
                            ? 'रोग खोजें (उदा. लाल सड़न)...'
                            : 'Search diseases...'),
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFA0AEC0),
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF7A9280),
                      size: 21,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              size: 17,
                              color: Color(0xFF7A9280),
                            ),
                            onPressed: () {
                              _searchController.clear();
                              library.setSearchQuery('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ==========================================
              // 2. FILTER PILLS: All (सर्व) | Diseased (बाधित) | Healthy (निरोगी)
              // ==========================================
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildFilterPill(
                      keyName: 'All',
                      label: 'All (सर्व)',
                      isSelected: library.selectedCategory == 'All',
                      onTap: () => library.setCategory('All'),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterPill(
                      keyName: 'Diseased',
                      label: 'Diseased (बाधित)',
                      isSelected: library.selectedCategory == 'Diseased',
                      onTap: () => library.setCategory('Diseased'),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterPill(
                      keyName: 'Healthy',
                      label: 'Healthy (निरोगी)',
                      isSelected: library.selectedCategory == 'Healthy',
                      onTap: () => library.setCategory('Healthy'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ==========================================
              // 3. SECTION: FIELD IDENTIFICATION (6 Diagnostic Profiles)
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Field Identification',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF14451D),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${library.diseases.length} Diagnostic Profiles',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B8074),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 6 Diagnostic Profile Cards in 2-Column Grid
              if (library.isSearchEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: EmptyStateView(
                    icon: Icons.search_off_rounded,
                    title: 'No search results',
                    message: 'No sugarcane disease matching your query found.',
                    buttonText: 'Reset Search',
                    onButtonPressed: () {
                      _searchController.clear();
                      library.setSearchQuery('');
                      library.setCategory('All');
                    },
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.58,
                  ),
                  itemCount: library.diseases.length,
                  itemBuilder: (context, index) {
                    final disease = library.diseases[index];
                    return DiseaseGridCard(
                      disease: disease,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DiseaseDetailScreen(disease: disease),
                          ),
                        );
                      },
                    );
                  },
                ),
              const SizedBox(height: 22),

              // ==========================================
              // 4. SECTION: WHAT DO YOU NOTICE ON YOUR LEAF?
              // ==========================================
              _buildLeafSymptomExplorer(context),
              const SizedBox(height: 22),

              // ==========================================
              // 5. SECTION: COMMON SUGARCANE DISEASES (Horizontal List)
              // ==========================================
              _buildCommonDiseasesSection(context, library),
              const SizedBox(height: 22),

              // ==========================================
              // 6. SECTION: KNOW THE WARNING SIGNS
              // ==========================================
              _buildWarningSignsCard(context),
              const SizedBox(height: 20),

              // ==========================================
              // 7. SECTION: KEEP YOUR SUGARCANE HEALTHY
              // ==========================================
              _buildKeepSugarcaneHealthyCard(context),
              const SizedBox(height: 20),

              // ==========================================
              // 8. SECTION: STILL NOT SURE? (INSTANT AI DETECTION)
              // ==========================================
              _buildStillNotSureCard(context),
              const SizedBox(height: 20),

              // ==========================================
              // 9. SECTION: NEED MORE HELP? (ASK AN EXPERT)
              // ==========================================
              _buildNeedMoreHelpCard(context),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  // Filter Pill Button
  Widget _buildFilterPill({
    required String keyName,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7.5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF165228) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF165228)
                : const Color(0xFFD4DEC9),
            width: 1.1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF165228).withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 4. LEAF SYMPTOM EXPLORER CARD
  // ==========================================
  Widget _buildLeafSymptomExplorer(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5EDE7), width: 1.2),
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
          // Header Row with circular refresh/leaf icon
          Row(
            children: const [
              Icon(
                Icons.published_with_changes_rounded,
                color: Color(0xFF165228),
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'What do you notice on your leaf?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14451D),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Choose a symptom to explore possible causes in your plot.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF5A7265),
            ),
          ),
          const SizedBox(height: 14),

          // 2x2 Grid of 4 Symptom Tiles
          Row(
            children: [
              Expanded(
                child: _buildSymptomTile(
                  icon: Icons.eco_outlined,
                  iconColor: const Color(0xFFC2410C),
                  iconBg: const Color(0xFFFED7AA),
                  title: 'Yellow leaves',
                  subtitleMarathi: 'पिवळे पडणे',
                  onTap: () => _showSymptomDetailModal(
                    context,
                    title: 'Yellow leaves (पिवळे पडणे)',
                    description:
                        'Yellowing usually begins at leaf midribs or margins. Common in Yellow Leaf Disease, Nitrogen deficiency, or early viral mosaic.',
                    matchingDiseases: ['yellow_leaf', 'mosaic'],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSymptomTile(
                  icon: Icons.grain_rounded,
                  iconColor: const Color(0xFF15803D),
                  iconBg: const Color(0xFFBBF7D0),
                  title: 'Brown spots',
                  subtitleMarathi: 'तपकिरी ठिपके',
                  onTap: () => _showSymptomDetailModal(
                    context,
                    title: 'Brown spots (तपकिरी ठिपके)',
                    description:
                        'Elongated reddish-brown pustules or ring spots on both leaf surfaces indicate fungal infection such as Sugarcane Rust or Red Rot.',
                    matchingDiseases: ['rust', 'red_rot'],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildSymptomTile(
                  icon: Icons.crop_portrait_rounded,
                  iconColor: const Color(0xFFC2410C),
                  iconBg: const Color(0xFFFED7AA),
                  title: 'Drying edges',
                  subtitleMarathi: 'कडेने सुकणे',
                  onTap: () => _showSymptomDetailModal(
                    context,
                    title: 'Drying edges (कडेने सुकणे)',
                    description:
                        'Premature leaf margin scorch and tip drying often occur with advanced Rust, salinity stress, or Yellow Leaf Disease chlorosis.',
                    matchingDiseases: ['yellow_leaf', 'rust'],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSymptomTile(
                  icon: Icons.grid_view_rounded,
                  iconColor: const Color(0xFF15803D),
                  iconBg: const Color(0xFFBBF7D0),
                  title: 'Unusual patterns',
                  subtitleMarathi: 'विचित्र पट्टे',
                  onTap: () => _showSymptomDetailModal(
                    context,
                    title: 'Unusual patterns (विचित्र पट्टे)',
                    description:
                        'Mottled pale green streaks, mosaic patterns, or black whip structures signal viral Sugarcane Mosaic or fungal Smut spores.',
                    matchingDiseases: ['mosaic', 'smut'],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Diagnostic guidance disclaimer
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(
                Icons.info_outline_rounded,
                size: 15,
                color: Color(0xFF6B8074),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Symptom matching provides guidance and is not a confirmed laboratory diagnosis.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B8074),
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitleMarathi,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF8EE),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBEAD7), width: 1.0),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 19),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14451D),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitleMarathi,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B6353),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

  // ==========================================
  // 5. COMMON SUGARCANE DISEASES (Horizontal List)
  // ==========================================
  Widget _buildCommonDiseasesSection(
      BuildContext context, DiseaseLibraryProvider library) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Common Sugarcane Diseases',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14451D),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                );
                library.setCategory('All');
              },
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'View all (सर्व पहा)',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF165228),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 3 Horizontal Cards matching Image 4
        _buildCommonDiseaseRowCard(
          imageAsset: 'assets/images/disease_red_rot.png',
          title: 'Red Rot (लाल कूज)',
          subtitle: 'High incidence in Western Maharashtra & humid zones',
          onTap: () => _openDiseaseById(context, 'red_rot'),
        ),
        const SizedBox(height: 10),
        _buildCommonDiseaseRowCard(
          imageAsset: 'assets/images/disease_rust.png',
          title: 'Sugarcane Rust (तांबेरा)',
          subtitle: 'Foliar pustules in humid weather & high density plots',
          onTap: () => _openDiseaseById(context, 'rust'),
        ),
        const SizedBox(height: 10),
        _buildCommonDiseaseRowCard(
          imageAsset: 'assets/images/disease_yellow_leaf.png',
          title: 'Yellow Leaf Disease (पिवळे पान)',
          subtitle: 'Midrib chlorosis & premature drying across lower leaves',
          onTap: () => _openDiseaseById(context, 'yellow_leaf'),
        ),
      ],
    );
  }

  Widget _buildCommonDiseaseRowCard({
    required String imageAsset,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5EDE7), width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imageAsset,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 52,
                      height: 52,
                      color: const Color(0xFFE8F5E9),
                      child: const Icon(
                        Icons.eco_rounded,
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
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF14451D),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B8074),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: Color(0xFF165228),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 6. KNOW THE WARNING SIGNS CARD
  // ==========================================
  Widget _buildWarningSignsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5EDE7), width: 1.2),
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
          Row(
            children: const [
              Icon(
                Icons.verified_user_outlined,
                color: Color(0xFF165228),
                size: 22,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Know the Warning Signs',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14451D),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'रोगाची प्राथमिक लक्षणे ओळखा',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B8074),
            ),
          ),
          const SizedBox(height: 14),

          // 3 Warning Signs Items
          _buildWarningSignItem(
            icon: Icons.palette_outlined,
            iconColor: const Color(0xFF165228),
            iconBg: const Color(0xFFBBF7D0),
            title: 'Changes in leaf colour',
            description:
                'Unusual yellowing or red streaks appearing along midribs of younger and middle leaves.',
          ),
          const SizedBox(height: 12),
          _buildWarningSignItem(
            icon: Icons.grain_rounded,
            iconColor: const Color(0xFFC2410C),
            iconBg: const Color(0xFFFED7AA),
            title: 'Spots or unusual marks',
            description:
                'Raised orange-brown pustules, ring spots, or dark fungal patches spreading across blades.',
          ),
          const SizedBox(height: 12),
          _buildWarningSignItem(
            icon: Icons.trending_down_rounded,
            iconColor: const Color(0xFF15803D),
            iconBg: const Color(0xFFBBF7D0),
            title: 'Drying or abnormal growth',
            description:
                'Premature drying of leaf tips, whip-like black curls, or shortened internodes on the shoot.',
          ),
          const SizedBox(height: 14),

          // Mint Guidance Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE2F8E9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFB9F0C9), width: 1.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(
                  Icons.help_outline_rounded,
                  color: Color(0xFF165228),
                  size: 17,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Similar symptoms may stem from moisture stress, nutrient deficiency, or fungal infection. Always verify before chemical application.',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E3A24),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Learn about symptoms -> Link
          GestureDetector(
            onTap: () => _showWarningSignsGuideModal(context),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Learn about symptoms',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF165228),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                    color: Color(0xFF165228),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningSignItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 19),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF14451D),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF5A7265),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 7. KEEP YOUR SUGARCANE HEALTHY CARD
  // ==========================================
  Widget _buildKeepSugarcaneHealthyCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8EE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCBEAD7), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: const [
                    Icon(
                      Icons.health_and_safety_outlined,
                      color: Color(0xFF165228),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Keep Your Sugarcane Healthy',
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF14451D),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFBBF7D0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.yard_outlined,
                  color: Color(0xFF165228),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Simple checks can help you notice crop problems early.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4B6353),
            ),
          ),
          const SizedBox(height: 14),

          // Bullet Points
          _buildHealthCheckBullet(
            'Inspect leaves regularly across different field sections and drainage channels.',
          ),
          const SizedBox(height: 10),
          _buildHealthCheckBullet(
            'Keep track of changes, moisture levels, and seasonal pest movements in your crop.',
          ),
          const SizedBox(height: 10),
          _buildHealthCheckBullet(
            'Ask an agricultural expert if symptoms persist or spread rapidly between cane rows.',
          ),
          const SizedBox(height: 14),

          // More Crop Care Tips -> Link
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CropTipsScreen(),
                ),
              );
            },
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'More Crop Care Tips',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF165228),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                    color: Color(0xFF165228),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthCheckBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: Color(0xFF165228),
            size: 17,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF24402B),
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 8. STILL NOT SURE? (INSTANT AI DETECTION) CARD
  // ==========================================
  Widget _buildStillNotSureCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3D20),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instant AI Detection Pill Badge
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
              decoration: BoxDecoration(
                color: const Color(0xFF1B4E2B),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.18),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 13,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Instant AI Detection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Title
          const FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              'Still not sure? (अद्याप खात्री नाही?)',
              style: TextStyle(
                fontSize: 18.5,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Subtitle
          Text(
            'Take a clear photo for AI-assisted sugarcane leaf analysis in seconds.',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.88),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 18),

          // Big White "Scan a Leaf (कॅमेऱ्याने तपासा)" Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ScanCameraScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Color(0xFF14451D),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Scan a Leaf (कॅमेऱ्याने तपासा)',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14451D),
                      ),
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
  // 9. NEED MORE HELP? (ASK AN EXPERT) CARD
  // ==========================================
  Widget _buildNeedMoreHelpCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5EDE7), width: 1.2),
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
          // Header Row with agent icon
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFBBF7D0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: Color(0xFF14451D),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Need more help?',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14451D),
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'अधिक सल्ला हवा आहे?',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF165228),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Description
          const Text(
            'Ask a qualified agricultural expert or Krishi Vigyan Kendra agronomist about your crop symptoms.',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
              color: Color(0xFF475569),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Mint Green Button: Ask an Expert (कृषी तज्ज्ञांना विचारा)
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AskQuestionScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDCFCE7),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: Color(0xFF165228),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Ask an Expert (कृषी तज्ज्ञांना विचारा)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF165228),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Office hours note
          Row(
            children: const [
              Icon(
                Icons.access_time_rounded,
                size: 13.5,
                color: Color(0xFF6B8074),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Support responses typically provided during standard farm office hours.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B8074),
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
  // MODALS & NAVIGATION HELPERS
  // ==========================================
  void _openDiseaseById(BuildContext context, String id) {
    final diseases = DiseaseInfo.getSugarcaneDiseases();
    final match = diseases.firstWhere(
      (d) => d.id == id,
      orElse: () => diseases.first,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DiseaseDetailScreen(disease: match),
      ),
    );
  }

  void _showSymptomDetailModal(
    BuildContext context, {
    required String title,
    required String description,
    required List<String> matchingDiseases,
  }) {
    final allDiseases = DiseaseInfo.getSugarcaneDiseases();
    final matchedList =
        allDiseases.where((d) => matchingDiseases.contains(d.id)).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF14451D),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF5A7265),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Possible Causes & Profiles:',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF14451D),
              ),
            ),
            const SizedBox(height: 10),
            ...matchedList.map(
              (d) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAF5),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: const Color(0xFFE5EDE7), width: 1.0),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      d.imageAsset,
                      width: 42,
                      height: 42,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    d.name,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF14451D),
                    ),
                  ),
                  subtitle: Text(
                    d.marathiName,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF6B8074),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: Color(0xFF165228),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DiseaseDetailScreen(disease: d),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWarningSignsGuideModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Early Sugarcane Diagnostics Guide',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF14451D),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Early identification of leaf symptoms prevents widespread infestation across your ratoon or plant crop.\n\n'
              '1. Daily visual check of whorl and flag leaves.\n'
              '2. Check moisture conditions in lower furrows.\n'
              '3. Take high-resolution photos using CaneCare AI camera scanner for instant diagnostic confirmation.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF5A7265),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF165228),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Close Guide',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
