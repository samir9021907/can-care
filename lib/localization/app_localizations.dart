import 'package:flutter/material.dart';

enum AppLanguage {
  english('en', 'English', 'English'),
  marathi('mr', 'मराठी', 'Marathi'),
  hindi('hi', 'हिंदी', 'Hindi');

  final String code;
  final String nativeName;
  final String englishName;

  const AppLanguage(this.code, this.nativeName, this.englishName);
}

class AppLocalizations {
  final AppLanguage language;

  AppLocalizations(this.language);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(AppLanguage.english);
  }

  static const Map<String, Map<AppLanguage, String>> _localizedValues = {
    // App Branding
    'app_name': {
      AppLanguage.english: 'CaneCare AI',
      AppLanguage.marathi: 'केनकेअर एआय',
      AppLanguage.hindi: 'केनकेयर एआई',
    },
    'tagline': {
      AppLanguage.english: 'Healthy leaves, better harvest.',
      AppLanguage.marathi: 'निरोगी पाने, उत्तम उत्पादन.',
      AppLanguage.hindi: 'स्वस्थ पत्तियां, बेहतर पैदावार।',
    },
    'subtitle': {
      AppLanguage.english: 'Smart crop care for every farmer.',
      AppLanguage.marathi: 'प्रत्येक शेतकऱ्यासाठी स्मार्ट पीक काळजी.',
      AppLanguage.hindi: 'हर किसान के लिए स्मार्ट फसल देखभाल।',
    },
    'get_started': {
      AppLanguage.english: 'Get Started',
      AppLanguage.marathi: 'सुरुवात करा',
      AppLanguage.hindi: 'शुरू करें',
    },
    'select_language': {
      AppLanguage.english: 'Select Language',
      AppLanguage.marathi: 'भाषा निवडा',
      AppLanguage.hindi: 'भाषा चुनें',
    },
    'continue': {
      AppLanguage.english: 'Continue',
      AppLanguage.marathi: 'पुढे जा',
      AppLanguage.hindi: 'आगे बढ़ें',
    },
    'skip': {
      AppLanguage.english: 'Skip',
      AppLanguage.marathi: 'वगळा',
      AppLanguage.hindi: 'छोड़ें',
    },

    // Navigation
    'nav_home': {
      AppLanguage.english: 'Home',
      AppLanguage.marathi: 'मुख्यपृष्ठ',
      AppLanguage.hindi: 'होम',
    },
    'nav_scan': {
      AppLanguage.english: 'Scan',
      AppLanguage.marathi: 'स्कॅन',
      AppLanguage.hindi: 'स्कैन',
    },
    'nav_history': {
      AppLanguage.english: 'History',
      AppLanguage.marathi: 'इतिहास',
      AppLanguage.hindi: 'इतिहास',
    },
    'nav_diseases': {
      AppLanguage.english: 'Diseases',
      AppLanguage.marathi: 'रोग माहिती',
      AppLanguage.hindi: 'रोग लाइब्रेरी',
    },
    'nav_profile': {
      AppLanguage.english: 'Profile',
      AppLanguage.marathi: 'प्रोफाइल',
      AppLanguage.hindi: 'प्रोफाइल',
    },

    // Dashboard
    'greeting_farmer': {
      AppLanguage.english: 'Namaste, Farmer!',
      AppLanguage.marathi: 'नमस्ते, शेतकरी मित्र!',
      AppLanguage.hindi: 'नमस्ते, किसान भाई!',
    },
    'home_hero_title': {
      AppLanguage.english: 'Is your sugarcane healthy?',
      AppLanguage.marathi: 'तुमचा ऊस निरोगी आहे का?',
      AppLanguage.hindi: 'क्या आपका गन्ना स्वस्थ है?',
    },
    'home_hero_subtitle': {
      AppLanguage.english: 'Take a clear photo. Get an answer in seconds.',
      AppLanguage.marathi: 'स्पष्ट फोटो काढा. काही सेकंदात निकाल मिळवा.',
      AppLanguage.hindi: 'साफ फोटो लें। कुछ ही सेकंड में परिणाम पाएं।',
    },
    'scan_leaf_button': {
      AppLanguage.english: 'Scan Leaf',
      AppLanguage.marathi: 'पानाचे स्कॅन करा',
      AppLanguage.hindi: 'पत्ती स्कैन करें',
    },
    'upload_gallery_button': {
      AppLanguage.english: 'Upload from Gallery',
      AppLanguage.marathi: 'गॅलरीतून निवडा',
      AppLanguage.hindi: 'गैलरी से अपलोड करें',
    },
    'recent_scans': {
      AppLanguage.english: 'Recent Scans',
      AppLanguage.marathi: 'अलीकडील स्कॅन',
      AppLanguage.hindi: 'हाल के स्कैन',
    },
    'view_all': {
      AppLanguage.english: 'View All',
      AppLanguage.marathi: 'सर्व पहा',
      AppLanguage.hindi: 'सभी देखें',
    },
    'common_diseases': {
      AppLanguage.english: 'Common Sugarcane Diseases',
      AppLanguage.marathi: 'उसाचे मुख्य रोग',
      AppLanguage.hindi: 'गन्ने के प्रमुख रोग',
    },
    'healthy_tips': {
      AppLanguage.english: 'Healthy Crop Tips',
      AppLanguage.marathi: 'पीक संवर्धन टिप्स',
      AppLanguage.hindi: 'फसल सुरक्षा सुझाव',
    },
    'quick_help': {
      AppLanguage.english: 'Quick Help & Support',
      AppLanguage.marathi: 'त्वरित मदत आणि सहाय्य',
      AppLanguage.hindi: 'त्वरित सहायता और सपोर्ट',
    },

    // Authentication
    'sign_in': {
      AppLanguage.english: 'Sign In',
      AppLanguage.marathi: 'साइन इन',
      AppLanguage.hindi: 'साइन इन',
    },
    'create_account': {
      AppLanguage.english: 'Create Account',
      AppLanguage.marathi: 'खाते तयार करा',
      AppLanguage.hindi: 'खाता बनाएं',
    },
    'full_name': {
      AppLanguage.english: 'Full Name',
      AppLanguage.marathi: 'पूर्ण नाव',
      AppLanguage.hindi: 'पूरा नाम',
    },
    'email_address': {
      AppLanguage.english: 'Email Address',
      AppLanguage.marathi: 'ईमेल पत्ता',
      AppLanguage.hindi: 'ईमेल पता',
    },
    'password': {
      AppLanguage.english: 'Password',
      AppLanguage.marathi: 'पासवर्ड',
      AppLanguage.hindi: 'पासवर्ड',
    },
    'confirm_password': {
      AppLanguage.english: 'Confirm Password',
      AppLanguage.marathi: 'पासवर्ड पुष्टी करा',
      AppLanguage.hindi: 'पासवर्ड की पुष्टि करें',
    },
    'forgot_password': {
      AppLanguage.english: 'Forgot Password?',
      AppLanguage.marathi: 'पासवर्ड विसरलात?',
      AppLanguage.hindi: 'पासवर्ड भूल गए?',
    },
    'continue_google': {
      AppLanguage.english: 'Continue with Google',
      AppLanguage.marathi: 'गुगलने पुढे जा (डेमो)',
      AppLanguage.hindi: 'गूगल से जारी रखें (डेमो)',
    },
    'continue_apple': {
      AppLanguage.english: 'Continue with Apple',
      AppLanguage.marathi: 'Apple ने पुढे जा (डेमो)',
      AppLanguage.hindi: 'Apple से जारी रखें (डेमो)',
    },
    'dont_have_account': {
      AppLanguage.english: "Don't have an account?",
      AppLanguage.marathi: 'खाते नाही आहे?',
      AppLanguage.hindi: 'खाता नहीं है?',
    },
    'already_have_account': {
      AppLanguage.english: 'Already have an account?',
      AppLanguage.marathi: 'आधीच खाते आहे?',
      AppLanguage.hindi: 'पहले से खाता है?',
    },
    'terms_privacy_agreement': {
      AppLanguage.english: 'By continuing, you agree to our Terms of Service & Privacy Policy',
      AppLanguage.marathi: 'पुढे जाऊन तुम्ही सेवा अटी व गोपनीयता धोरणास सहमती दर्शवता',
      AppLanguage.hindi: 'आगे बढ़कर आप सेवा की शर्तें और गोपनीयता नीति स्वीकार करते हैं',
    },

    // Camera & Scan
    'camera_instruction': {
      AppLanguage.english: 'Place a single leaf in the frame, in good light.',
      AppLanguage.marathi: 'चांगल्या प्रकाशात एकच पान फ्रेममध्ये ठेवा.',
      AppLanguage.hindi: 'अच्छी रोशनी में एक पत्ती को फ्रेम में रखें।',
    },
    'analyzing_leaf': {
      AppLanguage.english: 'Analyzing leaf...',
      AppLanguage.marathi: 'पानाचे विश्लेषण करत आहे...',
      AppLanguage.hindi: 'पत्ती का विश्लेषण हो रहा है...',
    },
    'preview_title': {
      AppLanguage.english: 'Leaf Preview',
      AppLanguage.marathi: 'पानाची पूर्वतपासणी',
      AppLanguage.hindi: 'पत्ती पूर्वावलोकन',
    },
    'retake': {
      AppLanguage.english: 'Retake',
      AppLanguage.marathi: 'पुन्हा काढा',
      AppLanguage.hindi: 'फिर से लें',
    },
    'choose_another': {
      AppLanguage.english: 'Choose Another Image',
      AppLanguage.marathi: 'दुसरा फोटो निवडा',
      AppLanguage.hindi: 'दूसरी तस्वीर चुनें',
    },
    'analyze_leaf': {
      AppLanguage.english: 'Analyze Leaf',
      AppLanguage.marathi: 'पान तपासा',
      AppLanguage.hindi: 'पत्ती जांचें',
    },

    // Results
    'detection_result': {
      AppLanguage.english: 'Diagnosis Result',
      AppLanguage.marathi: 'तपासणी निष्कर्ष',
      AppLanguage.hindi: 'निदान परिणाम',
    },
    'demo_mode_badge': {
      AppLanguage.english: 'DEMO PREDICTION',
      AppLanguage.marathi: 'डेमो अंदाज',
      AppLanguage.hindi: 'डेमो पूर्वानुमान',
    },
    'confidence_score': {
      AppLanguage.english: 'Demo Confidence',
      AppLanguage.marathi: 'अंदाजित विश्वासार्हता',
      AppLanguage.hindi: 'डेमो सटीकता',
    },
    'severity': {
      AppLanguage.english: 'Severity',
      AppLanguage.marathi: 'तीव्रता',
      AppLanguage.hindi: 'गंभीरता',
    },
    'symptoms': {
      AppLanguage.english: 'Symptoms',
      AppLanguage.marathi: 'लक्षणे',
      AppLanguage.hindi: 'लक्षण',
    },
    'possible_causes': {
      AppLanguage.english: 'Possible Causes',
      AppLanguage.marathi: 'संभाव्य कारणे',
      AppLanguage.hindi: 'संभावित कारण',
    },
    'treatment_guidance': {
      AppLanguage.english: 'Treatment Guidance',
      AppLanguage.marathi: 'उपचार व उपाय',
      AppLanguage.hindi: 'उपचार मार्गदर्शन',
    },
    'prevention_guidance': {
      AppLanguage.english: 'Prevention Guidance',
      AppLanguage.marathi: 'प्रतिबंधात्मक उपाय',
      AppLanguage.hindi: 'रोकथाम के उपाय',
    },
    'save_report': {
      AppLanguage.english: 'Save Report',
      AppLanguage.marathi: 'अहवाल सेव्ह करा',
      AppLanguage.hindi: 'रिपोर्ट सहेजें',
    },
    'share_report': {
      AppLanguage.english: 'Share',
      AppLanguage.marathi: 'शेअर करा',
      AppLanguage.hindi: 'साझा करें',
    },
    'scan_another_leaf': {
      AppLanguage.english: 'Scan Another Leaf',
      AppLanguage.marathi: 'दुसरे पान स्कॅन करा',
      AppLanguage.hindi: 'दूसरी पत्ती स्कैन करें',
    },
    'overlay_toggle': {
      AppLanguage.english: 'Show Affected Area Heatmap',
      AppLanguage.marathi: 'बाधित भागाचा नकाशा दाखवा',
      AppLanguage.hindi: 'प्रभावित क्षेत्र का हीटमैप दिखाएं',
    },

    // Expert disclaimer
    'expert_disclaimer': {
      AppLanguage.english:
          'Note: Some sugarcane diseases cannot be diagnosed from leaf images alone. Seek local Krishi Vigyan Kendra (KVK) or agricultural expert advice before applying treatments.',
      AppLanguage.marathi:
          'टीप: उसाचे काही रोग केवळ पानांच्या फोटोवरून पूर्णपणे ओळखता येत नाहीत. कोणताही रासायनिक उपचार करण्यापूर्वी स्थानिक कृषी विज्ञान केंद्र (KVK) किंवा कृषी तज्ज्ञांचा सल्ला घ्यावा.',
      AppLanguage.hindi:
          'नोट: गन्ने के कुछ रोगों की पहचान केवल पत्ती के फोटो से नहीं की जा सकती। उपचार से पहले स्थानीय कृषि विज्ञान केंद्र (KVK) या कृषि विशेषज्ञ से परामर्श अवश्य लें।',
    },

    // Settings
    'notifications': {
      AppLanguage.english: 'Notification Preferences',
      AppLanguage.marathi: 'सूचना प्राधान्ये',
      AppLanguage.hindi: 'सूचनाएं',
    },
    'saved_reports': {
      AppLanguage.english: 'Saved Reports',
      AppLanguage.marathi: 'जतन केलेले अहवाल',
      AppLanguage.hindi: 'सहेजे गए रिपोर्ट्स',
    },
    'help_support': {
      AppLanguage.english: 'Help & Support',
      AppLanguage.marathi: 'मदत आणि सहकार्य',
      AppLanguage.hindi: 'सहायता और समर्थन',
    },
    'feedback': {
      AppLanguage.english: 'Send Feedback',
      AppLanguage.marathi: 'अभिप्राय पाठवा',
      AppLanguage.hindi: 'प्रतिक्रिया भेजें',
    },
    'about_canecare': {
      AppLanguage.english: 'About CaneCare AI',
      AppLanguage.marathi: 'केनकेअर एआय बद्दल',
      AppLanguage.hindi: 'केनकेयर एआई के बारे में',
    },
    'logout': {
      AppLanguage.english: 'Logout',
      AppLanguage.marathi: 'लॉगआउट',
      AppLanguage.hindi: 'लॉगआउट',
    },
    'confirm_logout': {
      AppLanguage.english: 'Are you sure you want to log out?',
      AppLanguage.marathi: 'तुम्हाला खात्रीने लॉगआउट करायचे आहे का?',
      AppLanguage.hindi: 'क्या आप निश्चित रूप से लॉगआउट करना चाहते हैं?',
    },

    // Weather Information Screen
    'weather_title': {
      AppLanguage.english: 'Weather Information',
      AppLanguage.marathi: 'हवामान माहिती',
      AppLanguage.hindi: 'मौसम की जानकारी',
    },
    'default_location': {
      AppLanguage.english: 'Satara, Maharashtra',
      AppLanguage.marathi: 'सातारा, महाराष्ट्र',
      AppLanguage.hindi: 'सतारा, महाराष्ट्र',
    },
    'change_location': {
      AppLanguage.english: 'Change Location',
      AppLanguage.marathi: 'स्थान बदला',
      AppLanguage.hindi: 'स्थान बदलें',
    },
    'select_district': {
      AppLanguage.english: 'Select District',
      AppLanguage.marathi: 'जिल्हा निवडा',
      AppLanguage.hindi: 'जिला चुनें',
    },
    'weather_partly_cloudy': {
      AppLanguage.english: 'Partly Cloudy',
      AppLanguage.marathi: 'अंशतः ढगाळ',
      AppLanguage.hindi: 'आंशिक रूप से बादल',
    },
    'weather_humidity': {
      AppLanguage.english: 'Humidity',
      AppLanguage.marathi: 'आर्द्रता',
      AppLanguage.hindi: 'आर्द्रता',
    },
    'weather_wind': {
      AppLanguage.english: 'Wind',
      AppLanguage.marathi: 'वारा',
      AppLanguage.hindi: 'हवा',
    },
    'weather_kmh': {
      AppLanguage.english: 'km/h',
      AppLanguage.marathi: 'किमी/तास',
      AppLanguage.hindi: 'किमी/घंटा',
    },
    'forecast_today': {
      AppLanguage.english: 'Today',
      AppLanguage.marathi: 'आज',
      AppLanguage.hindi: 'आज',
    },
    'forecast_tomorrow': {
      AppLanguage.english: 'Tomorrow',
      AppLanguage.marathi: 'उद्या',
      AppLanguage.hindi: 'कल',
    },
    'day_sun': {
      AppLanguage.english: 'Sun',
      AppLanguage.marathi: 'रवि',
      AppLanguage.hindi: 'रवि',
    },
    'day_mon': {
      AppLanguage.english: 'Mon',
      AppLanguage.marathi: 'सोम',
      AppLanguage.hindi: 'सोम',
    },
    'day_tue': {
      AppLanguage.english: 'Tue',
      AppLanguage.marathi: 'मंगळ',
      AppLanguage.hindi: 'मंगल',
    },
    'day_wed': {
      AppLanguage.english: 'Wed',
      AppLanguage.marathi: 'बुध',
      AppLanguage.hindi: 'बुध',
    },
    'day_thu': {
      AppLanguage.english: 'Thu',
      AppLanguage.marathi: 'गुरू',
      AppLanguage.hindi: 'गुरु',
    },
    'day_fri': {
      AppLanguage.english: 'Fri',
      AppLanguage.marathi: 'शुक्र',
      AppLanguage.hindi: 'शुक्र',
    },
    'day_sat': {
      AppLanguage.english: 'Sat',
      AppLanguage.marathi: 'शनि',
      AppLanguage.hindi: 'शनि',
    },
    'seven_day_forecast_title': {
      AppLanguage.english: '7-Day Weather Forecast',
      AppLanguage.marathi: '७ दिवसांचा हवामान अंदाज (सोम - रवि)',
      AppLanguage.hindi: '७ दिनों का मौसम पूर्वानुमान (सोम - रवि)',
    },
    'crop_advice_title': {
      AppLanguage.english: 'Advisory for Crops',
      AppLanguage.marathi: 'पिकांसाठी सूचना',
      AppLanguage.hindi: 'फसलों के लिए सलाह',
    },
    'crop_advice_text': {
      AppLanguage.english:
          'Today the weather is favorable. Maintain proper water management.',
      AppLanguage.marathi:
          'आज हवामान अनुकूल आहे. पाण्याचे व्यवस्थापन योग्य ठेवा.',
      AppLanguage.hindi:
          'आज मौसम अनुकूल है। पानी का उचित प्रबंधन रखें।',
    },
    'weather_demo_tag': {
      AppLanguage.english: 'Live Satellite & GPS Weather Forecast',
      AppLanguage.marathi: 'थेट उपग्रह व GPS हवामान अंदाज',
      AppLanguage.hindi: 'लाइव सैटेलाइट व GPS मौसम पूर्वानुमान',
    },
    'weather_live_source': {
      AppLanguage.english: 'Live Satellite & Open-Meteo Weather Data',
      AppLanguage.marathi: 'थेट उपग्रह व Open-Meteo हवामान डेटा',
      AppLanguage.hindi: 'लाइव सैटेलाइट और Open-Meteo मौसम डेटा',
    },
    'weather_live_gps': {
      AppLanguage.english: 'Live GPS Location',
      AppLanguage.marathi: 'थेट GPS स्थान',
      AppLanguage.hindi: 'लाइव GPS स्थान',
    },
    'weather_detect_location': {
      AppLanguage.english: 'Track My Current Location (GPS)',
      AppLanguage.marathi: 'माझे चालू ठिकाण शोधा (GPS)',
      AppLanguage.hindi: 'मेरा वर्तमान स्थान खोजें (GPS)',
    },
    'weather_detecting': {
      AppLanguage.english: 'Detecting live location...',
      AppLanguage.marathi: 'जीपीएस स्थान शोधत आहे...',
      AppLanguage.hindi: 'जीपीएस स्थान खोज रहे हैं...',
    },
    'weather_search_hint': {
      AppLanguage.english: 'Search town, village or taluka (e.g. Shirdi, Sangamner)...',
      AppLanguage.marathi: 'गाव किंवा तालुका शोधा (उदा. शिर्डी, संगमनेर)...',
      AppLanguage.hindi: 'गांव या तालुका खोजें (उदा. शिरडी, संगमनेर)...',
    },
    'weather_clear': {
      AppLanguage.english: 'Clear Sky',
      AppLanguage.marathi: 'निरभ्र आकाश',
      AppLanguage.hindi: 'साफ मौसम',
    },
    'weather_mainly_clear': {
      AppLanguage.english: 'Mainly Clear',
      AppLanguage.marathi: 'मुख्यतः निरभ्र',
      AppLanguage.hindi: 'मुख्य रूप से साफ',
    },
    'weather_fog': {
      AppLanguage.english: 'Foggy',
      AppLanguage.marathi: 'धुके',
      AppLanguage.hindi: 'कोहरा',
    },
    'weather_drizzle': {
      AppLanguage.english: 'Light Drizzle',
      AppLanguage.marathi: 'हलक्या सरी / तुषार',
      AppLanguage.hindi: 'हल्की बूंदाबांदी',
    },
    'weather_rain': {
      AppLanguage.english: 'Rain',
      AppLanguage.marathi: 'पाऊस',
      AppLanguage.hindi: 'बारिश',
    },
    'weather_storm': {
      AppLanguage.english: 'Thunderstorm',
      AppLanguage.marathi: 'वादळी पाऊस',
      AppLanguage.hindi: 'तूफानी बारिश',
    },
    'weather_gps_error': {
      AppLanguage.english: 'GPS location unavailable. Please select from list below.',
      AppLanguage.marathi: 'जीपीएस स्थान मिळू शकले नाही. कृपया खालील यादीतून निवडा.',
      AppLanguage.hindi: 'जीपीएस स्थान उपलब्ध नहीं। कृपया नीचे दी गई सूची से चुनें।',
    },

    // Sugarcane Advisory Screen
    'advisory_screen_title': {
      AppLanguage.english: 'Expert Advisory',
      AppLanguage.marathi: 'तज्ञांचा सल्ला',
      AppLanguage.hindi: 'विशेषज्ञ सलाह',
    },
    'sugarcane_advisory': {
      AppLanguage.english: 'Sugarcane Advisory',
      AppLanguage.marathi: 'ऊस शेती सल्ला',
      AppLanguage.hindi: 'गन्ने की खेती संबंधी सलाह',
    },
    'tab_my_questions': {
      AppLanguage.english: 'My Questions',
      AppLanguage.marathi: 'माझे प्रश्न',
      AppLanguage.hindi: 'मेरे प्रश्न',
    },
    'tab_all_questions': {
      AppLanguage.english: 'All Questions',
      AppLanguage.marathi: 'सर्व प्रश्न',
      AppLanguage.hindi: 'सभी प्रश्न',
    },
    'cat_diseases_title': {
      AppLanguage.english: 'Sugarcane Diseases',
      AppLanguage.marathi: 'ऊस पिकातील रोग',
      AppLanguage.hindi: 'गन्ने की फसल के रोग',
    },
    'cat_diseases_sub': {
      AppLanguage.english: 'Leaf spots, rot, pests',
      AppLanguage.marathi: 'पानावरील डाग, कुज, किड',
      AppLanguage.hindi: 'पत्ती के धब्बे, सड़न, कीट',
    },
    'cat_fertilizer_title': {
      AppLanguage.english: 'Fertilizer Management',
      AppLanguage.marathi: 'खत व्यवस्थापन',
      AppLanguage.hindi: 'उर्वरक प्रबंधन',
    },
    'cat_fertilizer_sub': {
      AppLanguage.english: 'Proper fertilizer & dosage',
      AppLanguage.marathi: 'योग्य खत आणि प्रमाण',
      AppLanguage.hindi: 'उचित खाद और मात्रा',
    },
    'cat_water_title': {
      AppLanguage.english: 'Water Management',
      AppLanguage.marathi: 'पाणी व्यवस्थापन',
      AppLanguage.hindi: 'जल प्रबंधन',
    },
    'cat_water_sub': {
      AppLanguage.english: 'Proper irrigation planning',
      AppLanguage.marathi: 'सिंचनाचे योग्य नियोजन',
      AppLanguage.hindi: 'सिंचाई का उचित नियोजन',
    },
    'cat_general_title': {
      AppLanguage.english: 'General Questions',
      AppLanguage.marathi: 'सामान्य प्रश्न',
      AppLanguage.hindi: 'सामान्य प्रश्न',
    },
    'cat_general_sub': {
      AppLanguage.english: 'Various farming queries',
      AppLanguage.marathi: 'विविध शेतीविषयक प्रश्न',
      AppLanguage.hindi: 'विभिन्न कृषि संबंधी प्रश्न',
    },
    'ask_new_question': {
      AppLanguage.english: 'Ask a New Question',
      AppLanguage.marathi: 'नवीन प्रश्न विचारा',
      AppLanguage.hindi: 'नया प्रश्न पूछें',
    },
    'question_title_label': {
      AppLanguage.english: 'Question Title',
      AppLanguage.marathi: 'प्रश्नाचे नाव / शीर्षक',
      AppLanguage.hindi: 'प्रश्न का शीर्षक',
    },
    'question_title_hint': {
      AppLanguage.english: 'e.g., Red rot symptoms on lower leaves',
      AppLanguage.marathi: 'उदा. ऊसाच्या खालच्या पानांवर लाल रंगाचे डाग',
      AppLanguage.hindi: 'उदा. गन्ने की निचली पत्तियों पर लाल धब्बे',
    },
    'question_desc_label': {
      AppLanguage.english: 'Detailed Problem Description',
      AppLanguage.marathi: 'समस्येचे सविस्तर वर्णन',
      AppLanguage.hindi: 'समस्या का विस्तृत विवरण',
    },
    'question_desc_hint': {
      AppLanguage.english: 'Describe plant age, leaf color, watering schedule...',
      AppLanguage.marathi: 'ऊसाचे वय, पानांचा रंग, पाण्याचे दिवस नमूद करा...',
      AppLanguage.hindi: 'गन्ने की आयु, पत्तियों का रंग, सिंचाई का समय बताएं...',
    },
    'question_cat_label': {
      AppLanguage.english: 'Advisory Category',
      AppLanguage.marathi: 'सल्ला वर्ग / विभाग',
      AppLanguage.hindi: 'सलाह श्रेणी',
    },
    'submit_question': {
      AppLanguage.english: 'Submit to Experts',
      AppLanguage.marathi: 'तज्ञांना प्रश्न पाठवा',
      AppLanguage.hindi: 'विशेषज्ञों को प्रश्न भेजें',
    },
    'question_submitted_success': {
      AppLanguage.english: 'Your question was submitted successfully!',
      AppLanguage.marathi: 'तुमचा प्रश्न यशस्वीपणे नोंदवला गेला आहे!',
      AppLanguage.hindi: 'आपका प्रश्न सफलतापूर्वक दर्ज कर लिया गया है!',
    },
    'no_questions_yet': {
      AppLanguage.english: 'No questions submitted yet',
      AppLanguage.marathi: 'अद्याप कोणतेही प्रश्न विचारलेले नाहीत',
      AppLanguage.hindi: 'अभी तक कोई प्रश्न नहीं पूछा गया',
    },
    'ask_first_prompt': {
      AppLanguage.english:
          'Ask your sugarcane doubts directly to experienced agronomists.',
      AppLanguage.marathi:
          'ऊस शेतीमधील तुमच्या शंका थेट कृषी तज्ञांना विचारा.',
      AppLanguage.hindi:
          'गन्ने की खेती से जुड़े अपने सवाल सीधे कृषि विशेषज्ञों से पूछें।',
    },

    // Side Navigation Drawer
    'drawer_home': {
      AppLanguage.english: 'Home',
      AppLanguage.marathi: 'होम',
      AppLanguage.hindi: 'होम',
    },
    'drawer_scan': {
      AppLanguage.english: 'Scan Leaf',
      AppLanguage.marathi: 'रोग ओळखा',
      AppLanguage.hindi: 'रोग पहचानें',
    },
    'drawer_care_guide': {
      AppLanguage.english: 'Sugarcane Care Guide',
      AppLanguage.marathi: 'ऊस पीक मार्गदर्शिका',
      AppLanguage.hindi: 'गन्ना फसल गाइड',
    },
    'drawer_community': {
      AppLanguage.english: 'Farmer Community',
      AppLanguage.marathi: 'शेतकरी कम्युनिटी',
      AppLanguage.hindi: 'किसान समुदाय',
    },
    'drawer_language': {
      AppLanguage.english: 'Language Selection',
      AppLanguage.marathi: 'भाषा निवड',
      AppLanguage.hindi: 'भाषा चुनें',
    },
    'drawer_weather': {
      AppLanguage.english: 'Weather Information',
      AppLanguage.marathi: 'हवामान माहिती',
      AppLanguage.hindi: 'मौसम की जानकारी',
    },
    'drawer_advisory': {
      AppLanguage.english: 'Expert Advisory',
      AppLanguage.marathi: 'तज्ञांचा सल्ला',
      AppLanguage.hindi: 'विशेषज्ञ सलाह',
    },
    'drawer_history': {
      AppLanguage.english: 'History',
      AppLanguage.marathi: 'इतिहास',
      AppLanguage.hindi: 'इतिहास',
    },
    'drawer_notifications': {
      AppLanguage.english: 'Notifications',
      AppLanguage.marathi: 'सूचना',
      AppLanguage.hindi: 'सूचनाएं',
    },
    'drawer_settings': {
      AppLanguage.english: 'Settings',
      AppLanguage.marathi: 'सेटिंग्ज',
      AppLanguage.hindi: 'सेटिंग्स',
    },
    'drawer_saved_reports': {
      AppLanguage.english: 'Saved Reports',
      AppLanguage.marathi: 'जतन अहवाल',
      AppLanguage.hindi: 'सहेजी गई रिपोर्ट',
    },
    'drawer_profile': {
      AppLanguage.english: 'Profile',
      AppLanguage.marathi: 'प्रोफाइल',
      AppLanguage.hindi: 'प्रोफ़ाइल',
    },
    'drawer_about': {
      AppLanguage.english: 'About CaneCare AI',
      AppLanguage.marathi: 'ॲपबद्दल',
      AppLanguage.hindi: 'ऐप के बारे में',
    },
    'drawer_logout': {
      AppLanguage.english: 'Logout',
      AppLanguage.marathi: 'लॉगआउट',
      AppLanguage.hindi: 'लॉगआउट',
    },
    'home_greeting_subtitle': {
      AppLanguage.english: "Let's keep your sugarcane healthy.",
      AppLanguage.marathi: 'चला तुमचा ऊस निरोगी ठेवूया.',
      AppLanguage.hindi: 'आइए आपके गन्ने को स्वस्थ रखें।',
    },
    'check_crop_tag': {
      AppLanguage.english: 'CHECK YOUR CROP',
      AppLanguage.marathi: 'पीक आरोग्य तपासा',
      AppLanguage.hindi: 'फसल स्वास्थ्य जांचें',
    },
    'explore_canecare': {
      AppLanguage.english: 'Explore CaneCare',
      AppLanguage.marathi: 'केनकेअर विशेष सुविधा',
      AppLanguage.hindi: 'केनकेयर विशेष सुविधाएं',
    },
    'quick_help_btn': {
      AppLanguage.english: 'Quick help',
      AppLanguage.marathi: 'मदत मिळवा',
      AppLanguage.hindi: 'सहायता पाएं',
    },
    'advisory_direct_expert': {
      AppLanguage.english: 'Direct expert advice',
      AppLanguage.marathi: 'तज्ञांचा थेट सल्ला',
      AppLanguage.hindi: 'विशेषज्ञों की सीधी सलाह',
    },
    'recent_scans_title': {
      AppLanguage.english: 'Recent scans',
      AppLanguage.marathi: 'अलीकडील स्कॅन',
      AppLanguage.hindi: 'हाल के स्कैन',
    },
    'recent_scans_count': {
      AppLanguage.english: '2 reports this week',
      AppLanguage.marathi: 'या आठवड्यात २ अहवाल',
      AppLanguage.hindi: 'इस हफ्ते २ रिपोर्ट',
    },
    'keep_field_title': {
      AppLanguage.english: 'Keep field',
      AppLanguage.marathi: 'शेत निरीक्षण',
      AppLanguage.hindi: 'खेत निगरानी',
    },
    'keep_field_subtitle': {
      AppLanguage.english: 'Check your crop health',
      AppLanguage.marathi: 'पिकाचे आरोग्य तपासा',
      AppLanguage.hindi: 'फसल स्वास्थ्य जांचें',
    },
    'crop_tips_title': {
      AppLanguage.english: 'Healthy crop tips',
      AppLanguage.marathi: 'पीक संवर्धन टिप्स',
      AppLanguage.hindi: 'फसल सुरक्षा सुझाव',
    },
    'crop_tips_subtitle': {
      AppLanguage.english: 'Learn disease prevention',
      AppLanguage.marathi: 'रोग नियंत्रण पद्धती शिका',
      AppLanguage.hindi: 'रोग रोकथाम सीखें',
    },
    'search_diseases': {
      AppLanguage.english: 'Search diseases...',
      AppLanguage.marathi: 'रोग शोधा...',
      AppLanguage.hindi: 'रोग खोजें...',
    },
    'filter_all': {
      AppLanguage.english: 'All',
      AppLanguage.marathi: 'सर्व',
      AppLanguage.hindi: 'सभी',
    },
    'filter_diseased': {
      AppLanguage.english: 'Diseased',
      AppLanguage.marathi: 'बाधित',
      AppLanguage.hindi: 'रोगग्रस्त',
    },
    'filter_healthy': {
      AppLanguage.english: 'Healthy',
      AppLanguage.marathi: 'निरोगी',
      AppLanguage.hindi: 'स्वस्थ',
    },
    'disease_library_title': {
      AppLanguage.english: 'Disease Library',
      AppLanguage.marathi: 'उसाचे रोग माहिती',
      AppLanguage.hindi: 'गन्ना रोग लाइब्रेरी',
    },
    'section_overview': {
      AppLanguage.english: 'Overview',
      AppLanguage.marathi: 'तपशील आणि ओळख',
      AppLanguage.hindi: 'विवरण और पहचान',
    },
    'section_symptoms': {
      AppLanguage.english: 'Common Symptoms',
      AppLanguage.marathi: 'मुख्य लक्षणे',
      AppLanguage.hindi: 'प्रमुख लक्षण',
    },
    'section_causes': {
      AppLanguage.english: 'Conditions & Causes',
      AppLanguage.marathi: 'अनुकूल परिस्थिती व कारणे',
      AppLanguage.hindi: 'अनुकूल परिस्थितियां व कारण',
    },
    'section_treatment': {
      AppLanguage.english: 'Treatment & Prevention',
      AppLanguage.marathi: 'नियंत्रण व उपाययोजना',
      AppLanguage.hindi: 'रोकथाम और उपचार',
    },
    'cultural_practices': {
      AppLanguage.english: 'Cultural Practices',
      AppLanguage.marathi: 'मशागतीचे उपाय',
      AppLanguage.hindi: 'कृषि कार्य व प्रबंधन',
    },
    'organic_measures': {
      AppLanguage.english: 'Organic & Bio-Control',
      AppLanguage.marathi: 'जैविक व सेंद्रिय नियंत्रण',
      AppLanguage.hindi: 'जैविक नियंत्रण',
    },
    'preventive_steps': {
      AppLanguage.english: 'Preventive Measures',
      AppLanguage.marathi: 'प्रतिबंधात्मक उपाय',
      AppLanguage.hindi: 'निवारक उपाय',
    },
    'expert_note_heading': {
      AppLanguage.english: 'Expert Advisory Note',
      AppLanguage.marathi: 'कृषी तज्ञ सूचना',
      AppLanguage.hindi: 'कृषि विशेषज्ञ सलाह',
    },
    'tap_shutter_hint': {
      AppLanguage.english: 'Tap Shutter to Capture Leaf',
      AppLanguage.marathi: 'फोटो काढण्यासाठी शटर दाबा',
      AppLanguage.hindi: 'फोटो लेने के लिए शटर दबाएं',
    },
    'gallery': {
      AppLanguage.english: 'Gallery',
      AppLanguage.marathi: 'गॅलरी',
      AppLanguage.hindi: 'गैलरी',
    },
    'flash': {
      AppLanguage.english: 'Flash',
      AppLanguage.marathi: 'फ्लॅश',
      AppLanguage.hindi: 'फ्लैश',
    },
    'flash_on': {
      AppLanguage.english: 'On',
      AppLanguage.marathi: 'सुरू',
      AppLanguage.hindi: 'चालू',
    },
    'tab_details': {
      AppLanguage.english: 'Details',
      AppLanguage.marathi: 'तपशील',
      AppLanguage.hindi: 'विवरण',
    },
    'tab_treatment': {
      AppLanguage.english: 'Treatment',
      AppLanguage.marathi: 'उपाययोजना',
      AppLanguage.hindi: 'उपचार',
    },
    'tab_prevention': {
      AppLanguage.english: 'Prevention',
      AppLanguage.marathi: 'प्रतिबंध',
      AppLanguage.hindi: 'रोकथाम',
    },
    'report_saved_success': {
      AppLanguage.english: 'Report Saved ✓',
      AppLanguage.marathi: 'अहवाल जतन झाला ✓',
      AppLanguage.hindi: 'रिपोर्ट सहेजी गई ✓',
    },
    'back': {
      AppLanguage.english: 'Back',
      AppLanguage.marathi: 'मागे जा',
      AppLanguage.hindi: 'वापस जाएं',
    },
    'profile_title': {
      AppLanguage.english: 'Profile',
      AppLanguage.marathi: 'प्रोफाइल',
      AppLanguage.hindi: 'प्रोफ़ाइल',
    },
    'profile_farmer': {
      AppLanguage.english: 'Farmer',
      AppLanguage.marathi: 'शेतकरी मित्र',
      AppLanguage.hindi: 'किसान भाई',
    },
    'profile_account': {
      AppLanguage.english: 'Account & Profile',
      AppLanguage.marathi: 'खाते आणि प्रोफाइल',
      AppLanguage.hindi: 'खाता और प्रोफ़ाइल',
    },
    'profile_language': {
      AppLanguage.english: 'Language',
      AppLanguage.marathi: 'भाषा',
      AppLanguage.hindi: 'भाषा',
    },
    'profile_notifications': {
      AppLanguage.english: 'Notifications',
      AppLanguage.marathi: 'सूचना',
      AppLanguage.hindi: 'सूचनाएं',
    },
    'profile_saved_reports': {
      AppLanguage.english: 'Saved Reports',
      AppLanguage.marathi: 'जतन अहवाल',
      AppLanguage.hindi: 'सहेजी गई रिपोर्ट',
    },
    'profile_help': {
      AppLanguage.english: 'Help & Support',
      AppLanguage.marathi: 'मदत आणि सहाय्य',
      AppLanguage.hindi: 'मदद और सहायता',
    },
    'profile_feedback': {
      AppLanguage.english: 'Share Feedback',
      AppLanguage.marathi: 'अभिप्राय नोंदवा',
      AppLanguage.hindi: 'प्रतिक्रिया दें',
    },
    'profile_about': {
      AppLanguage.english: 'About CaneCare AI',
      AppLanguage.marathi: 'ॲपबद्दल',
      AppLanguage.hindi: 'ऐप के बारे में',
    },
    'profile_logout': {
      AppLanguage.english: 'Log Out',
      AppLanguage.marathi: 'लॉगआउट',
      AppLanguage.hindi: 'लॉगआउट',
    },
    'preview_subtext': {
      AppLanguage.english: 'Make sure the leaf is clear and well-lit.',
      AppLanguage.marathi: 'फोटो स्पष्ट आणि चांगल्या प्रकाशात असल्याची खात्री करा.',
      AppLanguage.hindi: 'पत्ती साफ और अच्छी रोशनी में होना सुनिश्चित करें।',
    },
    'scan_history_title': {
      AppLanguage.english: 'Scan History',
      AppLanguage.marathi: 'स्कॅन इतिहास',
      AppLanguage.hindi: 'स्कैन इतिहास',
    },
    'report_saved_title': {
      AppLanguage.english: 'Report Saved!',
      AppLanguage.marathi: 'अहवाल जतन झाला!',
      AppLanguage.hindi: 'रिपोर्ट सहेज ली गई!',
    },
    'report_saved_desc': {
      AppLanguage.english: 'Your scan report has been\nsaved successfully.',
      AppLanguage.marathi: 'तुमचा तपासणी अहवाल\nयशस्वीरीत्या जतन केला गेला आहे.',
      AppLanguage.hindi: 'आपकी स्कैन रिपोर्ट\nसफलतापूर्वक सहेज ली गई है।',
    },
    'view_report': {
      AppLanguage.english: 'View Report',
      AppLanguage.marathi: 'अहवाल पहा',
      AppLanguage.hindi: 'रिपोर्ट देखें',
    },
    'back_to_home': {
      AppLanguage.english: 'Back to Home',
      AppLanguage.marathi: 'मुख्य पृष्ठावर जा',
      AppLanguage.hindi: 'होम पेज पर वापस जाएं',
    },
    'privacy_policy': {
      AppLanguage.english: 'Privacy Policy',
      AppLanguage.marathi: 'गोपनीयता धोरण',
      AppLanguage.hindi: 'गोपनीयता नीति',
    },
    'terms_of_service': {
      AppLanguage.english: 'Terms of Service',
      AppLanguage.marathi: 'वापर नियम आणि अटी',
      AppLanguage.hindi: 'सेवा की शर्तें',
    },
    'no_history': {
      AppLanguage.english: 'No scans yet',
      AppLanguage.marathi: 'अद्याप कोणतेही स्कॅन नाही',
      AppLanguage.hindi: 'अभी तक कोई स्कैन नहीं है',
    },
    'no_history_desc': {
      AppLanguage.english: 'Your leaf scans will appear here.',
      AppLanguage.marathi: 'तुमचे उसाचे स्कॅन केलेले फोटो येथे दिसतील.',
      AppLanguage.hindi: 'आपकी गन्ने की पत्तियों के स्कैन यहां दिखाई देंगे।',
    },
    'scan_first_leaf': {
      AppLanguage.english: 'Scan Your First Leaf',
      AppLanguage.marathi: 'पहिले पान स्कॅन करा',
      AppLanguage.hindi: 'अपनी पहली पत्ती स्कैन करें',
    },
    'cancel': {
      AppLanguage.english: 'Cancel',
      AppLanguage.marathi: 'रद्द करा',
      AppLanguage.hindi: 'रद्द करें',
    },
    'save': {
      AppLanguage.english: 'Save',
      AppLanguage.marathi: 'जतन करा',
      AppLanguage.hindi: 'सहेजें',
    },
    'continue_btn': {
      AppLanguage.english: 'Continue',
      AppLanguage.marathi: 'पुढे जा',
      AppLanguage.hindi: 'आगे बढ़ें',
    },
  };

  String translate(String key) {
    if (_localizedValues.containsKey(key)) {
      return _localizedValues[key]?[language] ??
          _localizedValues[key]?[AppLanguage.english] ??
          key;
    }
    return key;
  }
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  final AppLanguage currentLanguage;

  const AppLocalizationsDelegate(this.currentLanguage);

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(currentLanguage);
  }

  @override
  bool shouldReload(covariant AppLocalizationsDelegate old) =>
      old.currentLanguage != currentLanguage;
}
