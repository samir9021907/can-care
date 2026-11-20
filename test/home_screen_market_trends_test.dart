import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:canecare/screens/home_screen.dart';
import 'package:canecare/screens/sugarcane_market_screen.dart';

void main() {
  testWidgets('Sugarcane Market Trends card renders responsively on narrow 320px screen without overflow',
      (WidgetTester tester) async {
    // Set screen size to narrow 320x800 phone
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeScreen(
            onNavigateToScan: () {},
            onNavigateToGallery: () {},
            onNavigateToHistory: () {},
            onNavigateToDiseases: () {},
            onNavigateToProfile: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Market Trends title and Live badge exist
    expect(find.text('Sugarcane Market Trends'), findsOneWidget);
    expect(find.text('LIVE'), findsOneWidget);
    expect(find.text('Daily'), findsOneWidget);
    expect(find.text('Season'), findsOneWidget);
    expect(find.text('View Daily Live Market'), findsOneWidget);

    // Verify CustomPaint for the chart is present
    expect(find.byType(CustomPaint), findsWidgets);

    // Verify no Flutter exceptions / overflows occurred
    expect(tester.takeException(), isNull);
  });

  testWidgets('SugarcaneMarketScreen renders daily rates table, calculator and APMC list',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SugarcaneMarketScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SugarcaneMarketScreen), findsOneWidget);
    expect(find.text('Live Sugarcane Market'), findsOneWidget);
    expect(find.text('TODAY LIVE RATE'), findsOneWidget);
    expect(find.text('Day-by-Day Live Rate Sheet'), findsOneWidget);
    expect(find.text('7 Days Live'), findsOneWidget);
    expect(find.text('Live FRP Sugarcane Calculator'), findsOneWidget);
    expect(find.text('Active Regional Sugar Mills'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
