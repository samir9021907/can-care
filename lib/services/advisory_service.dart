import 'package:flutter/material.dart';

class AdvisoryCategory {
  final String id;
  final String titleKey;
  final String fallbackTitle;
  final String subtitleKey;
  final String fallbackSubtitle;
  final IconData icon;
  final List<String> tips;

  const AdvisoryCategory({
    required this.id,
    required this.titleKey,
    required this.fallbackTitle,
    required this.subtitleKey,
    required this.fallbackSubtitle,
    required this.icon,
    required this.tips,
  });
}

class UserQuestion {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime createdAt;
  final String status;
  final String? expertAnswer;

  const UserQuestion({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.createdAt,
    this.status = 'तज्ञांच्या उत्तराची प्रतीक्षा (Pending)',
    this.expertAnswer,
  });
}

class AdvisoryService extends ChangeNotifier {
  static final AdvisoryService _instance = AdvisoryService._internal();
  factory AdvisoryService() => _instance;

  AdvisoryService._internal() {
    _initDefaultQuestions();
  }

  final List<UserQuestion> _myQuestions = [];
  final List<UserQuestion> _allQuestions = [];

  List<UserQuestion> get myQuestions => List.unmodifiable(_myQuestions);
  List<UserQuestion> get allQuestions => List.unmodifiable(_allQuestions);

  void _initDefaultQuestions() {
    _allQuestions.addAll([
      UserQuestion(
        id: 'q1',
        title: 'ऊसाच्या खोडकिडीचा प्रादुर्भाव कसा रोखावा?',
        description: 'रोप लागवडीनंतर पहिल्या ३० दिवसांत खोडकीड आढळत आहे. कोणता सेंद्रिय किंवा रासायनिक उपाय करावा?',
        category: 'ऊस पिकातील रोग',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        status: 'तज्ञांनी उत्तर दिले (Answered)',
        expertAnswer: 'लागवडीच्या वेळी ट्रायकोडर्मा किंवा क्लोरँट्रानिलीप्रोल योग्य प्रमाणात द्यावे. सिंचनाचे प्रमाण योग्य ठेवावे.',
      ),
      UserQuestion(
        id: 'q2',
        title: 'ठिबक सिंचनातून विद्राव्य खते देण्याची योग्य वेळ कोणती?',
        description: 'अडसाली ऊसासाठी युरिया आणि १९:१९:१९ खते कोणत्या टप्प्यावर द्यावीत?',
        category: 'खत व्यवस्थापन',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        status: 'तज्ञांनी उत्तर दिले (Answered)',
        expertAnswer: 'सकाळी ८ ते १० किंवा संध्याकाळी ४ नंतर ठिबकद्वारे विद्राव्य खते द्यावीत जेणेकरून मुळांना त्वरित अन्नद्रव्ये मिळतात.',
      ),
      UserQuestion(
        id: 'q3',
        title: 'उन्हाळ्यात ऊसाला पाण्याचा ताण पडल्यास काय करावे?',
        description: 'पाण्याची उपलब्धता कमी आहे. पाचट आच्छादन कितपत फायदेशीर ठरते?',
        category: 'पाणी व्यवस्थापन',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        status: 'तज्ञांनी उत्तर दिले (Answered)',
        expertAnswer: 'एकरी २ ते ३ टन पाचटाचे आच्छादन केल्याने जमिनीतील ओलावा ४०% अधिक काळ टिकून राहतो.',
      ),
    ]);
  }

  final List<AdvisoryCategory> categories = const [
    AdvisoryCategory(
      id: 'diseases',
      titleKey: 'cat_diseases_title',
      fallbackTitle: 'ऊस पिकातील रोग',
      subtitleKey: 'cat_diseases_sub',
      fallbackSubtitle: 'पानावरील डाग, कुज, किड',
      icon: Icons.shield_outlined,
      tips: [
        'तांबेरा (Rust): पानांवर पिवळसर-तपकिरी फोड आल्यास त्वरित मॅन्कोझेब किंवा ट्रायडेमॉर्फची शिफारशीत फवारणी करावी.',
        'तांबडी कुज (Red Rot): बाधित ऊसाची बेटे मुळासकट उपटून नष्ट करावीत. निरोगी बेणे वापरावे.',
        'काणी रोग (Smut): काणीची काळी चाबूकयुक्त बेटे प्लास्टिक पिशवीत गोळा करून जाळून टाकावीत.',
        'खोडकीड (Early Shoot Borer): ट्रायकोग्रामा मित्रकीटक परोपजीवी कार्ड्स शेतात लावावेत.',
      ],
    ),
    AdvisoryCategory(
      id: 'fertilizer',
      titleKey: 'cat_fertilizer_title',
      fallbackTitle: 'खत व्यवस्थापन',
      subtitleKey: 'cat_fertilizer_sub',
      fallbackSubtitle: 'योग्य खत आणि प्रमाण',
      icon: Icons.spa_outlined,
      tips: [
        'बेसल डोस: लागवडीच्या वेळी नत्र, स्फुरद आणि पालाशची शिफारशीत मात्रा शेणखतासोबत द्यावी.',
        'बांधणी वेळ: मोठ्या बांधणीच्या वेळी नत्राची अंतिम मात्रा देऊन माती लावावी.',
        'सूक्ष्म अन्नद्रव्ये: फेरस सल्फेट आणि झिंक सल्फेटची कमतरता असल्यास पानांवर फवारणी करावी.',
        'सेंद्रिय खते: कंपोस्ट व जीवामृत वापरल्याने जमिनीची सुपीकता दीर्घकाळ टिकते.',
      ],
    ),
    AdvisoryCategory(
      id: 'water',
      titleKey: 'cat_water_title',
      fallbackTitle: 'पाणी व्यवस्थापन',
      subtitleKey: 'cat_water_sub',
      fallbackSubtitle: 'सिंचनाचे योग्य नियोजन',
      icon: Icons.water_drop_outlined,
      tips: [
        'ठिबक सिंचन: पारंपरिक पद्धतीपेक्षा ठिबकमुळे ५०% पाणी बचत आणि ३०% उत्पादन वाढ होते.',
        'उन्हाळी पाळी: उन्हाळ्यात ७ ते ८ दिवसांच्या अंतराने पाणी द्यावे.',
        'पाचट आच्छादन: पिकात पाचटाचे आच्छादन केल्याने बाष्पीभवन थांबून ओलावा टिकतो.',
        'पाण्याचा निचरा: जास्त पावसाच्या काळात शेतात पाणी साचू न देता योग्य निचरा करावा.',
      ],
    ),
    AdvisoryCategory(
      id: 'general',
      titleKey: 'cat_general_title',
      fallbackTitle: 'सामान्य प्रश्न',
      subtitleKey: 'cat_general_sub',
      fallbackSubtitle: 'विविध शेतीविषयक प्रश्न',
      icon: Icons.help_outline_rounded,
      tips: [
        'बेणे प्रक्रिया: लागवडीपूर्वी बेण्यावर कार्बेन्डाझिम आणि मॅलाथिऑनचे द्रावण प्रक्रिया करावी.',
        'आंतरपीक नियोजन: ऊसामध्ये हरभरा, सोयाबीन किंवा कोथिंबीरचे आंतरपीक फायदेशीर ठरते.',
        'ऊस तुटणी नियोजन: योग्य पक्वतेनंतरच (ब्रिक्स २०-२१% झाल्यावर) ऊसतोड करावी.',
      ],
    ),
  ];

  void addQuestion({
    required String title,
    required String description,
    required String category,
  }) {
    final newQ = UserQuestion(
      id: 'usr_q_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      category: category,
      createdAt: DateTime.now(),
      status: 'तज्ञांकडे पाठवले (Under Review)',
    );

    _myQuestions.insert(0, newQ);
    _allQuestions.insert(0, newQ);
    notifyListeners();
  }
}
