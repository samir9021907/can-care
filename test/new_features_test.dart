import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:canecare/providers/locale_provider.dart';
import 'package:canecare/providers/auth_provider.dart';
import 'package:canecare/localization/app_localizations.dart';
import 'package:canecare/screens/weather_screen.dart';
import 'package:canecare/screens/sugarcane_advisory_screen.dart';
import 'package:canecare/screens/ask_question_screen.dart';
import 'package:canecare/widgets/canecare_drawer.dart';
import 'package:canecare/services/advisory_service.dart';
import 'package:canecare/services/permission_service.dart';

Widget createLocalizedTestApp(Widget child, {AppLanguage lang = AppLanguage.marathi}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LocaleProvider()..setLanguage(lang)),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
    ],
    child: MaterialApp(
      locale: Locale(lang.code),
      localizationsDelegates: [
        AppLocalizationsDelegate(lang),
      ],
      home: child,
    ),
  );
}

void main() {
  testWidgets('WeatherScreen renders all components matching Image 1 Left Phone',
      (WidgetTester tester) async {
    await tester.pumpWidget(createLocalizedTestApp(const WeatherScreen()));
    // Let simulated weather service response complete
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify Title
    expect(find.text('हवामान माहिती'), findsOneWidget);

    // Verify Location
    expect(find.text('सातारा, महाराष्ट्र'), findsOneWidget);

    // Verify Current Temperature & Condition
    expect(find.text('28°C'), findsOneWidget);
    expect(find.text('अंशतः ढगाळ'), findsOneWidget);

    // Verify Humidity & Wind
    expect(find.textContaining('आर्द्रता: 72%'), findsOneWidget);
    expect(find.textContaining('वारा: 12 किमी/तास'), findsOneWidget);

    // Verify Forecast Cards (सोम, मंगळ, बुध, रवि etc.)
    expect(find.text('सोम'), findsOneWidget);
    expect(find.text('मंगळ'), findsOneWidget);
    expect(find.text('बुध'), findsOneWidget);
    expect(find.text('रवि'), findsOneWidget);

    // Verify Agricultural Advice
    expect(find.text('पिकांसाठी सूचना'), findsOneWidget);
    expect(
      find.text('आज हवामान अनुकूल आहे. पाण्याचे व्यवस्थापन योग्य ठेवा.'),
      findsOneWidget,
    );
  });

  testWidgets('SugarcaneAdvisoryScreen renders categories and tabs matching Image 1 Right Phone',
      (WidgetTester tester) async {
    await tester.pumpWidget(createLocalizedTestApp(const SugarcaneAdvisoryScreen()));
    await tester.pumpAndSettle();

    // Verify Title
    expect(find.text('तज्ञांचा सल्ला'), findsOneWidget);

    // Verify Tabs
    expect(find.text('माझे प्रश्न'), findsOneWidget);
    expect(find.text('सर्व प्रश्न'), findsOneWidget);

    // Switch to All Questions Tab
    await tester.tap(find.text('सर्व प्रश्न'));
    await tester.pumpAndSettle();

    // Verify 4 Advisory Category Cards
    expect(find.text('ऊस पिकातील रोग'), findsWidgets);
    expect(find.text('पानावरील डाग, कुज, किड'), findsOneWidget);

    expect(find.text('खत व्यवस्थापन'), findsWidgets);
    expect(find.text('योग्य खत आणि प्रमाण'), findsOneWidget);

    expect(find.text('पाणी व्यवस्थापन'), findsWidgets);
    expect(find.text('सिंचनाचे योग्य नियोजन'), findsOneWidget);

    expect(find.text('सामान्य प्रश्न'), findsWidgets);
    expect(find.text('विविध शेतीविषयक प्रश्न'), findsOneWidget);

    // Verify Ask Question Button
    expect(find.text('नवीन प्रश्न विचारा'), findsOneWidget);
  });

  testWidgets('AskQuestionScreen validates and submits a new sugarcane question',
      (WidgetTester tester) async {
    await tester.pumpWidget(createLocalizedTestApp(const AskQuestionScreen()));
    await tester.pumpAndSettle();

    expect(find.text('नवीन प्रश्न विचारा'), findsOneWidget);

    // Tap submit while empty to verify validation
    await tester.tap(find.text('तज्ञांना प्रश्न पाठवा'));
    await tester.pumpAndSettle();

    expect(find.text('कृपया प्रश्नाचे शीर्षक लिहा'), findsOneWidget);
    expect(find.text('कृपया समस्येचे सविस्तर वर्णन लिहा'), findsOneWidget);

    // Fill valid data
    await tester.enterText(
      find.byType(TextField).at(0),
      'खतांचा डोस कधी द्यावा?',
    );
    await tester.enterText(
      find.byType(TextField).at(1),
      'ऊसाची लागवड करून ४५ दिवस झाले आहेत. युरियाचे प्रमाण सांगावे.',
    );
    await tester.pumpAndSettle();

    // Submit question
    await tester.tap(find.text('तज्ञांना प्रश्न पाठवा'));
    await tester.pump(const Duration(milliseconds: 700));

    // Verify stored in AdvisoryService
    expect(
      AdvisoryService().myQuestions.any((q) => q.title == 'खतांचा डोस कधी द्यावा?'),
      isTrue,
    );
  });

  testWidgets('CaneCareDrawer renders all menu items matching Image 2',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(createLocalizedTestApp(
      const Scaffold(
        body: CaneCareDrawer(activeRoute: 'settings'),
      ),
    ));
    await tester.pumpAndSettle();

    // Verify Drawer Header
    expect(find.text('CaneCare AI'), findsOneWidget);
    expect(find.text('v1.0.0'), findsOneWidget);

    // Verify Navigation Items
    expect(find.text('होम'), findsOneWidget);
    expect(find.text('रोग ओळखा'), findsOneWidget);
    expect(find.text('भाषा निवड'), findsOneWidget);
    expect(find.text('हवामान माहिती'), findsOneWidget);
    expect(find.text('तज्ञांचा सल्ला'), findsOneWidget);
    expect(find.text('इतिहास'), findsOneWidget);
    expect(find.text('सूचना'), findsOneWidget);
    expect(find.text('सेटिंग्ज'), findsOneWidget);
    expect(find.text('ॲपबद्दल'), findsOneWidget);
    expect(find.text('लॉगआउट'), findsOneWidget);
  });

  testWidgets('Camera permission bottom sheet renders responsively without overflow',
      (WidgetTester tester) async {
    // Set typical phone screen size (e.g. 390x844 logical pixels)
    tester.view.physicalSize = const Size(390 * 2.0, 750 * 2.0);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(createLocalizedTestApp(
      Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                PermissionService.instance.askCameraPermissionAtStart(
                  context,
                  forceShow: true,
                );
              },
              child: const Text('Ask Permission'),
            ),
          ),
        ),
      ),
      lang: AppLanguage.english,
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ask Permission'));
    await tester.pumpAndSettle();

    // Verify Title and buttons are visible and rendered without overflow
    expect(find.text('Camera Access Required'), findsOneWidget);
    expect(find.text('Allow Camera Access'), findsOneWidget);
    expect(find.text('Not Now'), findsOneWidget);
    expect(find.text('Real-time leaf scanning in your farm'), findsOneWidget);
  });
}

