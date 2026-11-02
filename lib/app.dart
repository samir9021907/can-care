import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'constants/app_colors.dart';
import 'constants/app_dimensions.dart';
import 'localization/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/scan_provider.dart';
import 'providers/history_provider.dart';
import 'providers/disease_library_provider.dart';
import 'providers/tips_provider.dart';
import 'providers/settings_provider.dart';
import 'routes/app_routes.dart';

class CaneCareApp extends StatelessWidget {
  const CaneCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ScanProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => DiseaseLibraryProvider()),
        ChangeNotifierProvider(create: (_) => TipsProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return MaterialApp(
            title: 'CaneCare AI',
            debugShowCheckedModeBanner: false,
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('en', ''),
              Locale('mr', ''),
              Locale('hi', ''),
            ],
            localizationsDelegates: [
              AppLocalizationsDelegate(localeProvider.currentLanguage),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: AppColors.background,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                primary: AppColors.primary,
                surface: AppColors.cardSurface,
                error: AppColors.error,
              ),
              fontFamily: 'Inter',
              fontFamilyFallback: const ['Roboto', 'sans-serif'],
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.background,
                elevation: 0,
                scrolledUnderElevation: 0,
                centerTitle: false,
                iconTheme: IconThemeData(color: AppColors.darkGreen),
              ),
              cardTheme: CardThemeData(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusCard),
                  side: const BorderSide(color: AppColors.border),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusButton),
                  ),
                ),
              ),
            ),
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
