import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import 'notifications_screen.dart';

/// Screen 2: Farmer Community (शेतकरी कम्युनिटी)
/// A premium, farmer-friendly discussion and knowledge exchange platform
/// designed for sugarcane farmers in Maharashtra, India with full trilingual support.
class FarmerCommunityScreen extends StatefulWidget {
  const FarmerCommunityScreen({super.key});

  @override
  State<FarmerCommunityScreen> createState() => _FarmerCommunityScreenState();
}

class _FarmerCommunityScreenState extends State<FarmerCommunityScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _selectedCategoryId = 'all';
  String _searchQuery = '';

  // Filter chips definitions with multilingual IDs and labels
  final List<Map<String, String>> _categories = [
    {
      'id': 'all',
      'en': 'All Posts',
      'mr': 'सर्व पोस्ट',
      'hi': 'सभी पोस्ट',
    },
    {
      'id': 'diseases',
      'en': 'Crop Diseases',
      'mr': 'पीक रोग',
      'hi': 'फसल रोग',
    },
    {
      'id': 'irrigation',
      'en': 'Irrigation',
      'mr': 'पाणी व्यवस्थापन',
      'hi': 'सिंचाई प्रबंधन',
    },
    {
      'id': 'fertilizers',
      'en': 'Fertilizers',
      'mr': 'खते व पोषण',
      'hi': 'उर्वरक प्रबंधन',
    },
    {
      'id': 'market',
      'en': 'Market Updates',
      'mr': 'बाजार भाव',
      'hi': 'बाजार भाव',
    },
    {
      'id': 'success',
      'en': 'Success Stories',
      'mr': 'यशोगाथा',
      'hi': 'सफलता की कहानियां',
    },
  ];

  // Community discussion feed state
  late List<_CommunityPost> _posts;

  @override
  void initState() {
    super.initState();
    _posts = _getInitialPosts();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<_CommunityPost> _getInitialPosts() {
    return [
      _CommunityPost(
        id: 'post_1',
        authorName: 'Ramesh Shinde',
        locationMr: 'कराड, सातारा',
        locationHi: 'कराड, सतारा',
        locationEn: 'Karad, Satara',
        timeAgoMr: '२ तासांपूर्वी',
        timeAgoHi: '२ घंटे पहले',
        timeAgoEn: '2 hrs ago',
        authorBadgeMr: 'ऊस उत्पादक शेतकरी',
        authorBadgeHi: 'गन्ना किसान',
        authorBadgeEn: 'Verified Cane Grower',
        avatarColor: const Color(0xFF15803D),
        initials: 'RS',
        categoryId: 'diseases',
        titleEn: 'How can I identify unusual red patches on sugarcane leaves?',
        titleMr: 'उसाच्या पानांवर लाल रंगाचे चट्टे दिसत आहेत, हा तांबेरा रोग आहे का?',
        titleHi: 'गन्ने की पत्तियों पर लाल धब्बे दिख रहे हैं, क्या यह गेरुआ रोग है?',
        descEn:
            'Observed brownish-red elongate patches on leaves of 5-month-old Co 86032. Need advice on whether fungicide spray like Mancozeb is required immediately.',
        descMr:
            '५ महिन्यांच्या को ८६०३२ उसाच्या पानांवर तांबूस लांबट डाग दिसत आहेत. मॅन्कोझेब बुरशीनाशक फवारणी करावी का?',
        descHi:
            '५ महीने के को ८६०३२ गन्ने में भूरे-लाल धब्बे देखे गए हैं। क्या मैंकोजेब कवकनाशी का तुरंत छिड़काव जरूरी है?',
        imagePath: 'assets/images/disease_rust.png',
        likesCount: 24,
        commentsCount: 6,
        isLiked: false,
        isBookmarked: false,
        replies: [
          _PostReply(
            authorName: 'Santosh Ghadge (Phaltan)',
            timeAgo: '1 hr ago',
            textEn:
                'Namaste Ramesh ji. Looks like Rust (तांबेरा). Spray Mancozeb 75% WP @ 2.5g per litre of water. Don\'t delay.',
            textMr:
                'नमस्ते रमेशजी, हा तांबेरा रोग दिसतो आहे. मॅन्कोझेब ७५% डब्ल्यूपी २.५ ग्रॅम प्रति लिटर पाण्यात मिसळून तात्काळ फवारणी करा.',
            textHi:
                'नमस्ते रमेश जी, यह गेरुआ रोग प्रतीत होता है। मैंकोजेब ७५% का २.५ ग्राम प्रति लीटर से छिड़काव करें।',
          ),
          _PostReply(
            authorName: 'Krishi Kendra Karad',
            timeAgo: '45 mins ago',
            textEn:
                'Check if fungal powder is scraping off on your fingers. Maintain clean field borders.',
            textMr:
                'पानांवरील पावडर बोटावर लागते का ते तपासा. सऱ्यांमधील हवा खेळती ठेवा.',
            textHi:
                'जांचें कि क्या पत्तियों से पाउडर उंगलियों पर आ रहा है। खेत साफ रखें।',
          ),
        ],
      ),
      _CommunityPost(
        id: 'post_2',
        authorName: 'Vitthalrao Jadhav',
        locationMr: 'बारामती, पुणे',
        locationHi: 'बारामती, पुणे',
        locationEn: 'Baramati, Pune',
        timeAgoMr: '५ तासांपूर्वी',
        timeAgoHi: '५ घंटे पहले',
        timeAgoEn: '5 hrs ago',
        authorBadgeMr: 'प्रगतिशील शेतकरी',
        authorBadgeHi: 'प्रगतिशील किसान',
        authorBadgeEn: 'Progressive Farmer',
        avatarColor: const Color(0xFF0369A1),
        initials: 'VJ',
        categoryId: 'irrigation',
        titleEn: 'What should I consider when planning drip irrigation for 86032 variety?',
        titleMr: 'ऊस को ८६०३२ जातीसाठी ठिबक सिंचनाचे नियोजन कसे करावे?',
        titleHi: 'गन्ना को ८६०३२ किस्म के लिए ड्रिप सिंचाई की योजना कैसे बनाएं?',
        descEn:
            'Planning to install inline drip tubing with 40cm emitter spacing on a 3-acre paired-row plot. What discharge rate (lph) works best in medium black soil?',
        descMr:
            '३ एकर पट्टा पद्धत क्षेत्रासाठी ४० सेमी अंतरावरील इनलाईन ठिबक बसवायचे आहे. मध्यम काळ्या जमिनीत किती लिटर प्रति तास ड्रिपर वापरावे?',
        descHi:
            '३ एकड़ पट्टा विधि खेत के लिए ४० सेमी दूरी वाली इनलाइन ड्रिप लगानी है। मध्यम काली मिट्टी में कितने एलपीएच का डिस्चार्ज रेट सही रहेगा?',
        imagePath: 'assets/images/care_stage_planting.jpg',
        likesCount: 38,
        commentsCount: 11,
        isLiked: true,
        isBookmarked: true,
        replies: [
          _PostReply(
            authorName: 'Mahesh Kulkarni',
            timeAgo: '4 hrs ago',
            textEn:
                'For medium black soil, 2.4 LPH inline drippers spaced 40cm are ideal. Runs 1.5 to 2 hours daily during summer.',
            textMr:
                'मध्यम काळ्या जमिनीसाठी २.४ लिटर प्रति तास इनलाईन ड्रिपर्स उत्तम आहेत. उन्हाळ्यात दररोज १.५ ते २ तास चालवा.',
            textHi:
                'मध्यम काली मिट्टी के लिए २.४ एलपीएच ड्रिपर्स उपयुक्त हैं। गर्मियों में रोज १.५-२ घंटे चलाएं।',
          ),
        ],
      ),
      _CommunityPost(
        id: 'post_3',
        authorName: 'Dnyaneshwar Patil',
        locationMr: 'वाळवा, सांगली',
        locationHi: 'वालवा, सांगली',
        locationEn: 'Walwa, Sangli',
        timeAgoMr: '१ दिवसापूर्वी',
        timeAgoHi: '१ दिन पहले',
        timeAgoEn: '1 day ago',
        authorBadgeMr: 'प्रगतिशील शेतकरी',
        authorBadgeHi: 'प्रगतिशील किसान',
        authorBadgeEn: 'Progressive Farmer',
        avatarColor: const Color(0xFFB45309),
        initials: 'DP',
        categoryId: 'success',
        titleEn: 'Sharing my experience: Trash mulching reduced weed growth by 80%!',
        titleMr: 'पाचट आच्छादनाचा अनुभव: तण ८०% कमी झाले आणि पाणी वाचले!',
        titleHi: 'सूखी पत्ती मल्चिंग का अनुभव: खरपतवार ८०% कम हुआ और पानी बचा!',
        descEn:
            'Retained all sugarcane dry trash in the furrows after 120 days. Soil moisture remained intact during hot April, and we saved two full irrigation cycles.',
        descMr:
            '१२० दिवसांनंतर सऱ्यांमध्ये सर्व उसाचे पाचट ठेवले. कडक उन्हाळ्यातही जमिनीत ओलावा टिकून राहिला आणि दोन पाण्याच्या पाळ्या वाचल्या.',
        descHi:
            '१२० दिनों के बाद नालियों में पत्तियां बिछा दीं। मिट्टी की नमी बनी रही और दो बार की सिंचाई की बचत हुई।',
        imagePath: 'assets/images/care_stage_land_prep.jpg',
        likesCount: 52,
        commentsCount: 19,
        isLiked: false,
        isBookmarked: false,
        replies: [
          _PostReply(
            authorName: 'Balasaheb Shinde',
            timeAgo: '20 hrs ago',
            textEn:
                'Great practice! Did you also apply urea + single super phosphate over the trash for quick decomposition?',
            textMr:
                'खूप छान प्रयोग! पाचट लवकर कुजण्यासाठी युरिया व सिंगल सुपर फॉस्फेट टाकले होते का?',
            textHi:
                'बहुत बढ़िया प्रयोग! क्या आपने पत्तियों को जल्दी सड़ाने के लिए यूरिया डाला था?',
          ),
        ],
      ),
      _CommunityPost(
        id: 'post_4',
        authorName: 'Balasaheb More',
        locationMr: 'पंढरपूर, सोलापूर',
        locationHi: 'पंढरपुर, सोलापुर',
        locationEn: 'Pandharpur, Solapur',
        timeAgoMr: '१ दिवसापूर्वी',
        timeAgoHi: '१ दिन पहले',
        timeAgoEn: '1 day ago',
        authorBadgeMr: 'ऊस उत्पादक',
        authorBadgeHi: 'गन्ना किसान',
        authorBadgeEn: 'Cane Grower',
        avatarColor: const Color(0xFF6D28D9),
        initials: 'BM',
        categoryId: 'market',
        titleEn: 'Where can I find reliable sugarcane FRP and sugar factory payment updates?',
        titleMr: 'यंदाच्या हंगामात उसाची एफआरपी व कारखान्यांचे चालू दर कोठे समजतील?',
        titleHi: 'इस सीजन में गन्ने का एफआरपी और चीनी मिल के भाव कहां मिलेंगे?',
        descEn:
            'Looking for the latest cane crushing rates and first installment declarations across Solapur and Osmanabad sugar mills.',
        descMr:
            'सोलापूर व उस्मानाबाद साखर कारखान्यांचे चालू गाळप दर आणि पहिल्या हप्त्यांची अधिकृत माहिती हवी आहे.',
        descHi:
            'सोलापुर और उस्मानाबाद चीनी मिलों की पेराई दर और पहली किस्त की घोषणा की जानकारी चाहिए।',
        imagePath: null,
        likesCount: 17,
        commentsCount: 8,
        isLiked: false,
        isBookmarked: false,
        replies: [
          _PostReply(
            authorName: 'Nitin Deshmukh',
            timeAgo: '18 hrs ago',
            textEn:
                'You can check the Maharashtra Sugar Commissioner portal or local Kisan Seva Kendra updates.',
            textMr:
                'महाराष्ट्र साखर आयुक्त पोर्टल किंवा स्थानिक किसान सेवा केंद्राकडून अधिकृत एफआरपी माहिती मिळेल.',
            textHi:
                'महाराष्ट्र चीनी आयुक्त पोर्टल या नजदीकी किसान सेवा केंद्र से जानकारी मिल सकती है।',
          ),
        ],
      ),
      _CommunityPost(
        id: 'post_5',
        authorName: 'Sanjay Gaikwad',
        locationMr: 'राहुरी, अहमदनगर',
        locationHi: 'राहुरी, अहमदनगर',
        locationEn: 'Rahuri, Ahmednagar',
        timeAgoMr: '२ दिवसांपूर्वी',
        timeAgoHi: '२ दिन पहले',
        timeAgoEn: '2 days ago',
        authorBadgeMr: 'प्रगतिशील शेतकरी',
        authorBadgeHi: 'प्रगतिशील किसान',
        authorBadgeEn: 'Verified Cane Grower',
        avatarColor: const Color(0xFF047857),
        initials: 'SG',
        categoryId: 'fertilizers',
        titleEn: 'Is paired row planting (पट्टा पद्धत) effective for intercropping gram?',
        titleMr: 'ऊस पट्टा पद्धतीत हरभरा आंतरपीक घेणे फायदेशीर ठरते का?',
        titleHi: 'गन्ना पट्टा विधि में चना की अंतरफसल लेना फायदेमंद है क्या?',
        descEn:
            'We adopted the 2.5 ft x 5 ft paired row method. Harvested 4 quintals of chickpea without any reduction in cane tiller count.',
        descMr:
            'आम्ही २.५ x ५ फूट पट्टा पद्धत अवलंबिली. उसाच्या फुटव्यांवर कोणताही परिणाम न होता ४ क्विंटल हरभरा उत्पादन मिळाले.',
        descHi:
            'हमने २.५ x ५ फीट पट्टा विधि अपनाई और ४ क्विंटल चना उत्पादन बिना गन्ने की वृद्धि प्रभावित हुए प्राप्त किया।',
        imagePath: 'assets/images/care_stage_growth.jpg',
        likesCount: 31,
        commentsCount: 14,
        isLiked: false,
        isBookmarked: false,
        replies: [
          _PostReply(
            authorName: 'Anil Kadam',
            timeAgo: '1 day ago',
            textEn:
                'Legume intercropping fixes atmospheric nitrogen. Excellent for soil health before earthing up!',
            textMr:
                'कडधान्य आंतरपिकामुळे जमिनीत नत्र स्थिरीकरण होते आणि मातीचा पोत सुधारतो.',
            textHi:
                'दलहनी फसल से नाइट्रोजन बढ़ता है और मिट्टी की सेहत सुधरती है।',
          ),
        ],
      ),
    ];
  }

  // Filtered post list based on search and selected category
  List<_CommunityPost> _getFilteredPosts(AppLanguage lang) {
    return _posts.where((post) {
      final matchesCategory = _selectedCategoryId == 'all' ||
          post.categoryId == _selectedCategoryId;

      final title = post.getTitle(lang).toLowerCase();
      final desc = post.getDescription(lang).toLowerCase();
      final author = post.authorName.toLowerCase();

      final matchesSearch = _searchQuery.isEmpty ||
          title.contains(_searchQuery) ||
          desc.contains(_searchQuery) ||
          author.contains(_searchQuery);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _toggleLike(String postId) {
    setState(() {
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        final current = _posts[index];
        final newIsLiked = !current.isLiked;
        final newCount = newIsLiked ? current.likesCount + 1 : current.likesCount - 1;
        _posts[index] = current.copyWith(
          isLiked: newIsLiked,
          likesCount: newCount,
        );
      }
    });
  }

  void _toggleBookmark(String postId, AppLanguage lang) {
    setState(() {
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        final current = _posts[index];
        final newIsBookmarked = !current.isBookmarked;
        _posts[index] = current.copyWith(isBookmarked: newIsBookmarked);

        final isMr = lang == AppLanguage.marathi;
        final isHi = lang == AppLanguage.hindi;

        final msg = newIsBookmarked
            ? (isMr
                ? 'पोस्ट सेव्ह केली'
                : (isHi ? 'पोस्ट सहेज ली गई' : 'Post saved to bookmarks'))
            : (isMr
                ? 'पोस्ट काढली'
                : (isHi ? 'पोस्ट हटा दी गई' : 'Removed from bookmarks'));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: const Color(0xFF14532D),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  void _openAskQuestionModal(AppLanguage lang) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AskQuestionBottomSheet(
        lang: lang,
        onPostSubmitted: (newPost) {
          setState(() {
            _posts.insert(0, newPost);
            _selectedCategoryId = 'all';
            _searchController.clear();
          });
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
          final isMr = lang == AppLanguage.marathi;
          final isHi = lang == AppLanguage.hindi;
          final successMsg = isMr
              ? 'तुमचा प्रश्न कम्युनिटीत पोस्ट झाला आहे!'
              : (isHi
                  ? 'आपका सवाल समुदाय में पोस्ट हो गया है!'
                  : 'Your question has been posted to the community!');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(successMsg),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF14532D),
              duration: const Duration(seconds: 3),
            ),
          );
        },
      ),
    );
  }

  void _openDiscussionModal(_CommunityPost post, AppLanguage lang) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _DiscussionDetailSheet(
        post: post,
        lang: lang,
        onReplyAdded: (replyText) {
          setState(() {
            final index = _posts.indexWhere((p) => p.id == post.id);
            if (index != -1) {
              final updatedReplies = List<_PostReply>.from(_posts[index].replies)
                ..add(_PostReply(
                  authorName: lang == AppLanguage.marathi
                      ? 'तुम्ही (शेतकरी मित्र)'
                      : (lang == AppLanguage.hindi
                          ? 'आप (किसान भाई)'
                          : 'You (Farmer)'),
                  timeAgo: 'Just now',
                  textEn: replyText,
                  textMr: replyText,
                  textHi: replyText,
                ));
              _posts[index] = _posts[index].copyWith(
                replies: updatedReplies,
                commentsCount: updatedReplies.length,
              );
            }
          });
        },
      ),
    );
  }

  void _showExpertAdviceDialog(AppLanguage lang) {
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final dialogTitle = isMr
        ? 'तज्ञांचे प्रमाणित मार्गदर्शन'
        : (isHi ? 'विशेषज्ञ का प्रमाणित परामर्श' : 'Expert Agronomist Advice');

    final adviceText = isMr
        ? '१. प्रकाश सापळे: पहिल्या पावसाच्या सरीनंतर प्रौढ भुंगेरे अंडी घालण्यापूर्वी पकडण्यासाठी हेक्टरी १ सौर प्रकाश सापळा लावा.\n\n'
          '२. जैविक नियंत्रण: लागवडीवेळी किंवा मोठ्या बांधणीवेळी मेटारायझियम / बिव्हेरिया बुरशी ५ किलो प्रति एकर शेणखतात मिसळून द्या.\n\n'
          '३. रासायनिक नियंत्रण: प्रादुर्भाव जास्त असल्यास क्लोरपायरीफॉस २०% ईसी किंवा फिप्रोनिल दाणेदार मुळांच्या कक्षेत द्या.'
        : (isHi
            ? '१. प्रकाश प्रपंच: मानसून की पहली बारिश के बाद वयस्क भृंग पकड़ने हेतु प्रति हेक्टेयर १ सोलर लाइट ट्रैप लगाएं।\n\n'
              '२. जैविक नियंत्रण: रोपाई या मिट्टी चढ़ाते समय मेटाराइजियम ५ किलो/एकड़ सड़े गोबर खाद में मिलाकर दें।\n\n'
              '३. रासायनिक नियंत्रण: अत्यधिक प्रकोप पर क्लोरपायरीफॉस का जड़ क्षेत्र में प्रयोग करें।'
            : '1. Light Traps: Install 1 solar light trap per 2 hectares immediately after the first monsoon showers.\n\n'
              '2. Biological Control: Apply Metarhizium anisopliae @ 5 kg/acre enriched with FYM at planting or earthing up.\n\n'
              '3. Chemical Control: Drenching with Chlorpyrifos 20% EC in root zone if severe.');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.verified_rounded,
                  color: Color(0xFF16A34A), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                dialogTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF14532D),
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAF7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2EBE0)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. Anand Patil (Ph.D. Sugarcane Pathology)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'Vasantdada Sugar Institute (VSI), Manjari, Pune',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                isMr
                    ? 'विषय: हुमणी अळीचे एकात्मिक व्यवस्थापन'
                    : (isHi
                        ? 'विषय: सफेद लट का एकीकृत प्रबंधन'
                        : 'Topic: White Grub Integrated Management'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF14532D),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                adviceText,
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.5,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              isMr ? 'बंद करा' : (isHi ? 'बंद करें' : 'Close'),
              style: const TextStyle(
                color: Color(0xFF14532D),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final lang = loc.language;
    final filtered = _getFilteredPosts(lang);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF7),
      appBar: _buildAppBar(lang),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Welcome Banner
            _buildWelcomeBanner(lang),

            const SizedBox(height: 16),

            // 2. Search Bar
            _buildSearchBar(lang),

            const SizedBox(height: 16),

            // 3. Horizontally Scrollable Topic Filter Chips
            _buildTopicFilterChips(lang),

            const SizedBox(height: 16),

            // 4. Compact Expert Answer Preview Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _buildExpertAnswerCard(lang),
            ),

            const SizedBox(height: 20),

            // 5. Popular Topics Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _buildPopularTopicsSection(lang),
            ),

            const SizedBox(height: 20),

            // 6. Discussion Feed Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        lang == AppLanguage.marathi
                            ? 'शेतकरी चर्चा फीड'
                            : (lang == AppLanguage.hindi
                                ? 'किसान चर्चा फीड'
                                : 'Community Feed'),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF14532D),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${filtered.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 7. Community Discussion Cards
            if (filtered.isEmpty)
              _buildEmptyState(lang)
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return _buildDiscussionCard(filtered[index], lang);
                },
              ),

            const SizedBox(height: 90),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(lang),
    );
  }

  // ==========================================
  // APP BAR
  // ==========================================
  PreferredSizeWidget _buildAppBar(AppLanguage lang) {
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final title = isMr
        ? 'शेतकरी कम्युनिटी'
        : (isHi ? 'किसान समुदाय' : 'Farmer Community');

    final subtitle = isMr
        ? 'एकत्र शिका. एकत्र वाढा. 🌱'
        : (isHi
            ? 'साथ सीखें। साथ बढ़ें। 🌱'
            : 'Learn together. Grow together. 🌱');

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Color(0xFF14532D),
          size: 24,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF14532D),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF16A34A),
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF14532D),
                size: 24,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                );
              },
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // ==========================================
  // 1. WELCOME BANNER
  // ==========================================
  Widget _buildWelcomeBanner(AppLanguage lang) {
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final badge = isMr
        ? 'महाराष्ट्र ऊस उत्पादक शेतकरी'
        : (isHi ? 'महाराष्ट्र गन्ना किसान' : 'Maharashtra Sugarcane Farmers');

    final heading = isMr
        ? 'तुमची शेतकरी कम्युनिटी'
        : (isHi ? 'आपका किसान समुदाय' : 'Your Farming Community');

    final desc = isMr
        ? 'प्रश्न विचारा, अनुभव शेअर करा आणि इतर शेतकरी बांधवांकडून शिका.'
        : (isHi
            ? 'सवाल पूछें, अनुभव साझा करें और साथी किसानों से सीखें।'
            : 'Ask questions, share experiences, and learn from fellow farmers.');

    final btn = isMr ? 'प्रश्न विचारा' : (isHi ? 'सवाल पूछें' : 'Ask a Question');

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 14, 18, 0),
      decoration: BoxDecoration(
        color: const Color(0xFF14532D),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF14532D).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16A34A).withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFDCFCE7).withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.groups_rounded,
                            color: Color(0xFFDCFCE7), size: 14),
                        const SizedBox(width: 5),
                        Text(
                          badge,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFDCFCE7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    heading,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Color(0xFFF3F4F6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _openAskQuestionModal(lang),
                    icon: const Icon(Icons.add_circle_outline_rounded,
                        color: Color(0xFF14532D), size: 18),
                    label: Text(
                      btn,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14532D),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF14532D),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 2. SEARCH BAR
  // ==========================================
  Widget _buildSearchBar(AppLanguage lang) {
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final hint = isMr
        ? 'शेतीविषयक प्रश्न किंवा विषय शोधा…'
        : (isHi
            ? 'खेती से जुड़े सवाल या विषय खोजें…'
            : 'Search farming questions or topics…');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2EBE0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF9CA3AF),
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF16A34A),
              size: 22,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded,
                        color: Color(0xFF6B7280), size: 18),
                    onPressed: () => _searchController.clear(),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 3. TOPIC FILTERS
  // ==========================================
  Widget _buildTopicFilterChips(AppLanguage lang) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategoryId == cat['id'];

          final label = lang == AppLanguage.marathi
              ? cat['mr']!
              : (lang == AppLanguage.hindi ? cat['hi']! : cat['en']!);

          return InkWell(
            onTap: () {
              setState(() {
                _selectedCategoryId = cat['id']!;
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF14532D) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF14532D)
                      : const Color(0xFFE2EBE0),
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF14532D).withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight:
                      isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF374151),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // 4. EXPERT ANSWER PREVIEW CARD
  // ==========================================
  Widget _buildExpertAnswerCard(AppLanguage lang) {
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final badge = isMr
        ? 'प्रमाणित तज्ञांचे उत्तर'
        : (isHi ? 'प्रमाणित विशेषज्ञ का उत्तर' : 'VERIFIED EXPERT ANSWER (तज्ञांचे उत्तर)');

    final question = isMr
        ? 'प्रश्न: सुरुवातीच्या खोडकिडीपासून (Shoot Borer) लहान उसाचे संरक्षण कसे करावे?'
        : (isHi
            ? 'प्रश्न: शुरुआती तना छेदक से छोटे पौधों को कैसे बचाएं?'
            : 'Q: How to protect young sugarcane shoots from early Shoot Borer (खोडकीड)?');

    final answer = isMr
        ? '“४५ दिवसांनी उसाला हलकी भर द्यावी व पाणी द्यावे. यामुळे खोडकिडीची अंडी दबली जातात. ट्रायकोकार्डचे परोपजीवी कीटक दर आठवड्याला सोडावेत.”'
        : (isHi
            ? '“४५ दिनों पर हल्की मिट्टी चढ़ाएं और पानी दें। ट्राइकोग्रामा परजीवी कार्ड का प्रयोग करें।”'
            : '“Earthing up at 45 days along with light irrigation suppresses shoot borer eggs. Release Trichogramma chilonis egg parasitoids @ 20,000/acre weekly.”');

    final btn = isMr
        ? 'संपूर्ण तज्ञ सल्ला पहा'
        : (isHi ? 'पूरा परामर्श पढ़ें' : 'Read Full Expert Advice & Recommendations');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBBF7D0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF16A34A).withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded,
                        color: Color(0xFF16A34A), size: 14),
                    const SizedBox(width: 4),
                    Text(
                      badge,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14532D),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Text(
                'Featured',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF16A34A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFDCFCE7),
                child: Text(
                  'AP',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14532D),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. Anand Patil (VSI Pune)',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'Senior Sugarcane Agronomist • Verified Expert',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            question,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF14532D),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.45,
              color: Color(0xFF374151),
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 12),
          InkWell(
            onTap: () => _showExpertAdviceDialog(lang),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  btn,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF16A34A),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: Color(0xFF16A34A),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 5. POPULAR TOPICS SECTION
  // ==========================================
  Widget _buildPopularTopicsSection(AppLanguage lang) {
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final heading = isMr
        ? 'लोकप्रिय विषय'
        : (isHi ? 'लोकप्रिय विषय' : 'Popular Topics');

    final topics = isMr
        ? [
            'तांबेरा रोग (Rust)',
            'ठिबक सिंचन नियोजन',
            'खत व पोषण व्यवस्थापन',
            'हुमणी अळी नियंत्रण',
            'ऊस बाजार भाव (FRP)',
          ]
        : (isHi
            ? [
                'गेरुआ रोग प्रबंधन',
                'ड्रिप सिंचाई योजना',
                'उर्वरक प्रबंधन',
                'सफेद लट नियंत्रण',
                'गन्ना बाजार भाव (FRP)',
              ]
            : [
                'Red Rot Awareness',
                'Water Management',
                'Crop Nutrition',
                'Pest Monitoring',
                'Sugarcane Market Trends',
              ]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.trending_up_rounded,
                color: Color(0xFF14532D), size: 18),
            const SizedBox(width: 6),
            Text(
              heading,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF14532D),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: topics.map((topic) {
            return InkWell(
              onTap: () {
                _searchController.text = topic.split(' ')[0];
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2EBE0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '#',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      topic,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ==========================================
  // 6. DISCUSSION CARD
  // ==========================================
  Widget _buildDiscussionCard(_CommunityPost post, AppLanguage lang) {
    final title = post.getTitle(lang);
    final desc = post.getDescription(lang);
    final location = post.getLocation(lang);
    final timeAgo = post.getTimeAgo(lang);
    final badge = post.getBadge(lang);

    final viewDiscussionText = lang == AppLanguage.marathi
        ? 'चर्चा पहा'
        : (lang == AppLanguage.hindi ? 'चर्चा देखें' : 'View Discussion (चर्चा पहा)');

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2EBE0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header: Avatar, Name, Location, Time, Bookmark
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 10, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: post.avatarColor,
                  child: Text(
                    post.initials,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              post.authorName,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1F2937),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (badge != null) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                badge,
                                style: const TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF14532D),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            location,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const Text(' • ',
                              style: TextStyle(color: Color(0xFF9CA3AF))),
                          Text(
                            timeAgo,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Bookmark action
                IconButton(
                  icon: Icon(
                    post.isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: post.isBookmarked
                        ? const Color(0xFF16A34A)
                        : const Color(0xFF9CA3AF),
                    size: 22,
                  ),
                  onPressed: () => _toggleBookmark(post.id, lang),
                  splashRadius: 18,
                ),
              ],
            ),
          ),

          // Question Title
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF14532D),
                letterSpacing: -0.2,
              ),
            ),
          ),

          // Description snippet
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 0),
            child: Text(
              desc,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: Color(0xFF4B5563),
              ),
            ),
          ),

          // Optional Crop Image
          if (post.imagePath != null) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  post.imagePath!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 100,
                    color: const Color(0xFFDCFCE7),
                    child: const Center(
                      child: Icon(Icons.broken_image_rounded,
                          color: Color(0xFF16A34A)),
                    ),
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),

          // Actions row: Like, Comments, View Discussion
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                // Like Button
                InkWell(
                  onTap: () => _toggleLike(post.id),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      children: [
                        Icon(
                          post.isLiked
                              ? Icons.thumb_up_rounded
                              : Icons.thumb_up_outlined,
                          size: 16,
                          color: post.isLiked
                              ? const Color(0xFF16A34A)
                              : const Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${post.likesCount}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: post.isLiked
                                ? const Color(0xFF16A34A)
                                : const Color(0xFF4B5563),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Comment Button
                InkWell(
                  onTap: () => _openDiscussionModal(post, lang),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 16,
                          color: Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${post.commentsCount}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // View Discussion Action
                TextButton(
                  onPressed: () => _openDiscussionModal(post, lang),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        viewDiscussionText,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF14532D),
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: Color(0xFF14532D),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // EMPTY STATE
  // ==========================================
  Widget _buildEmptyState(AppLanguage lang) {
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final title = isMr
        ? 'कोणतीही पोस्ट आढळली नाही'
        : (isHi ? 'कोई पोस्ट नहीं मिली' : 'No posts found');

    final desc = isMr
        ? 'या विषयात पोस्ट नाही. तुम्ही पहिला प्रश्न विचारू शकता!'
        : (isHi
            ? 'इस विषय में कोई पोस्ट नहीं है। आप पहला सवाल पूछ सकते हैं!'
            : 'No questions in this topic yet. Be the first to ask!');

    final resetBtn = isMr ? 'फिल्टर्स पूर्ववत करा' : (isHi ? 'रीसेट करें' : 'Reset Filters');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EBE0)),
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 36,
                color: Color(0xFF16A34A),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF14532D),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _selectedCategoryId = 'all';
                  _searchController.clear();
                });
              },
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: Text(resetBtn),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF14532D),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // FLOATING ACTION BUTTON
  // ==========================================
  Widget _buildFloatingActionButton(AppLanguage lang) {
    final isMr = lang == AppLanguage.marathi;
    final isHi = lang == AppLanguage.hindi;

    final btnText = isMr
        ? 'प्रश्न विचारा'
        : (isHi ? 'सवाल पूछें' : 'Ask Question (प्रश्न विचारा)');

    return FloatingActionButton.extended(
      onPressed: () => _openAskQuestionModal(lang),
      backgroundColor: const Color(0xFF14532D),
      elevation: 4,
      icon: const Icon(Icons.add_rounded, color: Colors.white),
      label: Text(
        btnText,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ==========================================
// BOTTOM SHEET: ASK A QUESTION
// ==========================================
class _AskQuestionBottomSheet extends StatefulWidget {
  final AppLanguage lang;
  final ValueChanged<_CommunityPost> onPostSubmitted;

  const _AskQuestionBottomSheet({
    required this.lang,
    required this.onPostSubmitted,
  });

  @override
  State<_AskQuestionBottomSheet> createState() =>
      _AskQuestionBottomSheetState();
}

class _AskQuestionBottomSheetState extends State<_AskQuestionBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _selectedCategory = 'Crop Diseases';
  bool _hasAttachedImage = false;

  final List<String> _topics = [
    'Crop Diseases',
    'Irrigation',
    'Fertilizers',
    'Market Updates',
    'Success Stories',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isEmpty) {
      final isMr = widget.lang == AppLanguage.marathi;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isMr ? 'कृपया प्रश्न लिहा' : 'Please enter a question title'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
      return;
    }

    final newPost = _CommunityPost(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      authorName: 'Rahan (Farmer)',
      locationMr: 'महाराष्ट्र, भारत',
      locationHi: 'महाराष्ट्र, भारत',
      locationEn: 'Maharashtra, India',
      timeAgoMr: 'आत्ताच',
      timeAgoHi: 'अभी-अभी',
      timeAgoEn: 'Just now',
      authorBadgeMr: 'प्रगतिशील शेतकरी',
      authorBadgeHi: 'प्रगतिशील किसान',
      authorBadgeEn: 'Progressive Farmer',
      avatarColor: const Color(0xFF16A34A),
      initials: 'RF',
      categoryId: 'diseases',
      titleEn: title,
      titleMr: title,
      titleHi: title,
      descEn: desc.isNotEmpty ? desc : title,
      descMr: desc.isNotEmpty ? desc : title,
      descHi: desc.isNotEmpty ? desc : title,
      imagePath: _hasAttachedImage ? 'assets/images/care_stage_growth.jpg' : null,
      likesCount: 1,
      commentsCount: 0,
      isLiked: true,
      isBookmarked: false,
      replies: [],
    );

    Navigator.pop(context);
    widget.onPostSubmitted(newPost);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isMr = widget.lang == AppLanguage.marathi;
    final isHi = widget.lang == AppLanguage.hindi;

    final modalTitle = isMr
        ? 'कम्युनिटीला प्रश्न विचारा'
        : (isHi ? 'समुदाय से सवाल पूछें' : 'Ask the Farming Community');

    final topicLabel = isMr ? 'विषय निवडा' : (isHi ? 'विषय चुनें' : 'Select Topic');
    final titleLabel = isMr ? 'प्रश्नाचे शीर्षक' : (isHi ? 'सवाल का शीर्षक' : 'Question Title');
    final descLabel = isMr ? 'सविस्तर माहिती' : (isHi ? 'विस्तृत विवरण' : 'Detailed Description');

    final attachLabel = _hasAttachedImage
        ? (isMr ? 'उसाचा फोटो जोडला' : 'फोटो संलग्न किया गया')
        : (isMr ? 'उसाचा फोटो जोडा' : 'Attach crop photo');

    final submitBtn = isMr
        ? 'प्रश्न पोस्ट करा'
        : (isHi ? 'सवाल पोस्ट करें' : 'Post Question to Community');

    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.help_outline_rounded,
                    color: Color(0xFF14532D),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    modalTitle,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF14532D),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF6B7280)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              topicLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2EBE0)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF14532D)),
                  items: _topics.map((t) {
                    return DropdownMenuItem(
                      value: t,
                      child: Text(
                        t,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedCategory = val);
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 14),

            Text(
              titleLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: isMr
                    ? 'उदा. मध्यम जमिनीत मुळांचा सड रोखण्यासाठी काय करावे?'
                    : 'e.g. How to prevent root rot in heavy black soil?',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9CA3AF),
                ),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2EBE0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2EBE0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Color(0xFF16A34A), width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
              ),
            ),

            const SizedBox(height: 14),

            Text(
              descLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: isMr
                    ? 'उसाचे वय, जात (उदा. ८६०३२), मातीचा प्रकार व लक्षणे लिहा...'
                    : 'Share crop age, variety, soil type and symptoms observed...',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9CA3AF),
                ),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2EBE0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2EBE0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Color(0xFF16A34A), width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
              ),
            ),

            const SizedBox(height: 14),

            InkWell(
              onTap: () {
                setState(() => _hasAttachedImage = !_hasAttachedImage);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: _hasAttachedImage
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _hasAttachedImage
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFE2EBE0),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _hasAttachedImage
                          ? Icons.check_circle_rounded
                          : Icons.add_photo_alternate_outlined,
                      color: _hasAttachedImage
                          ? const Color(0xFF16A34A)
                          : const Color(0xFF6B7280),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        attachLabel,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: _hasAttachedImage
                              ? const Color(0xFF14532D)
                              : const Color(0xFF4B5563),
                        ),
                      ),
                    ),
                    if (_hasAttachedImage)
                      const Icon(Icons.close_rounded,
                          color: Color(0xFF14532D), size: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 18),
                label: Text(
                  submitBtn,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF14532D),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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

// ==========================================
// BOTTOM SHEET: DISCUSSION DETAIL & REPLIES
// ==========================================
class _DiscussionDetailSheet extends StatefulWidget {
  final _CommunityPost post;
  final AppLanguage lang;
  final ValueChanged<String> onReplyAdded;

  const _DiscussionDetailSheet({
    required this.post,
    required this.lang,
    required this.onReplyAdded,
  });

  @override
  State<_DiscussionDetailSheet> createState() => _DiscussionDetailSheetState();
}

class _DiscussionDetailSheetState extends State<_DiscussionDetailSheet> {
  final TextEditingController _replyController = TextEditingController();

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _submitReply() {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;
    widget.onReplyAdded(text);
    _replyController.clear();
    Navigator.pop(context);
    final isMr = widget.lang == AppLanguage.marathi;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isMr ? 'तुमचे उत्तर जोडले गेले!' : 'Your reply has been added!'),
        backgroundColor: const Color(0xFF14532D),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isMr = widget.lang == AppLanguage.marathi;

    final title = widget.post.getTitle(widget.lang);
    final desc = widget.post.getDescription(widget.lang);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 14, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.forum_rounded,
                      color: Color(0xFF14532D), size: 18),
                ),
                const SizedBox(width: 8),
                Text(
                  isMr ? 'शेतकरी चर्चा' : 'Discussion',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14532D),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2EBE0)),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: widget.post.avatarColor,
                      child: Text(
                        widget.post.initials,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.authorName,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        Text(
                          '${widget.post.getLocation(widget.lang)} • ${widget.post.getTimeAgo(widget.lang)}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14532D),
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: Color(0xFF374151),
                  ),
                ),

                if (widget.post.imagePath != null) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      widget.post.imagePath!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                const Divider(color: Color(0xFFE2EBE0)),
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline_rounded,
                        color: Color(0xFF14532D), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      isMr
                          ? 'शेतकऱ्यांची उत्तरे (${widget.post.replies.length})'
                          : 'Farmer Replies (${widget.post.replies.length})',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14532D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                ...widget.post.replies.map((reply) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAF7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2EBE0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              reply.authorName,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF14532D),
                              ),
                            ),
                            Text(
                              reply.timeAgo,
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reply.getText(widget.lang),
                          style: const TextStyle(
                            fontSize: 12.5,
                            height: 1.4,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2EBE0))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: InputDecoration(
                      hintText: isMr
                          ? 'तुमचे उत्तर किंवा सल्ला लिहा...'
                          : 'Write your advice or answer...',
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9CA3AF),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: Color(0xFFE2EBE0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: Color(0xFFE2EBE0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            color: Color(0xFF16A34A), width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _submitReply,
                  icon: const Icon(Icons.send_rounded),
                  color: const Color(0xFF14532D),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFDCFCE7),
                    padding: const EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// MULTILINGUAL MODELS
// ==========================================
class _CommunityPost {
  final String id;
  final String authorName;
  final String locationMr;
  final String locationHi;
  final String locationEn;
  final String timeAgoMr;
  final String timeAgoHi;
  final String timeAgoEn;
  final String? authorBadgeMr;
  final String? authorBadgeHi;
  final String? authorBadgeEn;
  final Color avatarColor;
  final String initials;
  final String categoryId;
  final String titleEn;
  final String titleMr;
  final String titleHi;
  final String descEn;
  final String descMr;
  final String descHi;
  final String? imagePath;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final bool isBookmarked;
  final List<_PostReply> replies;

  _CommunityPost({
    required this.id,
    required this.authorName,
    required this.locationMr,
    required this.locationHi,
    required this.locationEn,
    required this.timeAgoMr,
    required this.timeAgoHi,
    required this.timeAgoEn,
    this.authorBadgeMr,
    this.authorBadgeHi,
    this.authorBadgeEn,
    required this.avatarColor,
    required this.initials,
    required this.categoryId,
    required this.titleEn,
    required this.titleMr,
    required this.titleHi,
    required this.descEn,
    required this.descMr,
    required this.descHi,
    this.imagePath,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.isBookmarked,
    required this.replies,
  });

  String getTitle(AppLanguage lang) {
    if (lang == AppLanguage.marathi) return titleMr;
    if (lang == AppLanguage.hindi) return titleHi;
    return titleEn;
  }

  String getDescription(AppLanguage lang) {
    if (lang == AppLanguage.marathi) return descMr;
    if (lang == AppLanguage.hindi) return descHi;
    return descEn;
  }

  String getLocation(AppLanguage lang) {
    if (lang == AppLanguage.marathi) return locationMr;
    if (lang == AppLanguage.hindi) return locationHi;
    return locationEn;
  }

  String getTimeAgo(AppLanguage lang) {
    if (lang == AppLanguage.marathi) return timeAgoMr;
    if (lang == AppLanguage.hindi) return timeAgoHi;
    return timeAgoEn;
  }

  String? getBadge(AppLanguage lang) {
    if (lang == AppLanguage.marathi) return authorBadgeMr;
    if (lang == AppLanguage.hindi) return authorBadgeHi;
    return authorBadgeEn;
  }

  _CommunityPost copyWith({
    String? id,
    String? authorName,
    String? locationMr,
    String? locationHi,
    String? locationEn,
    String? timeAgoMr,
    String? timeAgoHi,
    String? timeAgoEn,
    String? authorBadgeMr,
    String? authorBadgeHi,
    String? authorBadgeEn,
    Color? avatarColor,
    String? initials,
    String? categoryId,
    String? titleEn,
    String? titleMr,
    String? titleHi,
    String? descEn,
    String? descMr,
    String? descHi,
    String? imagePath,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    bool? isBookmarked,
    List<_PostReply>? replies,
  }) {
    return _CommunityPost(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      locationMr: locationMr ?? this.locationMr,
      locationHi: locationHi ?? this.locationHi,
      locationEn: locationEn ?? this.locationEn,
      timeAgoMr: timeAgoMr ?? this.timeAgoMr,
      timeAgoHi: timeAgoHi ?? this.timeAgoHi,
      timeAgoEn: timeAgoEn ?? this.timeAgoEn,
      authorBadgeMr: authorBadgeMr ?? this.authorBadgeMr,
      authorBadgeHi: authorBadgeHi ?? this.authorBadgeHi,
      authorBadgeEn: authorBadgeEn ?? this.authorBadgeEn,
      avatarColor: avatarColor ?? this.avatarColor,
      initials: initials ?? this.initials,
      categoryId: categoryId ?? this.categoryId,
      titleEn: titleEn ?? this.titleEn,
      titleMr: titleMr ?? this.titleMr,
      titleHi: titleHi ?? this.titleHi,
      descEn: descEn ?? this.descEn,
      descMr: descMr ?? this.descMr,
      descHi: descHi ?? this.descHi,
      imagePath: imagePath ?? this.imagePath,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      replies: replies ?? this.replies,
    );
  }
}

class _PostReply {
  final String authorName;
  final String timeAgo;
  final String textEn;
  final String textMr;
  final String textHi;

  _PostReply({
    required this.authorName,
    required this.timeAgo,
    required this.textEn,
    required this.textMr,
    required this.textHi,
  });

  String getText(AppLanguage lang) {
    if (lang == AppLanguage.marathi) return textMr;
    if (lang == AppLanguage.hindi) return textHi;
    return textEn;
  }
}
