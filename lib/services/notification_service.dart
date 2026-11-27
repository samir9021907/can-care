import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_notification.dart';
import '../constants/api_constants.dart';
import 'api_client.dart';

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const String _storageKey = 'cancare_clean_notifications_v2';

  final List<AppNotification> _notifications = [];
  bool _initialized = false;

  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> init() async {
    if (_initialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedJson = prefs.getString(_storageKey);
      if (storedJson != null && storedJson.isNotEmpty) {
        final List decoded = jsonDecode(storedJson);
        _notifications.clear();
        for (final item in decoded) {
          _notifications.add(AppNotification.fromJson(item));
        }
      } else {
        // Seed clean standard sugarcane notifications
        _seedDefaultNotifications();
        await _persist();
      }
    } catch (e) {
      debugPrint('NotificationService init error: $e');
      if (_notifications.isEmpty) {
        _seedDefaultNotifications();
      }
    }

    _initialized = true;
    notifyListeners();
    fetchRemoteNotifications();
  }

  Future<void> fetchRemoteNotifications() async {
    try {
      final res = await ApiClient().get(ApiConstants.notifications);
      List? rawList;
      if (res is Map && res['notifications'] is List) {
        rawList = res['notifications'] as List;
      } else if (res is List) {
        rawList = res;
      }
      if (rawList != null && rawList.isNotEmpty) {
        final readIds =
            _notifications.where((n) => n.isRead).map((n) => n.id).toSet();
        final fetched = <AppNotification>[];
        for (final item in rawList) {
          if (item is Map) {
            final notif =
                AppNotification.fromJson(Map<String, dynamic>.from(item));
            if (readIds.contains(notif.id)) {
              notif.isRead = true;
            }
            fetched.add(notif);
          }
        }
        if (fetched.isNotEmpty) {
          _notifications.clear();
          _notifications.addAll(fetched);
          await _persist();
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('[NotificationService] fetchRemoteNotifications: $e');
    }
  }

  void _seedDefaultNotifications() {
    final now = DateTime.now();
    _notifications.addAll([
      AppNotification(
        id: 'notif_report_ready_1',
        title: 'Crop Health Report Ready',
        titleMarathi: 'ऊस पीक आरोग्य अहवाल तयार आहे',
        titleHindi: 'फसल स्वास्थ्य रिपोर्ट तैयार है',
        body: 'Your 1-page Sugarcane Diagnostic & Prescription Report is saved and ready to download.',
        bodyMarathi: 'तुमच्या शेताचा १ पानाचा अचूक निदान व फवारणी अहवाल तयार आहे. येथून डाउनलोड करा.',
        bodyHindi: 'आपकी फसल की १ पेज की निदान और छिड़काव रिपोर्ट तैयार है। यहां से डाउनलोड करें।',
        category: NotificationCategory.tips,
        importance: NotificationImportance.normal,
        timestamp: now.subtract(const Duration(minutes: 25)),
        isRead: false,
        actionRoute: 'report',
        actionLabel: 'View Report',
        actionLabelMarathi: 'अहवाल पाहा',
      ),
      AppNotification(
        id: 'notif_weather_update_2',
        title: 'Today\'s Weather: Ideal for Spraying',
        titleMarathi: 'आजचे हवामान: फवारणीसाठी उत्तम दिवस',
        titleHindi: 'आज का मौसम: छिड़काव के लिए अनुकूल',
        body: 'Temperature is 28°C with gentle breeze. Clear skies favorable for foliar spray before 11 AM.',
        bodyMarathi: 'तापमान २८° से. असून निरभ्र आकाश आहे. सकाळी ११ पूर्वी फवारणी करणे अत्यंत फायदेशीर ठरेल.',
        bodyHindi: 'तापमान २८° से. और मौसम साफ है। सुबह ११ बजे से पहले छिड़काव करना उपयुक्त रहेगा।',
        category: NotificationCategory.weather,
        importance: NotificationImportance.normal,
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
        actionRoute: 'weather',
        actionLabel: 'Check Weather',
        actionLabelMarathi: 'हवामान पाहा',
      ),
      AppNotification(
        id: 'notif_scan_reminder_3',
        title: 'Plot #2: Treatment Progress Check',
        titleMarathi: 'प्लॉट क्र. २: फेरतपासणीची वेळ झाली आहे',
        titleHindi: 'प्लॉट नं. २: पुनः जांच का समय',
        body: '7 days have passed since the last spray. Scan a leaf today to verify crop recovery.',
        bodyMarathi: 'मागील फवारणीला ७ दिवस पूर्ण झाले आहेत. आज नवीन फोटो स्कॅन करून पिकाची सुधारणा तपासा.',
        bodyHindi: 'पिछली दवा छिड़काव के ७ दिन पूरे हो गए। फसल सुधार जांचने के लिए आज पत्ती स्कैन करें।',
        category: NotificationCategory.reminder,
        importance: NotificationImportance.normal,
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: false,
        actionRoute: 'scan',
        actionLabel: 'Scan Leaf',
        actionLabelMarathi: 'पान स्कॅन करा',
      ),
      AppNotification(
        id: 'notif_market_rate_4',
        title: 'Sugarcane FRP & Sugar Mill Rate Update',
        titleMarathi: 'ऊस हमीभाव (FRP) दर अपडेट',
        titleHindi: 'गन्ना एफआरपी दर अपडेट',
        body: 'Local cooperative sugar factories announced advance of ₹3,150 per ton for crushing season.',
        bodyMarathi: 'परिसरातील साखर कारखान्यांनी गाळप हंगामासाठी प्रति टन ₹३,१५० पहिली उचल जाहीर केली.',
        bodyHindi: 'चीनी मिलों ने पेराई सीजन के लिए प्रति टन ₹३,१५० पहली किस्त की घोषणा की।',
        category: NotificationCategory.market,
        importance: NotificationImportance.normal,
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
        actionRoute: 'community',
        actionLabel: 'Community',
        actionLabelMarathi: 'चर्चा पाहा',
      ),
      AppNotification(
        id: 'notif_agronomy_tip_5',
        title: 'Sugarcane Care Tip: Earthing Up Nutrition',
        titleMarathi: 'नवीन पीक सल्ला: मोठ्या बांधणीचे खत',
        titleHindi: 'फसल सलाह: मिट्टी चढ़ाई और पोषण',
        body: 'Apply Potash (00:00:50) @ 50 kg/acre during final earthing up to improve cane weight and sugar recovery.',
        bodyMarathi: 'मोठ्या बांधणीच्या वेळी एकरी ५० किलो पोटॅश (००:००:५०) द्या; यामुळे उसाचे वजन व साखर उतारा वाढतो.',
        bodyHindi: 'मिट्टी चढ़ाई के समय ५० किलो पोटाश प्रति एकड़ दें; इससे गन्ने का वजन और मिठास बढ़ती है।',
        category: NotificationCategory.tips,
        importance: NotificationImportance.low,
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
        actionRoute: 'care_guide',
        actionLabel: 'Care Guide',
        actionLabelMarathi: 'मार्गदर्शक पाहा',
      ),
    ]);
  }

  Future<void> markAsRead(String id) async {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1 && !_notifications[idx].isRead) {
      _notifications[idx].isRead = true;
      notifyListeners();
      await _persist();
    }
  }

  Future<void> markAllAsRead() async {
    bool hasUnread = false;
    for (final n in _notifications) {
      if (!n.isRead) {
        n.isRead = true;
        hasUnread = true;
      }
    }
    if (hasUnread) {
      notifyListeners();
      await _persist();
    }
  }

  Future<void> deleteNotification(String id) async {
    final initialLen = _notifications.length;
    _notifications.removeWhere((n) => n.id == id);
    if (_notifications.length != initialLen) {
      notifyListeners();
      await _persist();
    }
  }

  Future<void> clearAll() async {
    if (_notifications.isNotEmpty) {
      _notifications.clear();
      notifyListeners();
      await _persist();
    }
  }

  Future<void> addNotification(AppNotification notification) async {
    _notifications.insert(0, notification);
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_notifications.map((n) => n.toJson()).toList());
      await prefs.setString(_storageKey, encoded);
    } catch (e) {
      debugPrint('Notification persist error: $e');
    }
  }
}
