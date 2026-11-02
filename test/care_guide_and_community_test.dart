import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:canecare/screens/sugarcane_care_guide_screen.dart';
import 'package:canecare/screens/farmer_community_screen.dart';
import 'package:canecare/screens/home_screen.dart';
import 'package:canecare/widgets/canecare_drawer.dart';
import 'package:canecare/localization/app_localizations.dart';

void main() {
  Widget buildTestableWidget(Widget child, [AppLanguage lang = AppLanguage.english]) {
    return MaterialApp(
      home: child,
      localizationsDelegates: [
        AppLocalizationsDelegate(lang),
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('mr', ''),
        Locale('hi', ''),
      ],
    );
  }

  testWidgets('Screen 1: SugarcaneCareGuideScreen renders all sections cleanly',
      (tester) async {
    await tester.pumpWidget(buildTestableWidget(const SugarcaneCareGuideScreen()));
    await tester.pumpAndSettle();

    // 1. Header
    expect(find.text('Sugarcane Care Guide'), findsOneWidget);
    expect(find.textContaining('Your guide from planting to harvest'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_outline_rounded), findsOneWidget);

    // 2. Hero Banner
    expect(find.text('Grow Healthy Sugarcane 🌱'), findsOneWidget);
    expect(find.text('Explore Growing Stages'), findsOneWidget);

    // 3. Crop Growth Stages
    expect(find.text('Land Preparation'), findsOneWidget);
    expect(find.text('Planting & Germination'), findsOneWidget);
    expect(find.text('Tillering & Grand Growth'), findsOneWidget);
    expect(find.text('Maturation & Harvest'), findsOneWidget);

    // 4. Essential Crop Care
    expect(find.text('Essential Crop Care'), findsOneWidget);
    expect(find.text('Irrigation Management'), findsOneWidget);
    expect(find.text('Nutrient Management'), findsOneWidget);

    // Test bookmark toggle
    await tester.tap(find.byIcon(Icons.bookmark_outline_rounded));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);
  });

  testWidgets('Screen 2: FarmerCommunityScreen renders feed, search, and interactions',
      (tester) async {
    await tester.pumpWidget(buildTestableWidget(const FarmerCommunityScreen()));
    await tester.pumpAndSettle();

    // 1. Header
    expect(find.text('Farmer Community'), findsOneWidget);
    expect(find.text('Learn together. Grow together. 🌱'), findsOneWidget);

    // 2. Welcome Banner
    expect(find.text('Your Farming Community'), findsWidgets);

    // 3. Search Bar
    expect(find.byType(TextField), findsWidgets);

    // 4. Topic Filter Chips
    expect(find.text('All Posts'), findsWidgets);
    expect(find.text('Crop Diseases'), findsWidgets);
    expect(find.text('Irrigation'), findsWidgets);

    // 5. Expert Answer Card
    expect(find.text('VERIFIED EXPERT ANSWER (तज्ञांचे उत्तर)'), findsOneWidget);
    expect(find.text('Dr. Anand Patil (VSI Pune)'), findsOneWidget);

    // 6. Community Feed sample post
    expect(find.text('How can I identify unusual red patches on sugarcane leaves?'),
        findsOneWidget);

    // Test like button interaction
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();
    final likeButton = find.byIcon(Icons.thumb_up_outlined).first;
    await tester.tap(likeButton, warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.thumb_up_rounded), findsWidgets);
  });

  testWidgets('HomeScreen renders Care Guide and Farmer Community cards in English and Marathi',
      (tester) async {
    // English
    await tester.pumpWidget(
      buildTestableWidget(
        HomeScreen(
          onNavigateToScan: () {},
          onNavigateToGallery: () {},
          onNavigateToHistory: () {},
          onNavigateToDiseases: () {},
          onNavigateToProfile: () {},
        ),
        AppLanguage.english,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Care Guide'), findsOneWidget);
    expect(find.text('Farmer Community'), findsOneWidget);

    // Marathi
    await tester.pumpWidget(
      buildTestableWidget(
        HomeScreen(
          onNavigateToScan: () {},
          onNavigateToGallery: () {},
          onNavigateToHistory: () {},
          onNavigateToDiseases: () {},
          onNavigateToProfile: () {},
        ),
        AppLanguage.marathi,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ऊस पीक मार्गदर्शिका'), findsOneWidget);
    expect(find.text('शेतकरी कम्युनिटी'), findsOneWidget);
  });

  testWidgets('CaneCareDrawer includes Care Guide and Farmer Community items',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        const CaneCareDrawer(activeRoute: 'home'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sugarcane Care Guide'), findsOneWidget);
    expect(find.text('Farmer Community'), findsOneWidget);
    expect(find.byIcon(Icons.menu_book_rounded), findsOneWidget);
    expect(find.byIcon(Icons.forum_rounded), findsOneWidget);
  });
}
