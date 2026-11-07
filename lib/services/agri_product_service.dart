import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/recommended_product.dart';

/// User's geographic location information for finding nearest Krishi Kendras
class UserLocationInfo {
  final double latitude;
  final double longitude;
  final String locationName;
  final String shortName;
  final bool isLiveGps;

  const UserLocationInfo({
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.shortName,
    required this.isLiveGps,
  });
}

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

    if (lower.contains('healthy') || lower.contains('निरोगी')) {
      return [
        const RecommendedProduct(
          id: 'prod_trichoderma_healthy',
          diseaseId: 'healthy',
          name: 'Trichoderma viride Bio-Fungicide',
          marathiName: 'ट्रायकोडर्मा व्हिरीडे (Trichoderma)',
          categoryTag: 'PREVENTIVE BIO-CONTROL',
          marathiCategoryTag: 'प्रतिबंधात्मक जैविक बुरशीनाशक',
          packSize: '1 kg Pack',
          verifiedMrp: 185.0,
          purpose:
              'Soil drenching & root zone protection to keep crop vigorous and prevent future infections.',
          purposeMarathi:
              'मुळाजवळ जैविक बुरशीनाशकाची आळवणी करून निरोगी वाढ टिकवून ठेवणे.',
          imageAsset: 'assets/images/product_trichoderma.jpg',
          activeIngredient: 'Trichoderma viride 1.0% WP (Min. 2x10^6 CFU/g)',
          cibrcRegistration: 'CIR-143,291/2021-Trichoderma(WP)-89',
          dosageSugarcane:
              '2.5 to 3.0 kg per acre mixed with 200 kg Farmyard Manure (FYM).',
          dosageSugarcaneMarathi:
              '२.५ ते ३ किलो प्रति एकर २०० किलो चांगल्या कुजलेल्या शेणखतात मिसळून द्यावे.',
          applicationMethod:
              'Root-zone soil application or irrigation drenching during vegetative stage.',
          applicationMethodMarathi:
              'बाळ बांधणीच्या वेळी मुळाजवळ आळवणी किंवा शेणखतातून द्यावे.',
          safetyPrecautions:
              'Store in cool, dark place away from direct sunlight. Do not mix with chemical fungicides.',
          safetyPrecautionsMarathi:
              'थंड व सावलीच्या ठिकाणी ठेवा. रासायनिक बुरशीनाशकासोबत मिसळू नका.',
          categoryColor: Color(0xFF2E7D32),
          onlineOffers: [
            ProductOffer(
              id: 'off_maha_h1',
              sellerName: 'MahaAgri Direct',
              marathiSellerName: 'महाअ‍ॅग्री डायरेक्ट',
              price: 175.0,
              packSize: '1 kg Pack',
              inStock: true,
              stockStatusText: 'In Stock',
              stockStatusTextMarathi: 'उपलब्ध आहे',
              offerUrl: 'https://mahaagri.gov.in',
            ),
          ],
        ),
      ];
    }

    if (lower.contains('red') || lower.contains('rot') || lower.contains('लाल')) {
      return [
        const RecommendedProduct(
          id: 'prod_trichoderma_redrot',
          diseaseId: 'red_rot',
          name: 'Trichoderma viride Bio-Fungicide',
          marathiName: 'ट्रायकोडर्मा व्हिरीडे (Trichoderma)',
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
          marathiName: 'कॉपर ऑक्सीक्लोराईड ५०% WP',
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
          marathiName: 'कार्बेंडाझिम ५०% WP',
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
          marathiName: 'मॅनकोझेब ७५% WP',
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
        marathiName: 'ट्रायकोडर्मा व्हिरीडे (Trichoderma)',
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

  /// Default farmer home coordinates (Bahadurpur village, near Shirdi / Rahata, Dist. Ahilyanagar)
  static const double defaultFarmerLatitude = 19.7420;
  static const double defaultFarmerLongitude = 74.5180;

  /// Comprehensive registry of verified licensed Krishi Seva Kendras in Maharashtra
  static const List<KrishiKendra> allRegisteredKendras = [
    // --- 1. RAHATA, SHIRDI & BAHADURPUR BELT (AHMEDNAGAR / AHILYANAGAR) ---
    KrishiKendra(
      id: 'kendra_rahata_1',
      name: 'Shree Ganesh Krishi Seva Kendra',
      marathiName: 'श्री गणेश कृषी सेवा केंद्र',
      isLicensed: true,
      licenseNumber: 'LIC-MH-AHM-2023-8841',
      address: 'Krishi Utpanna Bazar Samiti, Rahata',
      marathiAddress: 'कृषी उत्पन्न बाजार समिती, राहाता, जि. अहिल्यानगर',
      region: 'Ahmednagar (Ahilyanagar) Sugar Belt',
      distanceKm: 4.2,
      phoneNumber: '+91 98224 51234',
      inStockSummary: 'In Stock: Trichoderma, Copper WP & Mancozeb',
      inStockSummaryMarathi: 'उपलब्ध: ट्रायकोडर्मा, कॉपर WP, मॅन्कोझेब',
      latitude: 19.7139,
      longitude: 74.4925,
      rating: 4.9,
    ),
    KrishiKendra(
      id: 'kendra_shirdi_2',
      name: 'Sai Samarth Agro Agency & Krishi Kendra',
      marathiName: 'साई समर्थ ॲग्रो एजन्सी व कृषी केंद्र',
      isLicensed: true,
      licenseNumber: 'LIC-MH-AHM-2022-4190',
      address: 'Pimpalwadi Road / Shirdi-Manmad Highway, Shirdi',
      marathiAddress: 'पिंपळवाडी रोड / मनमाड हायवे, शिर्डी, जि. अहिल्यानगर',
      region: 'Ahmednagar (Ahilyanagar) Sugar Belt',
      distanceKm: 14.1,
      phoneNumber: '+91 94231 67890',
      inStockSummary: 'In Stock: Carbendazim & Trichoderma Bio-Fungicide',
      inStockSummaryMarathi: 'उपलब्ध: ट्रायकोडर्मा, कार्बेंडाझिम बेणे प्रक्रिया औषधे',
      latitude: 19.7645,
      longitude: 74.4762,
      rating: 4.8,
    ),
    KrishiKendra(
      id: 'kendra_bahadurpur_3',
      name: 'Godavari Shetkari Krishi Seva Kendra',
      marathiName: 'गोदावरी शेतकरी कृषी सेवा केंद्र',
      isLicensed: true,
      licenseNumber: 'LIC-MH-AHM-2024-1102',
      address: 'Sakuri-Rahata Road, Bahadurpur Phata',
      marathiAddress: 'साकुरी-राहाता लिंक रोड, बहादूरपूर फाटा, जि. अहिल्यानगर',
      region: 'Ahmednagar (Ahilyanagar) Sugar Belt',
      distanceKm: 2.1,
      phoneNumber: '+91 98500 11223',
      inStockSummary: 'In Stock: Bio-Fungicides & Cane Micronutrients',
      inStockSummaryMarathi: 'उपलब्ध: ट्रायकोडर्मा, ऊस सूक्ष्म अन्नद्रव्ये व खते',
      latitude: 19.7280,
      longitude: 74.5050,
      rating: 4.8,
    ),
    KrishiKendra(
      id: 'kendra_babhaleshwar_4',
      name: 'Babhaleshwar Krishi Kendra',
      marathiName: 'बाभळेश्वर कृषी केंद्र',
      isLicensed: true,
      licenseNumber: 'LIC-MH-AHM-2021-6678',
      address: 'Main Chowk, Loni-Rahata Road, Babhaleshwar',
      marathiAddress: 'बाभळेश्वर मुख्य चौक, लोणी रोड, जि. अहिल्यानगर',
      region: 'Ahmednagar (Ahilyanagar) Sugar Belt',
      distanceKm: 12.8,
      phoneNumber: '+91 98230 77112',
      inStockSummary: 'In Stock: Copper WP, Trichoderma & Sett Protectants',
      inStockSummaryMarathi: 'उपलब्ध: कॉपर WP, ट्रायकोडर्मा व बेणे प्रक्रिया औषधे',
      latitude: 19.6450,
      longitude: 74.5420,
      rating: 4.7,
    ),

    // --- 2. KOPARGAON & SHRIRAMPUR BELT ---
    KrishiKendra(
      id: 'kendra_kopargaon_5',
      name: 'Kopargaon Sahakari Krishi Seva Kendra',
      marathiName: 'कोपरगाव शेतकरी सहकारी कृषी सेवा केंद्र',
      isLicensed: true,
      licenseNumber: 'LIC-MH-AHM-2023-3391',
      address: 'Main Market Yard, Kopargaon',
      marathiAddress: 'मुख्य मार्केट यार्ड, कोपरगाव, जि. अहिल्यानगर',
      region: 'Ahmednagar (Ahilyanagar) Sugar Belt',
      distanceKm: 18.5,
      phoneNumber: '+91 98220 44556',
      inStockSummary: 'In Stock: Mancozeb 75% WP & Carbendazim 50% WP',
      inStockSummaryMarathi: 'उपलब्ध: मॅन्कोझेब ७५% WP, कार्बेंडाझिम ५०% WP',
      latitude: 19.8870,
      longitude: 74.4828,
      rating: 4.8,
    ),
    KrishiKendra(
      id: 'kendra_shrirampur_6',
      name: 'Shrirampur Shetkari Vikas Kendra',
      marathiName: 'श्रीरामपूर शेतकरी विकास केंद्र',
      isLicensed: true,
      licenseNumber: 'LIC-MH-AHM-2022-7721',
      address: 'Nevasa Road, Shrirampur',
      marathiAddress: 'नेवासा रोड, श्रीरामपूर, जि. अहिल्यानगर',
      region: 'Ahmednagar (Ahilyanagar) Sugar Belt',
      distanceKm: 22.0,
      phoneNumber: '+91 98233 88990',
      inStockSummary: 'In Stock: Bio-Fungicides & Foliar Protectants',
      inStockSummaryMarathi: 'उपलब्ध: ट्रायकोडर्मा, कॉपर ऑक्झिक्लोराईड',
      latitude: 19.6200,
      longitude: 74.6500,
      rating: 4.7,
    ),

    // --- 3. SANGAMNER BELT ---
    KrishiKendra(
      id: 'kendra_sangamner_7',
      name: 'Sangamner Agro Chemicals & Fertilizers',
      marathiName: 'संगमनेर ॲग्रो केमिकल्स व खत विक्री केंद्र',
      isLicensed: true,
      licenseNumber: 'LIC-MH-AHM-2023-9988',
      address: 'Akole Bypass Road, Sangamner',
      marathiAddress: 'अकोले बायपास रोड, संगमनेर, जि. अहिल्यानगर',
      region: 'Ahmednagar (Ahilyanagar) Sugar Belt',
      distanceKm: 38.5,
      phoneNumber: '+91 94222 33445',
      inStockSummary: 'In Stock: Full Sugarcane Protection Range',
      inStockSummaryMarathi: 'उपलब्ध: सर्व शिफारशीत ऊस बुरशीनाशके व खते',
      latitude: 19.5700,
      longitude: 74.2100,
      rating: 4.9,
    ),
    KrishiKendra(
      id: 'kendra_sangamner_8',
      name: 'Amruta Krishi Seva Kendra',
      marathiName: 'अमृता कृषी सेवा केंद्र',
      isLicensed: true,
      licenseNumber: 'LIC-MH-AHM-2021-5509',
      address: 'Near New Bus Stand, Sangamner',
      marathiAddress: 'नवीन बस स्थानक परिसर, संगमनेर, जि. अहिल्यानगर',
      region: 'Ahmednagar (Ahilyanagar) Sugar Belt',
      distanceKm: 39.0,
      phoneNumber: '+91 98600 77889',
      inStockSummary: 'In Stock: Biological Cultures & Sett Dipping',
      inStockSummaryMarathi: 'उपलब्ध: ट्रायकोडर्मा व आंतरप्रवाही बुरशीनाशक',
      latitude: 19.5780,
      longitude: 74.2150,
      rating: 4.7,
    ),

    // --- 4. NASHIK & SINNAR BELT ---
    KrishiKendra(
      id: 'kendra_sinnar_9',
      name: 'Sinnar Agro Services',
      marathiName: 'सिन्नर ॲग्रो सर्व्हिसेस',
      isLicensed: true,
      licenseNumber: 'LIC-MH-NSK-2023-3112',
      address: 'Pune-Nashik Highway, Sinnar',
      marathiAddress: 'पुणे-नाशिक हायवे, सिन्नर, जि. नाशिक',
      region: 'Nashik & Niphad Agro Region',
      distanceKm: 56.2,
      phoneNumber: '+91 98228 99112',
      inStockSummary: 'In Stock: Trichoderma & Copper Oxychloride',
      inStockSummaryMarathi: 'उपलब्ध: ट्रायकोडर्मा व कॉपर बुरशीनाशक',
      latitude: 19.8450,
      longitude: 73.9980,
      rating: 4.8,
    ),
    KrishiKendra(
      id: 'kendra_nashik_10',
      name: 'Nashik Zilla Krishi Udyog Kendra',
      marathiName: 'नाशिक जिल्हा कृषी उद्योग केंद्र',
      isLicensed: true,
      licenseNumber: 'LIC-MH-NSK-2022-8810',
      address: 'Dwarka Circle / Old CBS, Nashik',
      marathiAddress: 'द्वारका सर्कल / सीबीएस, नाशिक',
      region: 'Nashik & Niphad Agro Region',
      distanceKm: 85.1,
      phoneNumber: '+91 98505 66778',
      inStockSummary: 'In Stock: CIBRC Registered Cane Protectants',
      inStockSummaryMarathi: 'उपलब्ध: प्रमाणित सर्व कीटकनाशके व बुरशीनाशके',
      latitude: 19.9975,
      longitude: 73.7898,
      rating: 4.9,
    ),
    KrishiKendra(
      id: 'kendra_nashik_11',
      name: 'Panchavati Krishi Seva Kendra',
      marathiName: 'पंचवटी कृषी सेवा केंद्र',
      isLicensed: true,
      licenseNumber: 'LIC-MH-NSK-2024-4421',
      address: 'Dindori Road, Panchavati, Nashik',
      marathiAddress: 'दिंडोरी रोड, पंचवटी, नाशिक',
      region: 'Nashik & Niphad Agro Region',
      distanceKm: 87.9,
      phoneNumber: '+91 94227 44556',
      inStockSummary: 'In Stock: Bio-Fungicides & Soluble Nutrients',
      inStockSummaryMarathi: 'उपलब्ध: जैविक औषधे व सूक्ष्म अन्नद्रव्ये',
      latitude: 20.0150,
      longitude: 73.7950,
      rating: 4.7,
    ),

    // --- 5. AHMEDNAGAR (AHILYANAGAR) CITY / MIDC ---
    KrishiKendra(
      id: 'kendra_nagar_12',
      name: 'Ahmednagar Zilla Shetkari Kendra',
      marathiName: 'अहमदनगर जिल्हा शेतकरी खरेदी विक्री संघ',
      isLicensed: true,
      licenseNumber: 'LIC-MH-AHM-2021-1200',
      address: 'Main Market Yard, Ahmednagar',
      marathiAddress: 'मुख्य मार्केट यार्ड, अहिल्यानगर',
      region: 'Ahmednagar (Ahilyanagar) Sugar Belt',
      distanceKm: 78.4,
      phoneNumber: '+91 94237 88991',
      inStockSummary: 'In Stock: Certified Agro Inputs & Fungicides',
      inStockSummaryMarathi: 'उपलब्ध: शासकीय प्रमाणित बुरशीनाशके व औषधे',
      latitude: 19.0948,
      longitude: 74.7480,
      rating: 4.8,
    ),

    // --- 6. PUNE & BARAMATI SUGAR BELT ---
    KrishiKendra(
      id: 'kendra_baramati_13',
      name: 'Baramati Krishi Seva Kendra',
      marathiName: 'बारामती कृषी सेवा केंद्र',
      isLicensed: true,
      licenseNumber: 'LIC-MH-PUN-2022-7712',
      address: 'Main Market Yard, Baramati',
      marathiAddress: 'मुख्य मार्केट यार्ड, बारामती',
      region: 'Pune & Baramati Sugar Belt',
      distanceKm: 170.0,
      phoneNumber: '+91 98221 44556',
      inStockSummary: 'In Stock: Trichoderma & Copper WP',
      inStockSummaryMarathi: 'उपलब्ध: ट्रायकोडर्मा व कॉपर WP',
      latitude: 18.1528,
      longitude: 74.5772,
      rating: 4.8,
    ),
    KrishiKendra(
      id: 'kendra_pune_14',
      name: 'Sharada Krishi Bhandar',
      marathiName: 'शारदा कृषी भांडार',
      isLicensed: true,
      licenseNumber: 'LIC-MH-PUN-2023-4109',
      address: 'Station Road, Daund',
      marathiAddress: 'स्टेशन रोड, दौंड',
      region: 'Pune & Baramati Sugar Belt',
      distanceKm: 145.0,
      phoneNumber: '+91 94220 99881',
      inStockSummary: 'In Stock: Carbendazim & Bio-Control',
      inStockSummaryMarathi: 'उपलब्ध: कार्बेंडाझिम व बायो-कंट्रोल',
      latitude: 18.4637,
      longitude: 74.5794,
      rating: 4.7,
    ),

    // --- 7. SATARA & KOLHAPUR REGION ---
    KrishiKendra(
      id: 'kendra_satara_15',
      name: 'Shree Ganesh Krishi Seva Kendra (Satara)',
      marathiName: 'श्री गणेश कृषी सेवा केंद्र (सातारा)',
      isLicensed: true,
      licenseNumber: 'LIC-MH-STR-2023-8841',
      address: 'Market Yard, Satara',
      marathiAddress: 'मार्केट यार्ड, सातारा',
      region: 'Satara & Kolhapur Region, Maharashtra',
      distanceKm: 235.0,
      phoneNumber: '+91 98220 12345',
      inStockSummary: 'In Stock: Trichoderma & Copper WP',
      inStockSummaryMarathi: 'उपलब्ध: ट्रायकोडर्मा आणि कॉपर WP',
      latitude: 17.6805,
      longitude: 74.0183,
      rating: 4.9,
    ),
    KrishiKendra(
      id: 'kendra_kolhapur_16',
      name: 'Kisan Vikas Agro Agency',
      marathiName: 'किसान विकास अ‍ॅग्रो एजन्सी',
      isLicensed: true,
      licenseNumber: 'LIC-MH-KOP-2021-3920',
      address: 'Old MIDC Road, Kolhapur',
      marathiAddress: 'जुना एमआयडीसी रोड, कोल्हापूर',
      region: 'Satara & Kolhapur Region, Maharashtra',
      distanceKm: 340.0,
      phoneNumber: '+91 94230 67890',
      inStockSummary: 'In Stock: Carbendazim & Copper WP',
      inStockSummaryMarathi: 'उपलब्ध: कार्बेंडाझिम आणि कॉपर WP',
      latitude: 16.7050,
      longitude: 74.2433,
      rating: 4.8,
    ),
  ];

  /// Get current user location using live device GPS, falling back to farmer's home in Bahadurpur/Shirdi
  static Future<UserLocationInfo> getCurrentUserLocation({bool forceRefresh = false}) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          Position? position;
          if (!forceRefresh) {
            position = await Geolocator.getLastKnownPosition();
          }
          position ??= await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
              timeLimit: Duration(seconds: 4),
            ),
          );

          if (position != null) {
            final lat = position.latitude;
            final lng = position.longitude;

            // Compute distances to major regional clusters
            final dBahadurpur = Geolocator.distanceBetween(lat, lng, 19.7420, 74.5180) / 1000.0;
            final dShirdi = Geolocator.distanceBetween(lat, lng, 19.7645, 74.4762) / 1000.0;
            final dRahata = Geolocator.distanceBetween(lat, lng, 19.7139, 74.4925) / 1000.0;
            final dKopargaon = Geolocator.distanceBetween(lat, lng, 19.8870, 74.4828) / 1000.0;
            final dShrirampur = Geolocator.distanceBetween(lat, lng, 19.6200, 74.6500) / 1000.0;
            final dSangamner = Geolocator.distanceBetween(lat, lng, 19.5700, 74.2100) / 1000.0;
            final dSinnar = Geolocator.distanceBetween(lat, lng, 19.8450, 73.9980) / 1000.0;
            final dNashik = Geolocator.distanceBetween(lat, lng, 19.9975, 73.7898) / 1000.0;
            final dNagar = Geolocator.distanceBetween(lat, lng, 19.0948, 74.7480) / 1000.0;
            final dPune = Geolocator.distanceBetween(lat, lng, 18.5204, 73.8567) / 1000.0;
            final dSatara = Geolocator.distanceBetween(lat, lng, 17.6805, 74.0183) / 1000.0;

            String name;
            String short;

            if (dBahadurpur <= 18 || dShirdi <= 20 || dRahata <= 18) {
              name = 'बहादूरपूर / राहाता परिसर (शिर्डी जवळ, अहिल्यानगर)';
              short = 'बहादूरपूर / शिर्डी';
            } else if (dKopargaon <= 20) {
              name = 'कोपरगाव परिसर (अहिल्यानगर)';
              short = 'कोपरगाव';
            } else if (dShrirampur <= 20) {
              name = 'श्रीरामपूर परिसर (अहिल्यानगर)';
              short = 'श्रीरामपूर';
            } else if (dSangamner <= 25) {
              name = 'संगमनेर परिसर (अहिल्यानगर)';
              short = 'संगमनेर';
            } else if (dSinnar <= 25) {
              name = 'सिन्नर परिसर (नाशिक जिल्हा)';
              short = 'सिन्नर';
            } else if (dNashik <= 30) {
              name = 'नाशिक शहर व परिसर';
              short = 'नाशिक';
            } else if (dNagar <= 30) {
              name = 'अहमदनगर (अहिल्यानगर) परिसर';
              short = 'अहिल्यानगर';
            } else if (dPune <= 35) {
              name = 'पुणे / बारामती परिसर';
              short = 'पुणे / बारामती';
            } else if (dSatara <= 40) {
              name = 'सातारा / कोल्हापूर परिसर';
              short = 'सातारा';
            } else {
              name = 'थेट GPS स्थान (${lat.toStringAsFixed(2)}, ${lng.toStringAsFixed(2)})';
              short = 'थेट स्थान';
            }

            return UserLocationInfo(
              latitude: lat,
              longitude: lng,
              locationName: name,
              shortName: short,
              isLiveGps: true,
            );
          }
        }
      }
    } catch (_) {}

    // Default Fallback: Farmer's home in Bahadurpur, near Shirdi / Rahata
    return const UserLocationInfo(
      latitude: defaultFarmerLatitude,
      longitude: defaultFarmerLongitude,
      locationName: 'बहादूरपूर / राहाता परिसर (शिर्डी जवळ, अहिल्यानगर)',
      shortName: 'बहादूरपूर (शिर्डी)',
      isLiveGps: false,
    );
  }

  /// Calculate real-world geodesic distances and filter kendras within maximum distance (default 100 km)
  static List<KrishiKendra> getKendrasNearLocation({
    required double latitude,
    required double longitude,
    double maxDistanceKm = 100.0,
  }) {
    final list = allRegisteredKendras.map((k) {
      final meters = Geolocator.distanceBetween(
        latitude,
        longitude,
        k.latitude,
        k.longitude,
      );
      final distKm = double.parse((meters / 1000.0).toStringAsFixed(1));
      return k.copyWith(distanceKm: distKm);
    }).toList();

    // Filter within maxDistanceKm
    var filtered = list.where((k) => k.distanceKm <= maxDistanceKm).toList();

    // If none within radius (e.g. strict radius), fall back to nearest 4
    if (filtered.isEmpty) {
      list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      filtered = list.take(4).toList();
    } else {
      filtered.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }

    return filtered;
  }

  /// Get nearby Krishi Seva Kendras with live geodesic distance (default radius: 100 km)
  static List<KrishiKendra> getNearbyKendras({
    String? region,
    double? latitude,
    double? longitude,
    double maxDistanceKm = 100.0,
  }) {
    final lat = latitude ?? defaultFarmerLatitude;
    final lng = longitude ?? defaultFarmerLongitude;
    return getKendrasNearLocation(
      latitude: lat,
      longitude: lng,
      maxDistanceKm: maxDistanceKm,
    );
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

  /// Launch turn-by-turn directions to Krishi Kendra in Google Maps from current GPS location
  static Future<void> openDirections(
      BuildContext context, KrishiKendra shop) async {
    // Official Google Maps Navigation Intent with destination coordinates
    final Uri dirUri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=${shop.latitude},${shop.longitude}&travelmode=driving');
    final encodedQuery = Uri.encodeComponent('${shop.name}, ${shop.address}');
    final Uri searchUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$encodedQuery');

    try {
      if (await canLaunchUrl(dirUri)) {
        await launchUrl(dirUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(searchUri)) {
        await launchUrl(searchUri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${shop.name}: ${shop.address} (${shop.distanceKm} km away)'),
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
