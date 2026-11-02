import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:canecare/screens/weather_screen.dart';
import 'package:canecare/services/live_weather_service.dart';
import 'package:canecare/localization/app_localizations.dart';

import 'package:provider/provider.dart';
import 'package:canecare/providers/locale_provider.dart';
import 'package:canecare/providers/auth_provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  Widget buildWeatherApp({
    AppLanguage lang = AppLanguage.marathi,
    LiveWeatherService? service,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()..setLanguage(lang)),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        locale: Locale(lang.code),
        localizationsDelegates: [
          AppLocalizationsDelegate(lang),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('mr', ''),
          Locale('hi', ''),
        ],
        home: WeatherScreen(weatherService: service),
      ),
    );
  }

  group('Weather Live Location & Tracking Tests', () {
    test('Maharashtra towns list includes Shirdi, Sangamner, Rahata, Kopargaon', () {
      final towns = LiveWeatherService.maharashtraTowns;
      expect(towns.any((t) => t.nameEn == 'Shirdi' && t.nameMr == 'शिर्डी'), isTrue);
      expect(towns.any((t) => t.nameEn == 'Sangamner' && t.nameMr == 'संगमनेर'), isTrue);
      expect(towns.any((t) => t.nameEn == 'Rahata' && t.nameMr == 'राहाता'), isTrue);
      expect(towns.any((t) => t.nameEn == 'Kopargaon' && t.nameMr == 'कोपरगाव'), isTrue);
      expect(towns.any((t) => t.nameEn == 'Akole' && t.nameMr == 'अकोले'), isTrue);
    });

    test('findNearestTown accurately identifies Shirdi coordinates', () {
      final service = LiveWeatherService.instance;
      // Close to Shirdi coordinates (19.7667, 74.4764)
      final town = service.findNearestTown(19.7680, 74.4780);
      expect(town.nameMr, 'शिर्डी');
      expect(town.districtMr, 'अहिल्यानगर');
    });

    test('findNearestTown accurately identifies Sangamner coordinates', () {
      final service = LiveWeatherService.instance;
      // Close to Sangamner coordinates (19.5761, 74.2070)
      final town = service.findNearestTown(19.5770, 74.2090);
      expect(town.nameMr, 'संगमनेर');
      expect(town.districtMr, 'अहिल्यानगर');
    });

    test('fetchWeatherForCoordinates creates valid WeatherData for Shirdi and Sangamner', () async {
      final service = LiveWeatherService.instance;
      final shirdiWeather = await service.fetchWeatherForCoordinates(
        19.7667,
        74.4764,
        locationName: 'शिर्डी, अहिल्यानगर',
        isLiveGps: true,
      );
      expect(shirdiWeather.location, 'शिर्डी, अहिल्यानगर');
      expect(shirdiWeather.isLiveGps, isTrue);
      expect(shirdiWeather.dailyForecast.isNotEmpty, isTrue);

      final sangamnerWeather = await service.fetchWeatherForCoordinates(
        19.5761,
        74.2070,
        locationName: 'संगमनेर, अहिल्यानगर',
        isLiveGps: true,
      );
      expect(sangamnerWeather.location, 'संगमनेर, अहिल्यानगर');
      expect(sangamnerWeather.isLiveGps, isTrue);
    });

    testWidgets('WeatherScreen renders GPS live banner and location picker button',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWeatherApp());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // GPS Track button / banner
      expect(find.byIcon(Icons.my_location_rounded), findsWidgets);

      // Tap location pill to open location picker sheet
      await tester.tap(find.text('सातारा, महाराष्ट्र'));
      await tester.pumpAndSettle();

      // Verify sheet opens with GPS option and Search
      expect(find.text('जिल्हा निवडा'), findsOneWidget);
      expect(find.text('माझे चालू ठिकाण शोधा (GPS)'), findsOneWidget);
      expect(find.text('शिर्डी'), findsWidgets);
      expect(find.text('संगमनेर'), findsWidgets);

      // Tap Sangamner quick chip
      await tester.tap(find.text('संगमनेर').first);
      await tester.pumpAndSettle();

      // Verify selected location updated to Sangamner
      expect(find.text('संगमनेर, अहिल्यानगर'), findsOneWidget);
    });
  });
}
