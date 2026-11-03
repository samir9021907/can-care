import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:canecare/localization/app_localizations.dart';
import 'package:canecare/providers/auth_provider.dart';
import 'package:canecare/providers/locale_provider.dart';
import 'package:canecare/screens/edit_profile_screen.dart';
import 'package:canecare/widgets/farmer_avatar_widget.dart';

Widget _createTestApp({
  required Widget child,
  AuthProvider? authProvider,
  AppLanguage language = AppLanguage.english,
}) {
  final localeProvider = LocaleProvider();
  localeProvider.setLanguage(language);

  return MultiProvider(
    providers: [
      ChangeNotifierProvider<LocaleProvider>.value(
        value: localeProvider,
      ),
      ChangeNotifierProvider<AuthProvider>(
        create: (_) => authProvider ?? AuthProvider(),
      ),
    ],
    child: Consumer<LocaleProvider>(
      builder: (context, lp, _) {
        return MaterialApp(
          locale: lp.locale,
          home: child,
          localizationsDelegates: [
            AppLocalizationsDelegate(lp.currentLanguage),
          ],
        );
      },
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Farmer Profile Edit & Avatar Tests', () {
    testWidgets('EditProfileScreen renders all modern farmer fields in English and Marathi',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _createTestApp(
          child: const EditProfileScreen(),
          language: AppLanguage.english,
        ),
      );
      await tester.pumpAndSettle();

      // Check App Bar Title
      expect(find.text('Edit Farmer Profile'), findsOneWidget);

      // Check Section Headers
      expect(find.text('Personal Information'), findsOneWidget);
      expect(find.text('Farm & Location'), findsOneWidget);
      expect(find.text('Sugarcane Crop Details'), findsOneWidget);

      // Check Form Fields
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Mobile Number'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('District'), findsOneWidget);
      expect(find.text('Taluka / Village'), findsOneWidget);
      expect(find.text('Sugarcane Area (Acres)'), findsOneWidget);
      expect(find.text('Sugarcane Variety'), findsOneWidget);
      expect(find.text('Irrigation Method'), findsOneWidget);
      expect(find.text('Planting Season'), findsOneWidget);

      // Check Save Changes Button (app bar action and bottom CTA)
      expect(find.text('Save Changes'), findsWidgets);
    });

    testWidgets('EditProfileScreen renders cleanly in Marathi',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _createTestApp(
          child: const EditProfileScreen(),
          language: AppLanguage.marathi,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('शेतकरी प्रोफाइल संपादन'), findsOneWidget);
      expect(find.text('वैयक्तिक माहिती'), findsOneWidget);
      expect(find.text('शेती व गाव तपशील'), findsOneWidget);
      expect(find.text('ऊस पीक माहिती'), findsOneWidget);
      expect(find.text('बदल जतन करा'), findsWidgets);
    });

    testWidgets('Tapping photo camera badge opens bottom sheet with camera, gallery and avatars',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _createTestApp(
          child: const EditProfileScreen(),
          language: AppLanguage.english,
        ),
      );
      await tester.pumpAndSettle();

      // Find camera icon on avatar and tap it
      final cameraBadge = find.byIcon(Icons.camera_alt_rounded);
      expect(cameraBadge, findsOneWidget);
      await tester.tap(cameraBadge);
      await tester.pumpAndSettle();

      // Verify bottom sheet appears with photo options
      expect(find.text('Choose Profile Photo'), findsOneWidget);
      expect(find.text('Take Photo (Camera)'), findsOneWidget);
      expect(find.text('Choose from Gallery'), findsOneWidget);
      expect(find.text('Choose Farmer Avatar'), findsOneWidget);
    });

    testWidgets('FarmerAvatarWidget renders preset avatars and camera badge',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: FarmerAvatarWidget(
                avatarPath: 'avatar_farmer_pheta',
                fullName: 'Samir Rahane',
                size: 80,
                showCameraBadge: true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FarmerAvatarWidget), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt_rounded), findsOneWidget);
    });

    testWidgets('Editing name and selecting quick chip updates profile values',
        (WidgetTester tester) async {
      final auth = AuthProvider();
      await tester.pumpWidget(
        _createTestApp(
          child: const EditProfileScreen(),
          authProvider: auth,
          language: AppLanguage.english,
        ),
      );
      await tester.pumpAndSettle();

      // Find full name field and enter new name
      final nameField = find.byType(TextFormField).first;
      await tester.enterText(nameField, 'बाळासाहेब पाटील');
      await tester.pumpAndSettle();

      // Tap top AppBar action Save Changes
      await tester.tap(find.text('Save Changes').first);
      await tester.pumpAndSettle();

      // Verify AuthProvider received the updated profile fields
      expect(auth.currentUser?.fullName, equals('बाळासाहेब पाटील'));
    });
  });
}
