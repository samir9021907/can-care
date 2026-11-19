import 'package:flutter/material.dart';

enum NotificationCategory {
  alert,
  weather,
  reminder,
  market,
  tips,
}

enum NotificationImportance {
  high,
  normal,
  low,
}

class AppNotification {
  final String id;
  final String title;
  final String titleMarathi;
  final String titleHindi;
  final String body;
  final String bodyMarathi;
  final String bodyHindi;
  final NotificationCategory category;
  final NotificationImportance importance;
  final DateTime timestamp;
  bool isRead;
  final String? actionRoute;
  final String? actionLabel;
  final String? actionLabelMarathi;

  AppNotification({
    required this.id,
    required this.title,
    required this.titleMarathi,
    required this.titleHindi,
    required this.body,
    required this.bodyMarathi,
    required this.bodyHindi,
    required this.category,
    this.importance = NotificationImportance.normal,
    required this.timestamp,
    this.isRead = false,
    this.actionRoute,
    this.actionLabel,
    this.actionLabelMarathi,
  });

  IconData get iconData {
    switch (category) {
      case NotificationCategory.weather:
        return Icons.cloud_outlined;
      case NotificationCategory.alert:
        return Icons.warning_amber_rounded;
      case NotificationCategory.reminder:
        return Icons.alarm_rounded;
      case NotificationCategory.market:
        return Icons.trending_up_rounded;
      case NotificationCategory.tips:
        return Icons.eco_outlined;
    }
  }

  Color get categoryColor {
    switch (category) {
      case NotificationCategory.weather:
        return const Color(0xFF0284C7); // Sky blue
      case NotificationCategory.alert:
        return const Color(0xFFDC2626); // Alert red
      case NotificationCategory.reminder:
        return const Color(0xFFD97706); // Amber
      case NotificationCategory.market:
        return const Color(0xFF16A34A); // Green
      case NotificationCategory.tips:
        return const Color(0xFF0F766E); // Teal
    }
  }

  Color get categoryBgColor {
    switch (category) {
      case NotificationCategory.weather:
        return const Color(0xFFE0F2FE);
      case NotificationCategory.alert:
        return const Color(0xFFFEE2E2);
      case NotificationCategory.reminder:
        return const Color(0xFFFEF3C7);
      case NotificationCategory.market:
        return const Color(0xFFDCFCE7);
      case NotificationCategory.tips:
        return const Color(0xFFCCFBF1);
    }
  }

  String getCategoryLabel(String languageCode) {
    if (languageCode == 'mr') {
      switch (category) {
        case NotificationCategory.weather:
          return 'हवामान';
        case NotificationCategory.alert:
          return 'धोका अलर्ट';
        case NotificationCategory.reminder:
          return 'रिमाइंडर';
        case NotificationCategory.market:
          return 'बाजार भाव';
        case NotificationCategory.tips:
          return 'कृषी सल्ला';
      }
    } else if (languageCode == 'hi') {
      switch (category) {
        case NotificationCategory.weather:
          return 'मौसम';
        case NotificationCategory.alert:
          return 'अलर्ट';
        case NotificationCategory.reminder:
          return 'रिमाइंडर';
        case NotificationCategory.market:
          return 'मंडी भाव';
        case NotificationCategory.tips:
          return 'कृषि सलाह';
      }
    } else {
      switch (category) {
        case NotificationCategory.weather:
          return 'Weather';
        case NotificationCategory.alert:
          return 'Alert';
        case NotificationCategory.reminder:
          return 'Reminder';
        case NotificationCategory.market:
          return 'Market';
        case NotificationCategory.tips:
          return 'Agronomy';
      }
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'titleMarathi': titleMarathi,
        'titleHindi': titleHindi,
        'body': body,
        'bodyMarathi': bodyMarathi,
        'bodyHindi': bodyHindi,
        'category': category.name,
        'importance': importance.name,
        'timestamp': timestamp.toIso8601String(),
        'isRead': isRead,
        'actionRoute': actionRoute,
        'actionLabel': actionLabel,
        'actionLabelMarathi': actionLabelMarathi,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        titleMarathi: json['titleMarathi'] ?? '',
        titleHindi: json['titleHindi'] ?? '',
        body: json['body'] ?? '',
        bodyMarathi: json['bodyMarathi'] ?? '',
        bodyHindi: json['bodyHindi'] ?? '',
        category: NotificationCategory.values.firstWhere(
          (e) => e.name == json['category'],
          orElse: () => NotificationCategory.tips,
        ),
        importance: NotificationImportance.values.firstWhere(
          (e) => e.name == json['importance'],
          orElse: () => NotificationImportance.normal,
        ),
        timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
        isRead: json['isRead'] ?? false,
        actionRoute: json['actionRoute'],
        actionLabel: json['actionLabel'],
        actionLabelMarathi: json['actionLabelMarathi'],
      );
}
