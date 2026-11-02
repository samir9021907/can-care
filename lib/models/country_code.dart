/// Model representing a country with its flag, dial code, and phone formatting rules.
class CountryCode {
  final String name;
  final String code; // e.g. '+91'
  final String flag; // e.g. '🇮🇳'
  final String isoCode; // e.g. 'IN'
  final int minLength;
  final int maxLength;

  const CountryCode({
    required this.name,
    required this.code,
    required this.flag,
    required this.isoCode,
    this.minLength = 10,
    this.maxLength = 10,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryCode &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          isoCode == other.isoCode;

  @override
  int get hashCode => code.hashCode ^ isoCode.hashCode;
}

/// Comprehensive list of major agricultural and global countries.
const List<CountryCode> kSupportedCountries = [
  CountryCode(name: 'India', code: '+91', flag: '🇮🇳', isoCode: 'IN', minLength: 10, maxLength: 10),
  CountryCode(name: 'United States', code: '+1', flag: '🇺🇸', isoCode: 'US', minLength: 10, maxLength: 10),
  CountryCode(name: 'United Kingdom', code: '+44', flag: '🇬🇧', isoCode: 'GB', minLength: 10, maxLength: 10),
  CountryCode(name: 'Brazil', code: '+55', flag: '🇧🇷', isoCode: 'BR', minLength: 10, maxLength: 11),
  CountryCode(name: 'Australia', code: '+61', flag: '🇦🇺', isoCode: 'AU', minLength: 9, maxLength: 9),
  CountryCode(name: 'Canada', code: '+1', flag: '🇨🇦', isoCode: 'CA', minLength: 10, maxLength: 10),
  CountryCode(name: 'United Arab Emirates', code: '+971', flag: '🇦🇪', isoCode: 'AE', minLength: 9, maxLength: 9),
  CountryCode(name: 'Thailand', code: '+66', flag: '🇹🇭', isoCode: 'TH', minLength: 9, maxLength: 10),
  CountryCode(name: 'Germany', code: '+49', flag: '🇩🇪', isoCode: 'DE', minLength: 10, maxLength: 11),
  CountryCode(name: 'France', code: '+33', flag: '🇫🇷', isoCode: 'FR', minLength: 9, maxLength: 9),
  CountryCode(name: 'South Africa', code: '+27', flag: '🇿🇦', isoCode: 'ZA', minLength: 9, maxLength: 9),
  CountryCode(name: 'Indonesia', code: '+62', flag: '🇮🇩', isoCode: 'ID', minLength: 9, maxLength: 11),
  CountryCode(name: 'Pakistan', code: '+92', flag: '🇵🇰', isoCode: 'PK', minLength: 10, maxLength: 10),
  CountryCode(name: 'Bangladesh', code: '+880', flag: '🇧🇩', isoCode: 'BD', minLength: 10, maxLength: 10),
  CountryCode(name: 'Philippines', code: '+63', flag: '🇵🇭', isoCode: 'PH', minLength: 10, maxLength: 10),
  CountryCode(name: 'Saudi Arabia', code: '+966', flag: '🇸🇦', isoCode: 'SA', minLength: 9, maxLength: 9),
  CountryCode(name: 'Kenya', code: '+254', flag: '🇰🇪', isoCode: 'KE', minLength: 9, maxLength: 9),
  CountryCode(name: 'Nepal', code: '+977', flag: '🇳🇵', isoCode: 'NP', minLength: 10, maxLength: 10),
  CountryCode(name: 'Sri Lanka', code: '+94', flag: '🇱🇰', isoCode: 'LK', minLength: 9, maxLength: 9),
  CountryCode(name: 'Mexico', code: '+52', flag: '🇲🇽', isoCode: 'MX', minLength: 10, maxLength: 10),
  CountryCode(name: 'Singapore', code: '+65', flag: '🇸🇬', isoCode: 'SG', minLength: 8, maxLength: 8),
  CountryCode(name: 'Malaysia', code: '+60', flag: '🇲🇾', isoCode: 'MY', minLength: 9, maxLength: 10),
  CountryCode(name: 'New Zealand', code: '+64', flag: '🇳🇿', isoCode: 'NZ', minLength: 9, maxLength: 9),
  CountryCode(name: 'Nigeria', code: '+234', flag: '🇳🇬', isoCode: 'NG', minLength: 10, maxLength: 10),
  CountryCode(name: 'Japan', code: '+81', flag: '🇯🇵', isoCode: 'JP', minLength: 10, maxLength: 10),
  CountryCode(name: 'China', code: '+86', flag: '🇨🇳', isoCode: 'CN', minLength: 11, maxLength: 11),
];
