import '../localization/app_localizations.dart';

class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String region; // e.g. "अहिल्यानगर, महाराष्ट्र" or "Kolhapur, Maharashtra"
  final String? village; // e.g. "कोपरगाव" / "Kopargaon"
  final String? avatarPath; // Custom file path or preset avatar key
  final String? farmSize; // e.g. "३.५ एकर"
  final String? sugarcaneVariety; // e.g. "Co 86032 (निरा)"
  final String? irrigationType; // e.g. "ठिबक सिंचन (Drip)"
  final String? plantingSeason; // e.g. "सुरू (Suru)"
  final AppLanguage preferredLanguage;
  final bool isDemoUser;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.region = 'Maharashtra, India',
    this.village,
    this.avatarPath,
    this.farmSize,
    this.sugarcaneVariety,
    this.irrigationType,
    this.plantingSeason,
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
    String? village,
    String? avatarPath,
    String? farmSize,
    String? sugarcaneVariety,
    String? irrigationType,
    String? plantingSeason,
    AppLanguage? preferredLanguage,
    bool? isDemoUser,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      region: region ?? this.region,
      village: village ?? this.village,
      avatarPath: avatarPath ?? this.avatarPath,
      farmSize: farmSize ?? this.farmSize,
      sugarcaneVariety: sugarcaneVariety ?? this.sugarcaneVariety,
      irrigationType: irrigationType ?? this.irrigationType,
      plantingSeason: plantingSeason ?? this.plantingSeason,
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
      phone: '9021590368',
      region: 'अहिल्यानगर (कोपरगाव), महाराष्ट्र',
      village: 'कोपरगाव',
      avatarPath: 'avatar_farmer_pheta',
      farmSize: '३.५ एकर',
      sugarcaneVariety: 'Co 86032 (निरा)',
      irrigationType: 'ठिबक सिंचन (Drip)',
      plantingSeason: 'सुरू हंगाम (Suru)',
      preferredLanguage: AppLanguage.marathi,
      isDemoUser: true,
    );
  }
}
