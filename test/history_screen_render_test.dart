import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:canecare/providers/history_provider.dart';
import 'package:canecare/providers/locale_provider.dart';
import 'package:canecare/providers/auth_provider.dart';
import 'package:canecare/localization/app_localizations.dart';
import 'package:canecare/screens/history_screen.dart';

Widget createTestHistoryApp({Size size = const Size(360, 800)}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => HistoryProvider()),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizationsDelegate(AppLanguage.english),
      ],
      home: Scaffold(
        body: HistoryScreen(onNavigateToScan: () {}),
      ),
    ),
  );
}

void main() {
  testWidgets('Scan History screen renders all elements matching user screenshots',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestHistoryApp());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // 1. App Bar Header
    expect(find.text('Scan History'), findsOneWidget);

    // 2. Filter Pills
    expect(find.text('All (12)'), findsOneWidget);
    expect(find.text('Healthy (9)'), findsOneWidget);
    expect(find.text('Diseased (3)'), findsOneWidget);

    // 3. Stat Cards
    expect(find.text('Total Scans'), findsOneWidget);
    expect(find.text('Healthy'), findsWidgets);
    expect(find.text('Needs Care'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    // 4. Search and Date filter
    expect(find.text('Search disease or scan date...'), findsOneWidget);
    expect(find.text('Filter by date'), findsOneWidget);
    expect(find.text('Showing 4 recent'), findsOneWidget);

    // 5. Recent Scan Items
    expect(find.text('Yellow Leaf Disease'), findsOneWidget);
    expect(find.text('Healthy Sugarcane Leaf'), findsWidgets);
    expect(find.text('Red Rot (लाल कुज)'), findsOneWidget);
    expect(find.text('Rust (तांबेरा)'), findsOneWidget);

    // 6. Crop Health Trend
    expect(find.textContaining('Crop Health Trend'), findsOneWidget);
    expect(find.text('Weekly scans overview (Last 4 weeks)'), findsOneWidget);
    expect(find.text('Week 1 (24 Mar – 30 Mar)'), findsOneWidget);
    expect(find.text('Week 2 (31 Mar – 06 Apr)'), findsOneWidget);
    expect(find.text('Week 3 (07 Apr – 13 Apr)'), findsOneWidget);
    expect(find.text('Week 4 (14 Apr – 20 Apr)'), findsOneWidget);
    expect(find.text('Healthy Crop'), findsOneWidget);
    expect(find.text('Needs Attention'), findsOneWidget);

    // 7. Follow-up Reminders
    expect(find.text('Follow-up Reminders'), findsOneWidget);
    expect(find.text('Set Reminder'), findsOneWidget);

    // 8. Reports & Agronomist Sharing
    expect(find.text('Reports & Agronomist Sharing'), findsOneWidget);
    expect(find.text('View Summary'), findsOneWidget);
    expect(find.text('Download PDF'), findsOneWidget);
    expect(find.text('Share Expert'), findsOneWidget);

    // 9. Field Archive
    expect(find.textContaining('Looking for older scans?'), findsOneWidget);

    // Verify zero layout errors or unhandled exceptions
    expect(tester.takeException(), isNull);
  });

  testWidgets('Scan History screen renders cleanly on narrow 320px screen without overflow',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestHistoryApp(size: const Size(320, 800)));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Scan History'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
