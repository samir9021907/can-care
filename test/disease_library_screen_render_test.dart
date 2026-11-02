import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:canecare/providers/disease_library_provider.dart';
import 'package:canecare/providers/locale_provider.dart';
import 'package:canecare/localization/app_localizations.dart';
import 'package:canecare/screens/disease_library_screen.dart';

Widget createTestDiseaseLibraryApp({Size size = const Size(360, 800)}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ChangeNotifierProvider(create: (_) => DiseaseLibraryProvider()),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizationsDelegate(AppLanguage.english),
      ],
      home: const Scaffold(
        body: DiseaseLibraryScreen(),
      ),
    ),
  );
}

void main() {
  testWidgets(
      'Disease Library screen renders all sections matching user screenshots',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestDiseaseLibraryApp());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // 1. App Bar Header & Search Bar
    expect(find.text('Disease Library'), findsOneWidget);
    expect(find.text('Search diseases...'), findsOneWidget);

    // 2. Filter Pills
    expect(find.text('All (सर्व)'), findsOneWidget);
    expect(find.text('Diseased (बाधित)'), findsOneWidget);
    expect(find.text('Healthy (निरोगी)'), findsOneWidget);

    // 3. Field Identification & 6 Cards
    expect(find.text('Field Identification'), findsOneWidget);
    expect(find.text('6 Diagnostic Profiles'), findsOneWidget);
    expect(find.text('Healthy Cane'), findsOneWidget);
    expect(find.text('Red Rot'), findsWidgets);
    expect(find.text('Sugarcane Rust'), findsWidgets);
    expect(find.text('Yellow Leaf (YLD)'), findsOneWidget);
    expect(find.text('Sugarcane Mosaic'), findsOneWidget);
    expect(find.text('Sugarcane Smut'), findsOneWidget);

    // 4. Badges on 6 Cards
    expect(find.text('Healthy Crop'), findsOneWidget);
    expect(find.text('Fungal • Severe'), findsOneWidget);
    expect(find.text('Foliar Rust'), findsOneWidget);
    expect(find.text('Phytoplasma'), findsOneWidget);
    expect(find.text('Viral Disease'), findsOneWidget);
    expect(find.text('Fungal Spore'), findsOneWidget);

    // 5. Section: What do you notice on your leaf?
    expect(find.text('What do you notice on your leaf?'), findsOneWidget);
    expect(find.text('Choose a symptom to explore possible causes in your plot.'),
        findsOneWidget);
    expect(find.text('Yellow leaves'), findsOneWidget);
    expect(find.text('Brown spots'), findsOneWidget);
    expect(find.text('Drying edges'), findsOneWidget);
    expect(find.text('Unusual patterns'), findsOneWidget);

    // 6. Section: Common Sugarcane Diseases
    expect(find.text('Common Sugarcane Diseases'), findsOneWidget);
    expect(find.text('View all (सर्व पहा)'), findsOneWidget);

    // 7. Section: Know the Warning Signs
    expect(find.text('Know the Warning Signs'), findsOneWidget);
    expect(find.text('Changes in leaf colour'), findsOneWidget);
    expect(find.text('Spots or unusual marks'), findsOneWidget);
    expect(find.text('Drying or abnormal growth'), findsOneWidget);
    expect(find.text('Learn about symptoms'), findsOneWidget);

    // 8. Section: Keep Your Sugarcane Healthy
    expect(find.text('Keep Your Sugarcane Healthy'), findsOneWidget);
    expect(find.text('More Crop Care Tips'), findsOneWidget);

    // 9. Section: Still not sure? (Instant AI Detection)
    expect(find.text('Instant AI Detection'), findsOneWidget);
    expect(find.text('Still not sure? (अद्याप खात्री नाही?)'), findsOneWidget);
    expect(find.text('Scan a Leaf (कॅमेऱ्याने तपासा)'), findsOneWidget);

    // 10. Section: Need more help? (Ask an Expert)
    expect(find.text('Need more help?'), findsOneWidget);
    expect(find.text('अधिक सल्ला हवा आहे?'), findsOneWidget);
    expect(find.text('Ask an Expert (कृषी तज्ज्ञांना विचारा)'), findsOneWidget);
    expect(
        find.text(
            'Support responses typically provided during standard farm office hours.'),
        findsOneWidget);

    // Zero layout exceptions
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Disease Library screen renders cleanly on narrow 320px screen without overflow',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestDiseaseLibraryApp(size: const Size(320, 800)));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Disease Library'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
