import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:canecare/screens/home_screen.dart';

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

    // Verify Market Trends title and FRP Benchmark rate exist
    expect(find.text('Sugarcane Market Trends'), findsOneWidget);
    expect(find.text('₹3,400'), findsOneWidget);
    expect(find.text('+₹150'), findsOneWidget);
    expect(find.text('+4.6% trend'), findsOneWidget);
    expect(find.text('Min: ₹3,150'), findsOneWidget);
    expect(find.text('Avg: ₹3,285'), findsOneWidget);
    expect(find.text('Peak: ₹3,400'), findsWidgets);
    expect(find.text('View Market Trends'), findsOneWidget);

    // Verify CustomPaint for the chart is present
    expect(find.byType(CustomPaint), findsWidgets);

    // Verify no Flutter exceptions / overflows occurred
    expect(tester.takeException(), isNull);
  });
}
