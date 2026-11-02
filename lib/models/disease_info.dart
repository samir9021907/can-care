import '../localization/app_localizations.dart';
import 'treatment_guidance.dart';

enum DiseaseSeverity {
  none('None', 'कोणतीही नाही', 'कोई नहीं'),
  low('Low', 'कमी', 'कम'),
  moderate('Moderate', 'मध्यम', 'मध्यम'),
  high('High', 'जास्त', 'अधिक'),
  critical('Critical', 'गंभीर', 'अति गंभीर');

  final String label;
  final String marathiLabel;
  final String hindiLabel;

  const DiseaseSeverity(this.label, this.marathiLabel, this.hindiLabel);

  String getLocalizedLabel(AppLanguage lang) {
    if (lang == AppLanguage.marathi) return marathiLabel;
    if (lang == AppLanguage.hindi) return hindiLabel;
    return label;
  }
}

class DiseaseInfo {
  final String id;
  final String name;
  final String scientificName;
  final String marathiName;
  final String hindiName;
  final String pathogenType; // Fungal, Viral, Phytoplasma, Physiological
  final DiseaseSeverity typicalSeverity;

  final String overview;
  final String overviewMarathi;
  final String overviewHindi;

  final List<String> symptoms;
  final List<String> symptomsMarathi;
  final List<String> symptomsHindi;

  final List<String> causes;
  final List<String> causesMarathi;
  final List<String> causesHindi;

  final TreatmentGuidance treatment;
  final String imageAsset;
  final bool isHealthy;

  const DiseaseInfo({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.marathiName,
    required this.hindiName,
    required this.pathogenType,
    required this.typicalSeverity,
    required this.overview,
    this.overviewMarathi = '',
    this.overviewHindi = '',
    required this.symptoms,
    this.symptomsMarathi = const [],
    this.symptomsHindi = const [],
    required this.causes,
    this.causesMarathi = const [],
    this.causesHindi = const [],
    required this.treatment,
    required this.imageAsset,
    this.isHealthy = false,
  });

  String getLocalizedName(AppLanguage lang) {
    if (lang == AppLanguage.marathi && marathiName.isNotEmpty) return marathiName;
    if (lang == AppLanguage.hindi && hindiName.isNotEmpty) return hindiName;
    return name;
  }

  String getLocalizedOverview(AppLanguage lang) {
    if (lang == AppLanguage.marathi && overviewMarathi.isNotEmpty) return overviewMarathi;
    if (lang == AppLanguage.hindi && overviewHindi.isNotEmpty) return overviewHindi;
    return overview;
  }

  List<String> getLocalizedSymptoms(AppLanguage lang) {
    if (lang == AppLanguage.marathi && symptomsMarathi.isNotEmpty) return symptomsMarathi;
    if (lang == AppLanguage.hindi && symptomsHindi.isNotEmpty) return symptomsHindi;
    return symptoms;
  }

  List<String> getLocalizedCauses(AppLanguage lang) {
    if (lang == AppLanguage.marathi && causesMarathi.isNotEmpty) return causesMarathi;
    if (lang == AppLanguage.hindi && causesHindi.isNotEmpty) return causesHindi;
    return causes;
  }

  String getLocalizedPathogenType(AppLanguage lang) {
    if (isHealthy) {
      return lang == AppLanguage.marathi
          ? 'कोणताही रोग नाही'
          : (lang == AppLanguage.hindi ? 'कोई रोग नहीं' : 'No disease');
    }
    if (pathogenType == 'Fungal') {
      return lang == AppLanguage.marathi
          ? 'बुरशीजन्य रोग'
          : (lang == AppLanguage.hindi ? 'फफूंद जनित रोग' : 'Fungal disease');
    }
    if (pathogenType == 'Viral') {
      return lang == AppLanguage.marathi
          ? 'विषाणूजन्य रोग'
          : (lang == AppLanguage.hindi ? 'विषाणु जनित रोग' : 'Viral disease');
    }
    return '$pathogenType disease';
  }

  static List<DiseaseInfo> getSugarcaneDiseases() {
    return [
      const DiseaseInfo(
        id: 'healthy',
        name: 'Healthy Sugarcane',
        scientificName: 'Saccharum officinarum',
        marathiName: 'निरोगी ऊस',
        hindiName: 'स्वस्थ गन्ना',
        pathogenType: 'None',
        typicalSeverity: DiseaseSeverity.none,
        overview:
            'Leaves are vibrant emerald green, free from spots, discoloration, or lesions. Optimal photosynthesis and stalk development.',
        overviewMarathi:
            'उसाची पाने गडद हिरवीगार, निरोगी आणि कोणत्याही डागांशिवाय आहेत. पिकाची प्रकाशसंश्लेषण क्रिया आणि वाढ उत्तम सुरू आहे.',
        overviewHindi:
            'गन्ने की पत्तियां गहरी हरी, स्वस्थ और किसी भी धब्बे या घाव से मुक्त हैं। फसल का विकास और प्रकाश संश्लेषण उत्तम चल रहा है।',
        symptoms: [
          'Uniform green leaf blade with intact margins',
          'Vigorous leaf whorl and erect upper foliage',
          'Absence of rust pustules, red midrib lesions, or yellowing',
        ],
        symptomsMarathi: [
          'पानांची कडा आणि मध्यशीर एकसारखी हिरवीगार आहे',
          'उसाचा तुरा सरळ आणि जोमदार वाढत आहे',
          'कोणताही तांबेरा, करपा किंवा पिवळेपणा नाही',
        ],
        symptomsHindi: [
          'पत्तियों के किनारे और मध्य शिरा एकसमान हरी हैं',
          'ऊपरी पत्तियां खड़ी और ओजपूर्ण बढ़ रही हैं',
          'किसी प्रकार का रतुआ, सड़न या पीलापन नहीं है',
        ],
        causes: [
          'Balanced N-P-K nutrition',
          'Appropriate drip irrigation',
          'Certified clean seed cane',
        ],
        causesMarathi: [
          'संतुलित खत व्यवस्थापन (N-P-K)',
          'ठिबक सिंचनाचे योग्य नियोजन',
          'प्रमाणित निरोगी बेण्याची लागवड',
        ],
        causesHindi: [
          'संतुलित पोषक तत्व प्रबंधन (N-P-K)',
          'उचित टपक सिंचाई व्यवस्था',
          'प्रमाणित स्वस्थ बीज की बुवाई',
        ],
        treatment: TreatmentGuidance(
          culturalPractices: [
            'Maintain regular crop monitoring every 7-10 days',
            'Avoid excessive nitrogen that causes lush, susceptible foliage',
            'Ensure timely weeding and field drainage during monsoons',
          ],
          culturalPracticesMarathi: [
            'दर ७-१० दिवसांनी शेताची नियमित पाहणी करा',
            'जास्त नत्र (युरिया) खताचा वापर टाळा',
            'पावसाळ्यात शेतात पाणी साचणार नाही याची काळजी घ्या',
          ],
          culturalPracticesHindi: [
            'हर ७-१० दिनों में खेत की नियमित निगरानी करें',
            'अत्यधिक यूरिया (नाइट्रोजन) के उपयोग से बचें',
            'बरसात में खेत में जल निकासी सुनिश्चित करें',
          ],
          organicMeasures: [
            'Apply neem cake at planting (250 kg/ha) to strengthen root resilience',
            'Incorporate well-decomposed Farm Yard Manure (FYM)',
          ],
          organicMeasuresMarathi: [
            'लागवडीच्या वेळी निंबोळी पेंड (२५० किलो/हे.) वापरा',
            'चांगले कुजलेले शेणखत किंवा कंपोस्ट खताचा वापर करा',
          ],
          organicMeasuresHindi: [
            'बुवाई के समय नीम की खली (२५० किग्रा/हेक्टेयर) डालें',
            'अच्छी तरह सड़ा हुआ गोबर का खाद (FYM) मिलाएं',
          ],
          generalPreventiveSteps: [
            'Use virus-free tissue-cultured or heat-treated setts',
            'Practice crop rotation after 2-3 ratoon crops',
          ],
          generalPreventiveStepsMarathi: [
            'उष्ण जल प्रक्रिया केलेले (MHAT) किंवा टिश्यू कल्चर बेणे वापरा',
            '२-३ खोडव्यानंतर योग्य पीक फेरपालट करा',
          ],
          generalPreventiveStepsHindi: [
            'गर्म जल उपचारित या टिश्यू कल्चर बीज का उपयोग करें',
            '२-३ पेड़ी फसलों के बाद फसल चक्र अपनाएं',
          ],
        ),
        imageAsset: 'assets/images/disease_healthy.png',
        isHealthy: true,
      ),
      const DiseaseInfo(
        id: 'red_rot',
        name: 'Red Rot',
        scientificName: 'Colletotrichum falcatum',
        marathiName: 'तांबेरा / लाल कुजव्या (रेड रॉट)',
        hindiName: 'लाल सड़न (रेड रॉट)',
        pathogenType: 'Fungal',
        typicalSeverity: DiseaseSeverity.critical,
        overview:
            'Often called "cancer of sugarcane", Red Rot is one of the most destructive diseases in subtropical and tropical cane belts.',
        overviewMarathi:
            'उसाचा कॅन्सर मानला जाणारा हा अतिशय घातक बुरशीजन्य रोग आहे. या रोगामुळे उसाच्या उत्पादनात व साखरेच्या उतार्‍यात प्रचंड घट होते.',
        overviewHindi:
            'गन्ने का कैंसर कहा जाने वाला यह एक अत्यधिक विनाशकारी फफूंद जनित रोग है। इससे गन्ने की पैदावार और शर्करा की मात्रा में भारी गिरावट आती है।',
        symptoms: [
          'Red discoloration and blotches along the central midrib of leaves',
          'Third or fourth leaf from top shows yellowing, followed by drying',
          'Internal stalk tissue shows red lesions with diagnostic white cross-bands',
          'Alcoholic fermentation smell when cane is split open',
        ],
        symptomsMarathi: [
          'पानांच्या मधल्या पांढऱ्या शिरेवर लाल रंगाचे लांबट डाग व पट्टे पडतात',
          'उसाची तिसरी-चौथी पाने पिवळी पडून वाळू लागतात',
          'ऊस उभा चिरल्यास आतून लाल गाभा आणि पांढरे आडवे पट्टे दिसतात',
          'उसाला आंबट दारूसारखा वास येतो',
        ],
        symptomsHindi: [
          'पत्तियों की मध्य शिरा पर लाल रंग के लंबे धब्बे पड़ते हैं',
          'ऊपर से तीसरी या चौथी पत्ती पीली पड़कर सूखने लगती है',
          'गन्ने को लंबाई में चीरने पर अंदर लाल ऊतक और सफेद आड़े पट्टे दिखाई देते हैं',
          'गन्ने से एल्कोहल जैसी तीखी गंध आती है',
        ],
        causes: [
          'Infected seed cane setts',
          'Standing water and waterlogging during wet seasons',
          'Spread through irrigation furrows from nearby infected fields',
        ],
        causesMarathi: [
          'रोगट बेण्याचा वापर',
          'पावसाळ्यात शेतात पाणी साचून राहणे',
          'रोगट शेतातून पाटाच्या पाण्याद्वारे बुरशीचा प्रसार',
        ],
        causesHindi: [
          'संक्रमित बीज गन्ने का उपयोग',
          'खेत में लंबे समय तक जलभराव',
          'संक्रमित खेत की नालियों से पानी का बहाव',
        ],
        treatment: TreatmentGuidance(
          culturalPractices: [
            'Immediately rogue out and safely burn severely infected clumps to prevent spore drift',
            'Avoid ratooning infected crops',
            'Ensure laser land leveling and avoid furrow stagnation',
          ],
          culturalPracticesMarathi: [
            'बाधित उसाची बेटे मुळासकट उपटून शेताबाहेर नष्ट करा',
            'रोगट शेताचा खोडवा (रटून) ठेवू नका',
            'जमीन सपाटीकरण करून पाण्याचा योग्य निचरा करा',
          ],
          culturalPracticesHindi: [
            'संक्रमित पौधों को तुरंत उखाड़कर खेत से बाहर जला दें',
            'संक्रमित फसल की पेड़ी (खोडवा) बिल्कुल न लें',
            'खेत का समतलीकरण कर जल निकासी की व्यवस्था करें',
          ],
          organicMeasures: [
            'Dip setts in Trichoderma viride biological culture before planting',
            'Soil application of Trichoderma harzianum enriched compost',
          ],
          organicMeasuresMarathi: [
            'लागवडीपूर्वी बेणे ट्रायकोडर्मा व्हिरिडी द्रावणात बुडवून लावा',
            'जमिनीत शेणखतासोबत ट्रायकोडर्मा मिसळून द्या',
          ],
          organicMeasuresHindi: [
            'बुवाई से पहले बीज को ट्राइकोडर्मा विरिडी घोल में उपचारित करें',
            'गोबर की खाद में ट्राइकोडर्मा मिलाकर मिट्टी में डालें',
          ],
          generalPreventiveSteps: [
            'Plant resistant sugarcane cultivars recommended by VSI Pune or ICAR-SBI',
            'Use hot-water treated seed material (52°C for 30 minutes)',
            'Strictly obtain certified disease-free setts from registered nurseries',
          ],
          generalPreventiveStepsMarathi: [
            'वसंतदादा शुगर इन्स्टिट्यूट (VSI) ने शिफारस केलेल्या रोगप्रतिकारक जाती लावा',
            '५२°C तापमानाच्या गरम पाण्यात ३० मिनिटे बेणे प्रक्रिया करा',
            'फक्त अधिकृत नर्सरीतून रोगमुक्त बेणे खरेदी करा',
          ],
          generalPreventiveStepsHindi: [
            'VSI पुणे या ICAR-SBI द्वारा अनुशंसित रोग-रोधी किस्में लगाएं',
            '५२°C गर्म पानी में ३० मिनट तक बीज शोधन करें',
            'पंजीकृत नर्सरी से ही प्रमाणित स्वस्थ बीज प्राप्त करें',
          ],
        ),
        imageAsset: 'assets/images/disease_red_rot.png',
      ),
      const DiseaseInfo(
        id: 'rust',
        name: 'Sugarcane Rust',
        scientificName: 'Puccinia melanocephala',
        marathiName: 'उसावरील तांबेरा (रस्ट)',
        hindiName: 'गन्ने का रतुआ (रस्ट)',
        pathogenType: 'Fungal',
        typicalSeverity: DiseaseSeverity.moderate,
        overview:
            'Common during humid, cool-to-warm transition seasons in Maharashtra. Attacking active photosynthetic leaf area.',
        overviewMarathi:
            'महाराष्ट्रात दमट आणि ढगाळ हवामानात पानांवर हा बुरशीजन्य रोग वेगाने पसरतो. यामुळे पानांचे अन्न तयार करण्याचे काम मंदावते.',
        overviewHindi:
            'महाराष्ट्र और उपोष्णकटिबंधीय क्षेत्रों में आर्द्र मौसम में यह फफूंद जनित रोग तेजी से फैलता है, जिससे प्रकाश संश्लेषण बाधित होता है।',
        symptoms: [
          'Tiny, elongated yellowish flecks on both leaf surfaces',
          'Flecks enlarge into reddish-brown elongated pustules oriented parallel to veins',
          'Ruptured epidermis releasing powdery brown fungal urediniospores',
          'Premature leaf desiccation under heavy infestation',
        ],
        symptomsMarathi: [
          'पानांच्या दोन्ही बाजूंवर लहान पिवळसर लांबट ठिपके दिसतात',
          'ठिपके मोठे होऊन विटकरी किंवा लालसर-तपकिरी रंगाचे पुटकुळ्यांसारखे दिसतात',
          'पुटकुळ्या फुटून त्यातून तपकिरी बुरशीची भुकटी बाहेर पडते',
          'जास्त प्रादुर्भाव झाल्यास पाने अकाली सुकतात',
        ],
        symptomsHindi: [
          'पत्तियों के दोनों तरफ छोटे, लंबे पीले धब्बे दिखाई देते हैं',
          'धब्बे बढ़कर लाल-भूरे रंग के दानों (पुस्तिकाओं) में बदल जाते हैं',
          'दाने फटने पर भूरा फफूंदीय चूर्ण बाहर निकलता है',
          'गंभीर स्थिति में पत्तियां समय से पहले सूख जाती हैं',
        ],
        causes: [
          'High relative humidity (>80%) and moderate temperatures (20-28°C)',
          'Windborne spore dissemination across adjoining fields',
          'High plant density and restricted air movement',
        ],
        causesMarathi: [
          'हवेतील ८०% पेक्षा जास्त आर्द्रता आणि २०-२८°C तापमान',
          'वाऱ्यामुळे एका शेतातून दुसऱ्या शेतात बीजाणूंचा प्रसार',
          'उसाची दाट लागवड व खेळती हवा नसणे',
        ],
        causesHindi: [
          '८०% से अधिक आर्द्रता और २०-२८°C तापमान',
          'हवा द्वारा बीजाणुओं का पड़ोसी खेतों में प्रसार',
          'अधिक सघन बुवाई और हवा के संचलन में कमी',
        ],
        treatment: TreatmentGuidance(
          culturalPractices: [
            'Maintain wider row spacing (4 to 5 feet) for adequate canopy aeration',
            'Avoid excessive overhead or sprinkler irrigation during humid weather',
            'Remove dry lower senescent leaves (detrashing) after 4-5 months',
          ],
          culturalPracticesMarathi: [
            'हवा खेळती राहण्यासाठी उसाच्या पट्ट्यात ४ ते ५ फूट अंतर ठेवा',
            'दमट हवामानात तुषार सिंचन टाळा',
            '४-५ महिन्यांनी उसाची खालची सुकलेली पाने (पाचट) काढून टाका',
          ],
          culturalPracticesHindi: [
            'हवा के उचित संचलन हेतु पंक्तियों में ४ से ५ फीट की दूरी रखें',
            'आर्द्र मौसम में फव्वारा सिंचाई से बचें',
            '४-५ महीने बाद नीचे की सूखी पत्तियों की छिलाई (डिट्रैशिंग) करें',
          ],
          organicMeasures: [
            'Foliar spray of 5% neem seed kernel extract (NSKE)',
            'Application of biocontrol agents like Bacillus subtilis',
          ],
          organicMeasuresMarathi: [
            '५% निंबोळी अर्काची (NSKE) पानांवर फवारणी करा',
            'बॅसिलस सबटिलिससारख्या जैविक घटकांचा वापर करा',
          ],
          organicMeasuresHindi: [
            '५% नीम बीज गिरी अर्क (NSKE) का पत्तियों पर छिड़काव करें',
            'बैसिलस सबटिलिस जैसे जैविक घटकों का उपयोग करें',
          ],
          generalPreventiveSteps: [
            'Plant rust-tolerant varieties suited for Western Maharashtra',
            'Monitor fields closely following early winter morning dews',
          ],
          generalPreventiveStepsMarathi: [
            'पश्चिम महाराष्ट्रासाठी योग्य तांबेरा-प्रतिकारक वाण निवडा',
            'थंडीच्या दिवसात दवाचे प्रमाण वाढल्यास शेताची नियमित पाहणी करा',
          ],
          generalPreventiveStepsHindi: [
            'क्षेत्र के अनुकूल रतुआ-रोधी किस्मों की बुवाई करें',
            'सर्दियों की सुबह ओस पड़ने पर खेतों का निरंतर निरीक्षण करें',
          ],
        ),
        imageAsset: 'assets/images/disease_rust.png',
      ),
      const DiseaseInfo(
        id: 'yellow_leaf',
        name: 'Yellow Leaf Disease (YLD)',
        scientificName: 'Sugarcane yellow leaf virus (SCYLV)',
        marathiName: 'पिवळा पान रोग (YLD)',
        hindiName: 'पीली पत्ती रोग (YLD)',
        pathogenType: 'Viral',
        typicalSeverity: DiseaseSeverity.high,
        overview:
            'A systemic viral infection prevalent in ratoon crops, causing drastic reduction in juice quality and cane tonnage.',
        overviewMarathi:
            'खोडवा पिकात जास्त प्रमाणात आढळणारा हा विषाणूजन्य रोग आहे. यामुळे उसाची जाडी, वजन आणि साखरेच्या उतार्‍यात मोठी घट होते.',
        overviewHindi:
            'पेड़ी (खोडवा) फसल में तेजी से फैलने वाला यह विषाणु जनित रोग है, जिससे गन्ने की मोटाई, वजन और रस की गुणवत्ता में भारी कमी आती है।',
        symptoms: [
          'Intense bright yellowing of the lower side midrib of leaves 3 to 6',
          'Yellowing spreads out laterally from midrib into the leaf lamina',
          'Midrib on upper side may turn pinkish or reddish in advanced stages',
          'Stunted terminal internodes causing bunchy top appearance',
        ],
        symptomsMarathi: [
          'मधल्या पानांच्या पाठीमागील मध्यशिरेवर ठळक पिवळेपणा येतो',
          'पिवळेपणा शिरेतून संपूर्ण पानाच्या भागावर पसरतो',
          'रोग बळावल्यावर पाठीमागील शिर फिकट गुलाबी किंवा तांबूस बनते',
          'उसाचे वरचे कांडे बारीक होऊन झाडाची वाढ खुंटते',
        ],
        symptomsHindi: [
          'तीसरी से छठी पत्ती की मध्य शिरा का निचला हिस्सा गहरा पीला पड़ जाता है',
          'पीलापन धीरे-धीरे पूरी पत्ती में फैल जाता है',
          'गंभीर अवस्था में मध्य शिरा गुलाबी या लाल होने लगती है',
          'ऊपरी पोरियां छोटी होकर गन्ने की बढ़वार रुक जाती है',
        ],
        causes: [
          'Transmitted efficiently by the sugarcane aphid (Melanaphis sacchari)',
          'Propagation using symptomless infected vegetative cuttings',
        ],
        causesMarathi: [
          'उसावरील मावा किडीद्वारे (एफिड्स) विषाणूचा वेगाने प्रसार होतो',
          'लक्षणे नसलेल्या रोगट बेण्याचा लागवडीसाठी वापर',
        ],
        causesHindi: [
          'माहू (एफिड) कीट द्वारा गन्ने में विषाणु का संचरण',
          'संक्रमित गन्ने के टुकड़ों का बुवाई में उपयोग',
        ],
        treatment: TreatmentGuidance(
          culturalPractices: [
            'Manage aphid vector populations using sticky traps and timely inspections',
            'Avoid moisture stress during formative stage, as drought exacerbates YLD symptoms',
            'Promptly rogue out stunted stools in young fields',
          ],
          culturalPracticesMarathi: [
            'पिवळे चिकट सापळे लावून मावा किडीवर नियंत्रण ठेवा',
            'उसाला पाण्याचा ताण पडू देऊ नका, दुष्काळात हा रोग वाढतो',
            'लहान वयातील शेतातील रोगट उसाची बेटे वेळीच काढून टाका',
          ],
          culturalPracticesHindi: [
            'पीले चिपचिपे ट्रैप लगाकर माहू कीट की संख्या नियंत्रित करें',
            'शुरुआती अवस्था में फसल को पानी का तनाव न दें',
            'खेत से बौने और संक्रमित पौधों को तुरंत निकालें',
          ],
          organicMeasures: [
            'Spray neem-based formulations (Azadirachtin 10,000 ppm) to deter vector feeding',
            'Conserve predatory coccinellid ladybird beetles and chrysoperla in the field',
          ],
          organicMeasuresMarathi: [
            'मावा नियंत्रणासाठी निंबोळी तेल (अझाडिरॅक्टिन १०,००० ppm) फवारा',
            'शेतातील मित्रकीटक (लेडीबर्ड बीटल) यांचे संवर्धन करा',
          ],
          organicMeasuresHindi: [
            'नीम तेल फॉर्मूलेशन (१०,००० ppm) का छिड़काव करें',
            'मित्र कीटों जैसे लेडीबर्ड बीटल और क्राइसोपरला का संरक्षण करें',
          ],
          generalPreventiveSteps: [
            'Strictly adopt micro-propagated tissue culture (Meristem tip culture) plantlets',
            'Limit number of ratoon cycles in fields where incidence surpasses 15%',
          ],
          generalPreventiveStepsMarathi: [
            'केवळ मेरिस्टेम टिश्यू कल्चर पद्धतीने तयार केलेली निरोगी रोपे लावा',
            '१५% पेक्षा जास्त प्रादुर्भाव असल्यास त्या शेतात खोडवा ठेवू नका',
          ],
          generalPreventiveStepsHindi: [
            'केवल स्वस्थ टिश्यू कल्चर पौधों का ही रोपण करें',
            '१५% से अधिक संक्रमण होने पर अगली पेड़ी फसल न लें',
          ],
        ),
        imageAsset: 'assets/images/disease_yellow_leaf.png',
      ),
      const DiseaseInfo(
        id: 'mosaic',
        name: 'Sugarcane Mosaic',
        scientificName: 'Sugarcane mosaic virus (SCMV)',
        marathiName: 'केवडा / मोझॅक रोग',
        hindiName: 'मोज़ेक रोग',
        pathogenType: 'Viral',
        typicalSeverity: DiseaseSeverity.moderate,
        overview:
            'Characterized by contrasting islands of dark green and pale yellowish-green patches along the veins of younger expanding leaves.',
        overviewMarathi:
            'या विषाणूजन्य रोगामुळे उसाच्या नवीन कोवळ्या पानांवर फिकट पिवळे आणि गडद हिरवे चट्टे दिसतात.',
        overviewHindi:
            'इस विषाणु रोग में नई पत्तियों पर गहरे हरे और हल्के पीले रंग के धब्बों की पच्चीकारी (मोज़ेक) दिखाई देती है।',
        symptoms: [
          'Pattern of broken, elongated chlorotic islands surrounded by normal green leaf tissue',
          'Most distinct on young basal parts of rapidly growing leaves',
          'Mottled appearance without necrosis in early stages',
        ],
        symptomsMarathi: [
          'पानांच्या शिरांच्या बाजूने फिकट पिवळसर व हिरव्या रंगाचे पट्टे तयार होतात',
          'उसाच्या शेंड्याकडील वेगाने वाढणाऱ्या कोवळ्या पानांवर लक्षणे स्पष्ट दिसतात',
          'सुरुवातीला पान न वाळता फक्त त्यावर रंगीबेरंगी चट्टे दिसतात',
        ],
        symptomsHindi: [
          'पत्तियों पर गहरे हरे ऊतकों के बीच हल्के पीले रंग के चकत्ते बनते हैं',
          'शीर्ष की नई और तेजी से बढ़ने वाली पत्तियों पर लक्षण सबसे स्पष्ट होते हैं',
          'शुरुआती दौर में पत्ती सूखती नहीं बल्कि चितकबरी दिखती है',
        ],
        causes: [
          'Aphid vectors (Rhopalosiphum maidis and others)',
          'Mechanical transmission through cutting knives during sett preparation',
        ],
        causesMarathi: [
          'मावा (एफिड्स) किडीमुळे एका झाडावरून दुसऱ्या झाडावर प्रसार',
          'बेणे तोडण्याच्या कोयत्याद्वारे रस पसरून प्रसार',
        ],
        causesHindi: [
          'एफिड (माहू) कीटों द्वारा फैलाव',
          'बीज काटते समय हंसिये या चाकू के माध्यम से प्रसार',
        ],
        treatment: TreatmentGuidance(
          culturalPractices: [
            'Disinfect harvesting and cutting knives with 10% trisodium phosphate or bleach',
            'Remove alternate grass hosts and weeds from field bunds',
          ],
          culturalPracticesMarathi: [
            'बेणे कापण्याचे हत्यार १०% ट्रायसोडियम फॉस्फेट किंवा गरम पाण्यात निर्जंतुक करा',
            'बांधावरील गवत व तण नष्ट करा',
          ],
          culturalPracticesHindi: [
            'बीज काटने वाले औजारों को १०% ट्राइसोडियम फॉस्फेट से रोगाणुरहित करें',
            'खेत की मेड़ों से जंगली घास और खरपतवार नष्ट करें',
          ],
          organicMeasures: [
            'Application of fermented cow urine spray as repellent against vectors',
          ],
          organicMeasuresMarathi: [
            'किडींचा उपद्रव रोखण्यासाठी गोमूत्र व निंबोळी अर्काची फवारणी करा',
          ],
          organicMeasuresHindi: [
            'कीटों को दूर रखने हेतु गोमूत्र व नीम अर्क का छिड़काव करें',
          ],
          generalPreventiveSteps: [
            'Plant mosaic-free seed nursery stock',
            'Avoid planting sugarcane adjacent to maize or sorghum fields that harbor vectors',
          ],
          generalPreventiveStepsMarathi: [
            'रोगमुक्त बेणे मळ्यातूनच शुद्ध बेणे घ्या',
            'मका किंवा ज्वारीच्या शेताजवळ उसाची लागवड करणे टाळा',
          ],
          generalPreventiveStepsHindi: [
            'रोगमुक्त नर्सरी से ही बीज प्राप्त करें',
            'मक्का या ज्वार के खेतों के पास गन्ना लगाने से बचें',
          ],
        ),
        imageAsset: 'assets/images/disease_mosaic.png',
      ),
      const DiseaseInfo(
        id: 'smut',
        name: 'Sugarcane Smut',
        scientificName: 'Sporisorium scitamineum',
        marathiName: 'काणी रोग (स्मट / चाबूक रोग)',
        hindiName: 'कंडुआ रोग (स्मट)',
        pathogenType: 'Fungal',
        typicalSeverity: DiseaseSeverity.high,
        overview:
            'Widely recognized by the diagnostic whip-like black sorus structure replacing the central leaf spindle.',
        overviewMarathi:
            'उसाच्या शेंड्यातून चाबुकासारखा काळा लांबट भाग बाहेर पडणे हे या बुरशीजन्य रोगाचे मुख्य वैशिष्ट्य आहे.',
        overviewHindi:
            'गन्ने के तने के ऊपरी हिस्से से चाबुक जैसी लंबी काली संरचना निकलना इस फफूंद रोग की मुख्य पहचान है।',
        symptoms: [
          'Emergence of a long, curved, pencil-thin black whip structure from the shoot apex',
          'Whip initially covered with thin silvery membrane which flakes off to release millions of sooty spores',
          'Production of excessive thin, grass-like tillers (witches broom symptom)',
        ],
        symptomsMarathi: [
          'उसाच्या वाढणाऱ्या शेंड्यातून काळ्या रंगाचा चाबुकासारखा वळणदार दांडा बाहेर येतो',
          'सुरुवातीला यावर पातळ चंदेरी पापुद्रा असतो, जो फुटून काळी भुकटी पसरते',
          'उसाला असंख्य बारीक गवतासारखे फुटवे फुटतात (चुडबुड फुटणे)',
        ],
        symptomsHindi: [
          'तने के शीर्ष से चाबुक जैसी घुमावदार काली संरचना निकलती है',
          'शुरुआत में यह पतली चांदी जैसी झिल्ली से ढकी होती है, जिसके फटने पर काला चूर्ण बिखरता है',
          'गन्ने में अत्यधिक पतले, घास जैसे कल्ले निकलने लगते हैं',
        ],
        causes: [
          'Airborne spores entering buds and eyes',
          'Infected seed cane setts',
          'High temperatures and arid windy spells',
        ],
        causesMarathi: [
          'हवेतून उडणारे काळे बीजाणू डोळ्यांवर बसणे',
          'रोगट उसाचे बेणे वापरणे',
          'उष्ण आणि कोरडे वादळी हवामान',
        ],
        causesHindi: [
          'हवा से उड़ने वाले बीजाणु गन्ने की आंखों में प्रवेश करना',
          'संक्रमित बीज गन्ने का उपयोग',
          'उच्च तापमान और शुष्क हवाएं',
        ],
        treatment: TreatmentGuidance(
          culturalPractices: [
            'Carefully cover developing whips with a polythene bag before cutting to prevent spore dispersion, then burn off-field',
            'Do not take ratoon from smut-infected plant cane fields',
          ],
          culturalPracticesMarathi: [
            'काळा चाबूक दिसताच त्यावर प्लास्टिक पिशवी अडकवून हळूच कापून शेताबाहेर जाळून टाका',
            'काणीग्रस्त शेताचा खोडवा (रटून) मुळीच घेऊ नका',
          ],
          culturalPracticesHindi: [
            'काले चाबुक को प्लास्टिक की थैली से ढककर सावधानी से काटें और खेत से दूर जलाएं',
            'संक्रमित फसल से पेड़ी (खोडवा) कतई न लें',
          ],
          organicMeasures: [
            'Soak setts in cow dung slurry mixed with bio-fungicide before sowing',
          ],
          organicMeasuresMarathi: [
            'लागवडीपूर्वी बेणे शेणखताची स्लरी आणि ट्रायकोडर्मामध्ये बुडवून लावा',
          ],
          organicMeasuresHindi: [
            'बुवाई से पहले बीज को गोबर की स्लरी और जैव-फफूंदनाशी में भिगोकर लगाएं',
          ],
          generalPreventiveSteps: [
            'Moist hot-air treatment (MHAT) of setts at 54°C for 2.5 hours',
            'Cultivate smut-resistant varieties recommended for tropical conditions',
          ],
          generalPreventiveStepsMarathi: [
            '५४°C तापमानाच्या दमट हवेत २.५ तास बेणे प्रक्रिया करा (MHAT)',
            'काणी-प्रतिकारक उसाच्या जातींची लागवड करा',
          ],
          generalPreventiveStepsHindi: [
            '५४°C पर २.५ घंटे नम गर्म हवा (MHAT) बीज उपचार करें',
            'कंडुआ-रोधी किस्मों की ही बुवाई करें',
          ],
        ),
        imageAsset: 'assets/images/disease_smut.png',
      ),
    ];
  }
}
