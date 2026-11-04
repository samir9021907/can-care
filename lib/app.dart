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
import 'services/auth_service.dart';
import 'services/prediction_service.dart';
import 'services/report_service.dart';
import 'services/disease_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/main_navigation_shell.dart';
import 'screens/splash_screen.dart';

class CaneCareApp extends StatelessWidget {
  const CaneCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService: RemoteAuthService()),
        ),
        ChangeNotifierProvider(
          create: (_) => ScanProvider(
            predictionService: RemotePredictionService(),
            reportService: RemoteReportService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => HistoryProvider(reportService: RemoteReportService()),
        ),
        ChangeNotifierProvider(
          create: (_) => DiseaseLibraryProvider(diseaseService: RemoteDiseaseService()),
        ),
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
                centerTitle: false,
                iconTheme: IconThemeData(color: AppColors.textMain),
                titleTextStyle: TextStyle(
                  color: AppColors.textMain,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            home: const AppAuthGate(),
            routes: AppRoutes.routes,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}

/// Dynamic authentication gate:
/// Persists user login state across browser refresh or app restart.
/// If already logged in, seamlessly enters MainNavigationShell.
/// If not logged in, presents the SignInScreen.
class AppAuthGate extends StatefulWidget {
  const AppAuthGate({super.key});

  @override
  State<AppAuthGate> createState() => _AppAuthGateState();
}

class _AppAuthGateState extends State<AppAuthGate> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('canecare_is_logged_in') ?? false;
    if (mounted) {
      setState(() {
        _isLoggedIn = loggedIn;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    if (_isLoggedIn) {
      return const MainNavigationShell();
    }
    return const SplashScreen();
  }
}
