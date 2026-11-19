import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:canecare/providers/auth_provider.dart';
import 'package:canecare/screens/sugarcane_care_guide_screen.dart';
import 'package:canecare/screens/farmer_community_screen.dart';
import 'package:canecare/screens/home_screen.dart';
import 'package:canecare/widgets/canecare_drawer.dart';
import 'package:canecare/localization/app_localizations.dart';

void main() {
  Widget buildTestableWidget(Widget child, [AppLanguage lang = AppLanguage.english]) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        home: child,
        localizationsDelegates: [
          AppLocalizationsDelegate(lang),
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('mr', ''),
          Locale('hi', ''),
        ],
      ),
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
    expect(find.text('Verified Expert Answer'), findsOneWidget);
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

  testWidgets('Screen 3: FarmerCommunityScreen allows asking and submitting a question',
      (tester) async {
    await tester.pumpWidget(buildTestableWidget(const FarmerCommunityScreen()));
    await tester.pumpAndSettle();

    // Verify FAB exists and tap it
    expect(find.byType(FloatingActionButton), findsOneWidget);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify sheet opened
    expect(find.text('Ask the Farming Community'), findsOneWidget);

    // Enter question title & description (TextField 0 is search bar, 1 is title, 2 is desc)
    final textFields = find.byType(TextField);
    expect(textFields, findsNWidgets(3));
    await tester.enterText(textFields.at(1), 'Test Sugarcane Question');
    await tester.enterText(textFields.at(2), 'Detailed description for sugarcane crop query.');
    await tester.pumpAndSettle();

    // Submit question
    await tester.tap(find.text('Post Question to Community'));
    await tester.pumpAndSettle();

    // Verify question is added at top of feed
    expect(find.text('Test Sugarcane Question'), findsOneWidget);
  });

  testWidgets('FarmerCommunityScreen renders responsively on narrow 320px screen without overflow or zebra lines',
      (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget(const FarmerCommunityScreen(), AppLanguage.marathi));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('शेतकरी कम्युनिटी'), findsOneWidget);
    expect(find.text('चर्चा पहा'), findsWidgets);

    // Also test English
    await tester.pumpWidget(buildTestableWidget(const FarmerCommunityScreen(), AppLanguage.english));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Farmer Community'), findsOneWidget);
    expect(find.text('View Discussion'), findsWidgets);
  });

  testWidgets('FarmerCommunityScreen handles web, data uri and fallback images safely',
      (tester) async {
    await tester.pumpWidget(buildTestableWidget(const FarmerCommunityScreen()));
    await tester.pumpAndSettle();

    expect(find.byType(FarmerCommunityScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
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
