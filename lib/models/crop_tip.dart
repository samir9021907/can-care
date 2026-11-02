class CropTip {
  final String id;
  final String title;
  final String marathiTitle;
  final String category;
  final String summary;
  final List<String> guidelines;
  final String cautionNote;
  final String iconKey;

  const CropTip({
    required this.id,
    required this.title,
    required this.marathiTitle,
    required this.category,
    required this.summary,
    required this.guidelines,
    required this.cautionNote,
    required this.iconKey,
  });

  static List<CropTip> getTips() {
    return [
      const CropTip(
        id: 'monitoring',
        title: 'Regular Field Monitoring',
        marathiTitle: 'नियमित शेत पाहणी व निरीक्षण',
        category: 'Surveillance',
        summary:
            'Early detection of leaf symptoms prevents widespread infestation across sugarcane blocks.',
        guidelines: [
          'Inspect fields every 7 to 10 days, especially during humid weather and early morning hours.',
          'Examine 20 random clumps in a "W" or "Z" pattern across each acre.',
          'Carefully check the underside of leaves 3 through 6 for aphid colonies or microscopic rust flecks.',
          'Document symptom progression and flag affected clumps with colorful ribbons for follow-up.',
        ],
        cautionNote:
            'Educational guidance: Do not rely solely on peripheral field boundary inspection, as pests frequently establish in the interior canopy.',
        iconKey: 'visibility',
      ),
      const CropTip(
        id: 'irrigation',
        title: 'Irrigation & Drainage Management',
        marathiTitle: 'पाणी व्यवस्थापन व निचरा पद्धत',
        category: 'Water Management',
        summary:
            'Preventing standing water and waterlogging directly curtails destructive Red Rot and root asphyxiation.',
        guidelines: [
          'Install sub-surface or surface drip irrigation to avoid leaf wetness and fungal spore splash.',
          'Construct field drainage channels before monsoon showers to remove excess water within 24 hours.',
          'Avoid severe drought stress during tillering (formative stage), which weakens leaf cell walls against virus transmission.',
        ],
        cautionNote:
            'Educational guidance: High soil moisture combined with poor drainage creates optimal conditions for soil-borne fungal pathogens.',
        iconKey: 'water_drop',
      ),
      const CropTip(
        id: 'clean_seed',
        title: 'Certified Clean Planting Material',
        marathiTitle: 'प्रमाणित निरोगी बेणे वापर',
        category: 'Planting Stock',
        summary:
            'Over 80% of major sugarcane diseases spread through infected vegetative seed setts.',
        guidelines: [
          'Purchase certified disease-free setts or micro-propagated tissue cultured plantlets from authorized research nurseries.',
          'Treat setts with hot water (52°C for 30 minutes) or moist hot air (MHAT at 54°C) to eliminate internal fungal mycelia and viruses.',
          'Discard setts with red internal streaks, cracked nodes, or bud rot before planting.',
        ],
        cautionNote:
            'Standard recommendation: Never source seed cane from ratoon fields showing yellow leaf or mosaic symptoms.',
        iconKey: 'eco',
      ),
      const CropTip(
        id: 'field_sanitation',
        title: 'Field Sanitation & Detrashing',
        marathiTitle: 'शेत स्वच्छता व पाचट व्यवस्थापन',
        category: 'Sanitation',
        summary:
            'Removing dead foliage and rogueing diseased clumps stops disease reservoirs between crop cycles.',
        guidelines: [
          'Perform manual detrashing (removing bottom dry leaves) at 5 and 7 months to improve sunlight penetration and air movement.',
          'Shred dry trash for in-situ mulching instead of burning, while burning only diseased clumps off-field.',
          'Disinfect harvesting knives and sickle blades with 10% bleach solution when moving between blocks.',
        ],
        cautionNote:
            'Educational guidance: Clumps exhibiting smut whips or red rot symptoms must be safely bagged and destroyed away from irrigation channels.',
        iconKey: 'cleaning_services',
      ),
      const CropTip(
        id: 'disease_prevention',
        title: 'Integrated Disease Prevention',
        marathiTitle: 'एकात्मिक रोग प्रतिबंध',
        category: 'Integrated Care',
        summary:
            'A balanced nutrient plan and biological bio-agents safeguard plants against environmental stress.',
        guidelines: [
          'Apply balanced N:P:K based on soil health card recommendations; avoid excessive nitrogen doses.',
          'Incorporate Trichoderma viride and Pseudomonas fluorescens enriched organic manure at furrow opening.',
          'Rotate sugarcane with green manure crops (sunn hemp, dhaincha) or legumes after every second ratoon.',
        ],
        cautionNote:
            'Agricultural advisory: Bio-agents work best as preventive soil conditioners, not rescue treatments for advanced epidemics.',
        iconKey: 'health_and_safety',
      ),
      const CropTip(
        id: 'expert_consultation',
        title: 'Seeking Expert Guidance',
        marathiTitle: 'कृषी तज्ज्ञांचा सल्ला',
        category: 'Expert Network',
        summary:
            'Partner with local agricultural extension universities and KVKs for lab-verified diagnosis.',
        guidelines: [
          'Take fresh leaf samples in clean, aerated polythene bags to the nearest Krishi Vigyan Kendra.',
          'Consult Vasantdada Sugar Institute (VSI), Pune, or regional agricultural universities (MPKV Rahuri / DBSKKV Dapoli).',
          'Do not apply unverified chemical mixtures or unlabeled pesticide doses without official prescription.',
        ],
        cautionNote:
            'Important: AI leaf screening provides advisory indicators. Official chemical prescriptions require registered agronomist verification.',
        iconKey: 'support_agent',
      ),
    ];
  }
}
