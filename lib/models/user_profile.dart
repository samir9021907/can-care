import '../localization/app_localizations.dart';

class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String region; // e.g. "Western Maharashtra (Kolhapur/Sangli)"
  final AppLanguage preferredLanguage;
  final bool isDemoUser;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.region = 'Maharashtra, India',
    this.preferredLanguage = AppLanguage.english,
    this.isDemoUser = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  UserProfile copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? region,
    AppLanguage? preferredLanguage,
    bool? isDemoUser,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      region: region ?? this.region,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      isDemoUser: isDemoUser ?? this.isDemoUser,
      createdAt: createdAt,
    );
  }

  static UserProfile defaultDemo() {
    return UserProfile(
      id: 'demo-farmer-001',
      fullName: 'Samir Rahane',
      email: 'samir.farmer@gmail.com',
      phone: '+91 9021590368',
      region: 'Kolhapur, Maharashtra',
      preferredLanguage: AppLanguage.english,
      isDemoUser: true,
    );
  }
}
