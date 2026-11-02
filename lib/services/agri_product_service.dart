import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/recommended_product.dart';

class AgriProductService {
  /// Available agricultural farming regions in Maharashtra cane belt
  static const List<String> availableRegions = [
    'Satara & Kolhapur Region, Maharashtra',
    'Pune & Baramati Sugar Belt',
    'Sangli & Miraj Region',
    'Solapur & Pandharpur Valley',
    'Ahmednagar (Ahilyanagar) Sugar Belt',
    'Nashik & Niphad Agro Region',
  ];

  /// Get recommended products for the diagnosed disease
  static List<RecommendedProduct> getProductsForDisease(String diseaseId) {
    final lower = diseaseId.toLowerCase();

    if (lower.contains('red') || lower.contains('rot') || lower.contains('लाल')) {
      return [
        const RecommendedProduct(
          id: 'prod_trichoderma_redrot',
          diseaseId: 'red_rot',
          name: 'Trichoderma viride Bio-Fungicide',
          marathiName: 'ट्रायकोडर्मा व्हिरीडे • 1 kg Pack',
          categoryTag: 'BIO-CONTROL / जैविक बुरशीनाशक',
          marathiCategoryTag: 'जैविक बुरशीनाशक (Bio-Fungicide)',
          packSize: '1 kg Pack',
          verifiedMrp: 185.0,
          purpose:
              'Soil drenching & root zone protection against fungal transmission.',
          purposeMarathi:
              'बुरशीचा प्रादुर्भाव रोखण्यासाठी मुळाजवळ ड्रेंचिंग व माती प्रक्रिया.',
          imageAsset: 'assets/images/product_trichoderma.jpg',
          activeIngredient: 'Trichoderma viride 1.0% WP (Min. 2x10^6 CFU/g)',
          cibrcRegistration: 'CIR-143,291/2021-Trichoderma(WP)-89',
          dosageSugarcane:
              '2.5 to 3.0 kg per acre mixed with 200 kg Farmyard Manure (FYM), or 5g/L water for sett dipping.',
          dosageSugarcaneMarathi:
              '२.५ ते ३ किलो प्रति एकर २०० किलो शेणखतात मिसळून द्यावे, किंवा बेणे प्रक्रियेसाठी ५ ग्रॅम प्रति लिटर पाणी.',
          applicationMethod:
              'Sett dipping before planting and basal root-zone drenching at 30-45 DAP.',
          applicationMethodMarathi:
              'लागवडीपूर्वी बेणे प्रक्रिया आणि लागवडीनंतर ३०-४५ दिवसांनी मुळांजवळ आळवणी.',
          safetyPrecautions:
              'Do not mix with chemical fungicides within 7 days. Store in cool, dark place away from direct sunlight.',
          safetyPrecautionsMarathi:
              'कोणत्याही रासायनिक बुरशीनाशकासोबत मिसळू नका. थंड व सावलीच्या ठिकाणी ठेवा.',
          categoryColor: Color(0xFF2E7D32),
          onlineOffers: [
            ProductOffer(
              id: 'off_maha_1',
              sellerName: 'MahaAgri Direct',
              marathiSellerName: 'महाअ‍ॅग्री डायरेक्ट',
              price: 175.0,
              packSize: '1 kg Pack',
              inStock: true,
              stockStatusText: 'In Stock',
              stockStatusTextMarathi: 'उपलब्ध आहे',
              deliveryEstimate: '2-3 Business Days',
              deliveryEstimateMarathi: '२-३ दिवसांत डिलिव्हरी',
              offerUrl: 'https://mahaagri.gov.in',
            ),
            ProductOffer(
              id: 'off_kisan_1',
              sellerName: 'KisanSeva Mart',
              marathiSellerName: 'किसानसेवा मार्ट',
              price: 185.0,
              packSize: '1 kg Pack',
              inStock: true,
              stockStatusText: 'In Stock',
              stockStatusTextMarathi: 'उपलब्ध आहे',
              deliveryEstimate: 'Next Day Delivery',
              deliveryEstimateMarathi: 'उद्यापर्यंत घरपोच',
              offerUrl: 'https://kisansevamart.in',
            ),
            ProductOffer(
              id: 'off_agrostar_1',
              sellerName: 'AgroStar Kolhapur',
              marathiSellerName: 'अ‍ॅग्रोस्टार कोल्हापूर',
              price: 190.0,
              packSize: '1 kg Pack',
              inStock: true,
              stockStatusText: 'Limited Stock',
              stockStatusTextMarathi: 'मर्यादित साठा',
              deliveryEstimate: '3-4 Days Delivery',
              deliveryEstimateMarathi: '३-४ दिवसांत डिलिव्हरी',
              offerUrl: 'https://agrostar.in',
            ),
          ],
          offlineOffers: [
            ProductOffer(
              id: 'off_local_1',
              sellerName: 'Shree Ganesh Krishi Seva Kendra',
              marathiSellerName: 'श्री गणेश कृषी सेवा केंद्र (सातारा)',
              price: 185.0,
              packSize: '1 kg Pack',
              inStock: true,
              stockStatusText: 'Available Today',
              stockStatusTextMarathi: 'दुकानात उपलब्ध',
              deliveryEstimate: 'Walk-in Pickup',
              deliveryEstimateMarathi: 'थेट दुकानात उपलब्ध',
              isOnline: false,
            ),
            ProductOffer(
              id: 'off_local_2',
              sellerName: 'Kisan Vikas Agro Agency',
              marathiSellerName: 'किसान विकास अ‍ॅग्रो एजन्सी (कोल्हापूर)',
              price: 180.0,
              packSize: '1 kg Pack',
              inStock: true,
              stockStatusText: 'Available Today',
              stockStatusTextMarathi: 'दुकानात उपलब्ध',
              deliveryEstimate: 'Walk-in Pickup',
              deliveryEstimateMarathi: 'थेट दुकानात उपलब्ध',
              isOnline: false,
            ),
          ],
        ),
        const RecommendedProduct(
          id: 'prod_copper_redrot',
          diseaseId: 'red_rot',
          name: 'Copper Oxychloride 50% WP',
          marathiName: 'कॉपर ऑक्सीक्लोराईड • 500 g Pack',
          categoryTag: 'REGISTERED FOLIAR PROTECTANT',
          marathiCategoryTag: 'प्रमाणित पानांवर फवारणी (Foliar Protectant)',
          packSize: '500 g Pack',
          verifiedMrp: 290.0,
          purpose:
              'Broad-spectrum contact protective spray for foliar lesions.',
          purposeMarathi:
              'पानांवरील तांबूस डाग व बुरशीचा प्रसार रोखण्यासाठी स्पर्शजन्य फवारणी.',
          imageAsset: 'assets/images/product_copper.jpg',
          activeIngredient: 'Copper Oxychloride 50% WP w/w',
          cibrcRegistration: 'CIR-88,412/1998-Copper Oxychloride(WP)-114',
          dosageSugarcane:
              '2.5 to 3.0 g per litre of water (500g in 200 Litres per acre) with sticking agent.',
          dosageSugarcaneMarathi:
              '२.५ ते ३.० ग्रॅम प्रति लिटर पाणी (५०० ग्रॅम प्रति एकर २०० लिटर पाण्यात) स्टिकरसह फवारावे.',
          applicationMethod:
              'High-volume foliar spray covering both upper and lower leaf surfaces during early lesion detection.',
          applicationMethodMarathi:
              'पानांच्या वरच्या व खालच्या बाजूने पूर्ण भिजेल अशी फवारणी करावी.',
          safetyPrecautions:
              'Wear protective face mask and gloves. Toxic to aquatic life; avoid spraying near open water ponds.',
          safetyPrecautionsMarathi:
              'फवारणी करताना तोंडाला मास्क व हातमोजे वापरा. पाण्याच्या स्रोताजवळ फवारू नका.',
          categoryColor: Color(0xFFC65102),
          onlineOffers: [
            ProductOffer(
              id: 'off_maha_copper',
              sellerName: 'MahaAgri Direct',
              marathiSellerName: 'महाअ‍ॅग्री डायरेक्ट',
              price: 275.0,
              packSize: '500 g Pack',
              inStock: true,
              stockStatusText: 'In Stock',
              stockStatusTextMarathi: 'उपलब्ध आहे',
              offerUrl: 'https://mahaagri.gov.in',
            ),
            ProductOffer(
              id: 'off_kisan_copper',
              sellerName: 'KisanSeva Mart',
              marathiSellerName: 'किसानसेवा मार्ट',
              price: 285.0,
              packSize: '500 g Pack',
              inStock: true,
              stockStatusText: 'In Stock',
              stockStatusTextMarathi: 'उपलब्ध आहे',
              offerUrl: 'https://kisansevamart.in',
            ),
            ProductOffer(
              id: 'off_agro_copper',
              sellerName: 'AgroStar Kolhapur',
              marathiSellerName: 'अ‍ॅग्रोस्टार कोल्हापूर',
              price: 290.0,
              packSize: '500 g Pack',
              inStock: true,
              stockStatusText: 'In Stock',
              stockStatusTextMarathi: 'उपलब्ध आहे',
              offerUrl: 'https://agrostar.in',
            ),
          ],
          offlineOffers: [
            ProductOffer(
              id: 'off_kendra_copper_1',
              sellerName: 'Shree Ganesh Krishi Seva Kendra',
              marathiSellerName: 'श्री गणेश कृषी सेवा केंद्र (सातारा)',
              price: 285.0,
              packSize: '500 g Pack',
              inStock: true,
              stockStatusText: 'Ready on Counter',
              stockStatusTextMarathi: 'दुकानात शिल्लक',
              isOnline: false,
            ),
            ProductOffer(
              id: 'off_kendra_copper_2',
              sellerName: 'Kisan Vikas Agro Agency',
              marathiSellerName: 'किसान विकास अ‍ॅग्रो एजन्सी',
              price: 280.0,
              packSize: '500 g Pack',
              inStock: true,
              stockStatusText: 'Ready on Counter',
              stockStatusTextMarathi: 'दुकानात शिल्लक',
              isOnline: false,
            ),
          ],
        ),
        const RecommendedProduct(
          id: 'prod_carbendazim_redrot',
          diseaseId: 'red_rot',
          name: 'Carbendazim 50% WP (Sett Dipping)',
          marathiName: 'कार्बेंडाझिम ५०% WP • 250 g Pack',
          categoryTag: 'SYSTEMIC TREATMENT',
          marathiCategoryTag: 'आंतरप्रवाही बुरशीनाशक (Systemic)',
          packSize: '250 g Pack',
          verifiedMrp: 160.0,
          purpose:
              'For preventive sett dipping before next planting cycle.',
          purposeMarathi:
              'पुढील लागवडीसाठी बेण्यातील अंतस्थ बुरशी समूळ नष्ट करण्यासाठी बेणे प्रक्रिया.',
          imageAsset: 'assets/images/product_carbendazim.jpg',
          activeIngredient: 'Carbendazim 50% WP',
          cibrcRegistration: 'CIR-51,209/1995-Carbendazim(WP)-41',
          dosageSugarcane:
              '1.0 g per litre of water for dipping cane setts for 15 minutes before planting.',
          dosageSugarcaneMarathi:
              '१ ग्रॅम प्रति लिटर पाणी या प्रमाणात द्रावण तयार करून उसाचे तुकडे (बेणे) १५ मिनिटे बुडवून ठेवावे.',
          applicationMethod:
              'Strict sett treatment only. Not recommended as continuous soil spray in standing crop.',
          applicationMethodMarathi:
              'केवळ बेणे प्रक्रियेसाठी वापरावे. उभ्या उसात वारंवार रासायनिक वापर टाळावा.',
          safetyPrecautions:
              'Wash treated hands thoroughly. Dispose of dipping water safely away from livestock.',
          safetyPrecautionsMarathi:
              'हात स्वच्छ धुवावेत. जनावरांपासून व खाण्याच्या वस्तूपासून दूर ठेवावे.',
          categoryColor: Color(0xFF00695C),
          onlineOffers: [
            ProductOffer(
              id: 'off_maha_carben',
              sellerName: 'MahaAgri Direct',
              marathiSellerName: 'महाअ‍ॅग्री डायरेक्ट',
              price: 150.0,
              packSize: '250 g Pack',
              inStock: true,
              stockStatusText: 'In Stock',
              stockStatusTextMarathi: 'उपलब्ध आहे',
              offerUrl: 'https://mahaagri.gov.in',
            ),
            ProductOffer(
              id: 'off_kisan_carben',
              sellerName: 'KisanSeva Mart',
              marathiSellerName: 'किसानसेवा मार्ट',
              price: 155.0,
              packSize: '250 g Pack',
              inStock: true,
              stockStatusText: 'In Stock',
              stockStatusTextMarathi: 'उपलब्ध आहे',
              offerUrl: 'https://kisansevamart.in',
            ),
            ProductOffer(
              id: 'off_agro_carben',
              sellerName: 'AgroStar Kolhapur',
              marathiSellerName: 'अ‍ॅग्रोस्टार कोल्हापूर',
              price: 160.0,
              packSize: '250 g Pack',
              inStock: true,
              stockStatusText: 'Limited Stock',
              stockStatusTextMarathi: 'मर्यादित साठा',
              offerUrl: 'https://agrostar.in',
            ),
          ],
          offlineOffers: [
            ProductOffer(
              id: 'off_kendra_carben_1',
              sellerName: 'Shree Ganesh Krishi Seva Kendra',
              marathiSellerName: 'श्री गणेश कृषी सेवा केंद्र (सातारा)',
              price: 155.0,
              packSize: '250 g Pack',
              inStock: true,
              stockStatusText: 'In Stock',
              stockStatusTextMarathi: 'दुकानात उपलब्ध',
              isOnline: false,
            ),
            ProductOffer(
              id: 'off_kendra_carben_2',
              sellerName: 'Kisan Vikas Agro Agency',
              marathiSellerName: 'किसान विकास अ‍ॅग्रो एजन्सी',
              price: 150.0,
              packSize: '250 g Pack',
              inStock: true,
              stockStatusText: 'In Stock',
              stockStatusTextMarathi: 'दुकानात उपलब्ध',
              isOnline: false,
            ),
          ],
        ),
      ];
    } else if (lower.contains('rust') || lower.contains('तांबेरा')) {
      return [
        const RecommendedProduct(
          id: 'prod_mancozeb_rust',
          diseaseId: 'rust',
          name: 'Mancozeb 75% WP Contact Protectant',
          marathiName: 'मॅनकोझेब ७५% WP • 1 kg Pack',
          categoryTag: 'FOLIAR CONTACT FUNGICIDE',
          marathiCategoryTag: 'स्पर्शजन्य बुरशीनाशक',
          packSize: '1 kg Pack',
          verifiedMrp: 260.0,
          purpose: 'Effective prevention against rust pustules and leaf drying.',
          purposeMarathi: 'तांबेऱ्याच्या बुरशीचे ठिपके पसरण्यापासून रोखण्यासाठी फवारणी.',
          imageAsset: 'assets/images/product_copper.jpg',
          activeIngredient: 'Mancozeb 75% WP',
          cibrcRegistration: 'CIR-44,112/1990-Mancozeb-10',
          dosageSugarcane: '2.5g per Litre water (500g/acre) with sticker.',
          dosageSugarcaneMarathi: '२.५ ग्रॅम प्रति लिटर पाणी (५०० ग्रॅम प्रति एकर).',
          applicationMethod: 'Foliar spray on visible rust pustules.',
          applicationMethodMarathi: 'पानांवर तांबेरा दिसताच त्वरित फवारावे.',
          safetyPrecautions: 'Do not spray during high afternoon heat.',
          safetyPrecautionsMarathi: 'दुपारच्या कडक उन्हात फवारू नका.',
          categoryColor: Color(0xFFD84315),
          onlineOffers: [
            ProductOffer(
              id: 'off_rust_1',
              sellerName: 'MahaAgri Direct',
              price: 245.0,
              packSize: '1 kg Pack',
            ),
            ProductOffer(
              id: 'off_rust_2',
              sellerName: 'KisanSeva Mart',
              price: 255.0,
              packSize: '1 kg Pack',
            ),
          ],
        ),
      ];
    }

    // Default return
    return [
      const RecommendedProduct(
        id: 'prod_trichoderma_general',
        diseaseId: 'general',
        name: 'Trichoderma viride Bio-Fungicide',
        marathiName: 'ट्रायकोडर्मा व्हिरीडे • 1 kg Pack',
        categoryTag: 'BIO-CONTROL / जैविक बुरशीनाशक',
        marathiCategoryTag: 'जैविक बुरशीनाशक',
        packSize: '1 kg Pack',
        verifiedMrp: 185.0,
        purpose: 'Soil drenching & root zone protection against fungal transmission.',
        purposeMarathi: 'बुरशीचा प्रादुर्भाव रोखण्यासाठी मुळाजवळ ड्रेंचिंग.',
        imageAsset: 'assets/images/product_trichoderma.jpg',
        activeIngredient: 'Trichoderma viride 1.0% WP',
        dosageSugarcane: '2.5 kg per acre with compost.',
        dosageSugarcaneMarathi: '२.५ किलो प्रति एकर शेणखतात मिसळून द्यावे.',
        applicationMethod: 'Sett treatment and root-zone drenching.',
        applicationMethodMarathi: 'बेणे प्रक्रिया आणि मुळांजवळ आळवणी.',
        safetyPrecautions: 'Keep in cool, dry shade.',
        safetyPrecautionsMarathi: 'थंड व सावलीच्या ठिकाणी ठेवा.',
      ),
    ];
  }

  /// Action Steps for "What should I do next? (पुढे काय करावे?)"
  static List<DiseaseActionStep> getActionSteps(String diseaseId) {
    final lower = diseaseId.toLowerCase();

    if (lower.contains('red') || lower.contains('rot') || lower.contains('लाल')) {
      return const [
        DiseaseActionStep(
          stepNumber: 1,
          title: 'Inspect adjacent cane clumps',
          titleMarathi: 'शेजारील उसाच्या बेटांची बारकाईने पाहणी करा',
          description:
              'Check whether neighboring stalks show leaf spindle yellowing or red internal pith discoloration.',
          descriptionMarathi:
              'शेजारील उसाच्या पानांच्या शिरा पिवळ्या किंवा लाल पडल्या आहेत का ते तपासा.',
        ),
        DiseaseActionStep(
          stepNumber: 2,
          title: 'Practice sanitation & bio-control',
          titleMarathi: 'स्वच्छता व जैविक नियंत्रण पद्धती अवलंबा',
          description:
              'Isolate severely infected clumps and maintain clear field drainage to suppress fungus spore movement.',
          descriptionMarathi:
              'तीव्र बाधित बेटे शेतातून उपटून नष्ट करा व शेतात पाणी साचणार नाही अशी निचऱ्याची सोय करा.',
        ),
        DiseaseActionStep(
          stepNumber: 3,
          title: 'Consult an agronomic expert',
          titleMarathi: 'स्थानिक कृषी शास्त्रज्ञांचा किंवा KVK चा सल्ला घ्या',
          description:
              'If more than 5% of clumps display identical symptoms, visit your local Krishi Vigyan Kendra (KVK).',
          descriptionMarathi:
              'जर शेतात ५% पेक्षा जास्त उसावर लक्षणे आढळली तर तातडीने नजीकच्या कृषी विज्ञान केंद्रात संपर्क साधा.',
        ),
      ];
    } else if (lower.contains('rust') || lower.contains('तांबेरा')) {
      return const [
        DiseaseActionStep(
          stepNumber: 1,
          title: 'Examine underside of leaves',
          titleMarathi: 'पानांच्या मागच्या बाजूची तपासणी करा',
          description:
              'Look for orange-brown powdery pustules that rub off on fingers.',
          descriptionMarathi:
              'पानांच्या खाली तांबूस रंगाची पावडर किंवा बारीक पुटकुळ्या दिसतात का ते पाहा.',
        ),
        DiseaseActionStep(
          stepNumber: 2,
          title: 'Apply prophylactic foliar protectant',
          titleMarathi: 'प्रतिबंधात्मक बुरशीनाशकाची फवारणी करा',
          description:
              'Spray recommended contact fungicide with surfactant in early morning hours.',
          descriptionMarathi:
              'सकाळी लवकर योग्य स्टिकर मिसळून शिफारशीत बुरशीनाशकाची फवारणी करा.',
        ),
        DiseaseActionStep(
          stepNumber: 3,
          title: 'Avoid excess nitrogen fertilization',
          titleMarathi: 'नत्राचा अतिवापर टाळा',
          description:
              'High urea triggers soft tissue growth that accelerates rust infection.',
          descriptionMarathi:
              'जास्त युरियामुळे पाने मऊ पडून तांबेऱ्याचा संसर्ग वेगाने वाढतो, संतुलित खत द्या.',
        ),
      ];
    }

    return const [
      DiseaseActionStep(
        stepNumber: 1,
        title: 'Monitor crop health regularly',
        titleMarathi: 'पिकाची नियमित पाहणी करा',
        description:
            'Inspect sugarcane plots weekly for any pest or foliar color changes.',
        descriptionMarathi:
            'दर आठवड्याला उसाच्या पानांचा रंग व वाढ बारकाईने तपासा.',
      ),
      DiseaseActionStep(
        stepNumber: 2,
        title: 'Ensure balanced fertilization',
        titleMarathi: 'संतुलित खत व्यवस्थापन ठेवा',
        description:
            'Follow soil test recommendations for balanced Nitrogen, Phosphorus & Potash.',
        descriptionMarathi:
            'माती परीक्षणानुसार नत्र, स्फुरद व पालाश खतांची योग्य मात्रा द्या.',
      ),
      DiseaseActionStep(
        stepNumber: 3,
        title: 'Maintain drainage and weed control',
        titleMarathi: 'पाण्याचा निचरा व तण नियंत्रण ठेवा',
        description:
            'Keep furrows weed-free and avoid waterlogging near cane root zones.',
        descriptionMarathi:
            'चर स्वच्छ ठेवा आणि उसाच्या मुळाशी पाणी साचू देऊ नका.',
      ),
    ];
  }

  /// Get nearby Krishi Seva Kendras for a given region
  static List<KrishiKendra> getNearbyKendras({String? region}) {
    final selectedRegion = region ?? availableRegions.first;

    if (selectedRegion.contains('Pune') || selectedRegion.contains('Baramati')) {
      return const [
        KrishiKendra(
          id: 'kendra_baramati_1',
          name: 'Baramati Krishi Seva Kendra',
          marathiName: 'बारामती कृषी सेवा केंद्र',
          isLicensed: true,
          licenseNumber: 'LIC-MH-PUN-2022-7712',
          address: 'Main Market Yard, Baramati',
          marathiAddress: 'मुख्य मार्केट यार्ड, बारामती',
          region: 'Pune & Baramati Sugar Belt',
          distanceKm: 2.1,
          phoneNumber: '+91 98221 44556',
          inStockSummary: 'In Stock: Trichoderma & Copper WP',
          inStockSummaryMarathi: 'उपलब्ध: ट्रायकोडर्मा व कॉपर WP',
          latitude: 18.1528,
          longitude: 74.5772,
          rating: 4.8,
        ),
        KrishiKendra(
          id: 'kendra_pune_2',
          name: 'Sharada Krishi Bhandar',
          marathiName: 'शारदा कृषी भांडार',
          isLicensed: true,
          licenseNumber: 'LIC-MH-PUN-2023-4109',
          address: 'Station Road, Daund',
          marathiAddress: 'स्टेशन रोड, दौंड',
          region: 'Pune & Baramati Sugar Belt',
          distanceKm: 4.6,
          phoneNumber: '+91 94220 99881',
          inStockSummary: 'In Stock: Carbendazim & Bio-Control',
          inStockSummaryMarathi: 'उपलब्ध: कार्बेंडाझिम व बायो-कंट्रोल',
          latitude: 18.4637,
          longitude: 74.5794,
          rating: 4.7,
        ),
      ];
    }

    // Default: Satara & Kolhapur Region (Exactly as shown in Figma Screen 5!)
    return const [
      KrishiKendra(
        id: 'kendra_satara_1',
        name: 'Shree Ganesh Krishi Seva Kendra',
        marathiName: 'श्री गणेश कृषी सेवा केंद्र',
        isLicensed: true,
        licenseNumber: 'LIC-MH-STR-2023-8841',
        address: 'Market Yard, Satara',
        marathiAddress: 'मार्केट यार्ड, सातारा',
        region: 'Satara & Kolhapur Region, Maharashtra',
        distanceKm: 1.8,
        phoneNumber: '+91 98220 12345',
        inStockSummary: 'In Stock: Trichoderma & Copper WP',
        inStockSummaryMarathi: 'उपलब्ध: ट्रायकोडर्मा आणि कॉपर WP',
        latitude: 17.6805,
        longitude: 74.0183,
        rating: 4.9,
      ),
      KrishiKendra(
        id: 'kendra_kolhapur_2',
        name: 'Kisan Vikas Agro Agency',
        marathiName: 'किसान विकास अ‍ॅग्रो एजन्सी',
        isLicensed: true,
        licenseNumber: 'LIC-MH-KOP-2021-3920',
        address: 'Old MIDC Road, Kolhapur',
        marathiAddress: 'जुना एमआयडीसी रोड, कोल्हापूर',
        region: 'Satara & Kolhapur Region, Maharashtra',
        distanceKm: 3.2,
        phoneNumber: '+91 94230 67890',
        inStockSummary: 'In Stock: Carbendazim & Copper WP',
        inStockSummaryMarathi: 'उपलब्ध: कार्बेंडाझिम आणि कॉपर WP',
        latitude: 16.7050,
        longitude: 74.2433,
        rating: 4.8,
      ),
      KrishiKendra(
        id: 'kendra_karad_3',
        name: 'Baliraja Krishi Seva Kendra',
        marathiName: 'बळीराजा कृषी सेवा केंद्र',
        isLicensed: true,
        licenseNumber: 'LIC-MH-STR-2024-5511',
        address: 'Pune-Bangalore Highway, Karad',
        marathiAddress: 'पुणे-बंगलोर हायवे, कराड',
        region: 'Satara & Kolhapur Region, Maharashtra',
        distanceKm: 4.5,
        phoneNumber: '+91 98500 33221',
        inStockSummary: 'In Stock: All Recommended Protectants',
        inStockSummaryMarathi: 'उपलब्ध: सर्व शिफारशीत बुरशीनाशके',
        latitude: 17.2894,
        longitude: 74.1813,
        rating: 4.7,
      ),
    ];
  }

  /// Launch phone call to Krishi Kendra
  static Future<void> callShop(BuildContext context, KrishiKendra shop) async {
    final cleanPhone = shop.phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri callUri = Uri(scheme: 'tel', path: cleanPhone);

    try {
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      } else {
        if (context.mounted) {
          _showContactDialog(context, shop);
        }
      }
    } catch (_) {
      if (context.mounted) {
        _showContactDialog(context, shop);
      }
    }
  }

  /// Launch directions to Krishi Kendra in Google Maps
  static Future<void> openDirections(
      BuildContext context, KrishiKendra shop) async {
    final encodedQuery = Uri.encodeComponent('${shop.name}, ${shop.address}');
    final Uri mapsUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$encodedQuery');

    try {
      if (await canLaunchUrl(mapsUri)) {
        await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening directions to ${shop.name}...'),
              backgroundColor: const Color(0xFF165228),
            ),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${shop.name}: ${shop.address} (${shop.distanceKm} km away)'),
            backgroundColor: const Color(0xFF165228),
          ),
        );
      }
    }
  }

  /// Launch online offer link
  static Future<void> openOfferLink(
      BuildContext context, ProductOffer offer) async {
    if (offer.offerUrl != null && offer.offerUrl!.isNotEmpty) {
      final uri = Uri.parse(offer.offerUrl!);
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return;
        }
      } catch (_) {}
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${offer.sellerName}: ${offer.packSize} available at ₹${offer.price.toInt()} (${offer.stockStatusText})'),
          backgroundColor: const Color(0xFF165228),
        ),
      );
    }
  }

  static void _showContactDialog(BuildContext context, KrishiKendra shop) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.storefront_rounded, color: Color(0xFF165228)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                shop.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF14451D),
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📍 ${shop.address} (${shop.distanceKm} km away)'),
            const SizedBox(height: 8),
            Text('📞 Phone: ${shop.phoneNumber}'),
            const SizedBox(height: 8),
            Text('🕒 Hours: ${shop.operatingHours}'),
            const SizedBox(height: 8),
            Text('📦 ${shop.inStockSummary}',
                style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2E7D32))),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Show online seller options sheet for purchasing product
  static void showOnlineBuySheet(
      BuildContext context, RecommendedProduct product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.shopping_cart_outlined,
                          color: Color(0xFF165228), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF14451D),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'ऑनलाइन विक्रेते निवडा • ${product.packSize}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF5A7262),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                ...product.onlineOffers.map(
                  (offer) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FAF5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFDCE8DC)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                offer.sellerName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF14451D),
                                ),
                              ),
                              Text(
                                '${offer.deliveryEstimate} • ${offer.stockStatusText}',
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
                          '₹${offer.price.toInt()}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF14451D),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            openOfferLink(context, offer);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF165228),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Order',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
