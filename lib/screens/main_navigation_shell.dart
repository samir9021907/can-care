import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../localization/app_localizations.dart';
import '../providers/history_provider.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/canecare_drawer.dart';
import 'home_screen.dart';
import 'scan_camera_screen.dart';
import 'history_screen.dart';
import 'disease_library_screen.dart';
import 'profile_screen.dart';

class MainNavigationShell extends StatefulWidget {
  final int initialIndex;

  const MainNavigationShell({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int _currentIndex;
  final List<int> _tabHistory = [0];
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    if (_currentIndex != 0) {
      _tabHistory.add(_currentIndex);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HistoryProvider>().loadReports();
      }
    });
  }

  void _onTabSelected(int index) {
    if (index == 1) {
      // Full screen dedicated camera flow
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ScanCameraScreen(),
        ),
      );
      return;
    }
    if (_currentIndex == index) return;
    setState(() {
      _tabHistory.remove(index);
      _tabHistory.add(index);
      _currentIndex = index;
    });
  }

  void _handleBack() {
    // 1. If Drawer is open, close drawer first
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      _scaffoldKey.currentState?.closeDrawer();
      return;
    }

    // 2. If user is in another tab (History, Disease Library, Profile):
    // Pop back to the previous tab or back to Home (0)
    if (_tabHistory.length > 1) {
      setState(() {
        _tabHistory.removeLast();
        _currentIndex = _tabHistory.last;
      });
      return;
    }

    // If _tabHistory was 1 item but _currentIndex is not 0, go to 0
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
        _tabHistory.clear();
        _tabHistory.add(0);
      });
      return;
    }

    // 3. User is on Home screen (Root tab 0)
    // Double-tap back to exit with clean localized toast
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      final loc = AppLocalizations.of(context);
      final isMarathi = loc.language == AppLanguage.marathi;
      final isHindi = loc.language == AppLanguage.hindi;

      final exitMsg = isMarathi
          ? 'बाहेर पडण्यासाठी पुन्हा एकदा मागे दाबा'
          : (isHindi
              ? 'ऐप से बाहर निकलने के लिए दोबारा वापस दबाएं'
              : 'Press back again to exit CaneCare');

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.exit_to_app_rounded,
                  color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  exitMsg,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF14451D),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.only(bottom: 85, left: 24, right: 24),
        ),
      );
      return;
    }

    // Second press within 2 seconds -> close the app cleanly
    SystemNavigator.pop();
  }

  String _getActiveDrawerRoute() {
    switch (_currentIndex) {
      case 0:
        return 'home';
      case 2:
        return 'history';
      case 3:
        return 'diseases';
      case 4:
        return 'settings';
      default:
        return 'home';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        onNavigateToScan: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ScanCameraScreen(),
            ),
          );
        },
        onNavigateToGallery: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const ScanCameraScreen(openGalleryDirectly: true),
            ),
          );
        },
        onNavigateToHistory: () => _onTabSelected(2),
        onNavigateToDiseases: () => _onTabSelected(3),
        onNavigateToProfile: () => _onTabSelected(4),
      ),
      const SizedBox.shrink(), // Index 1 opens full screen camera directly
      HistoryScreen(
        onNavigateToScan: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ScanCameraScreen(),
            ),
          );
        },
        onNavigateBack: _handleBack,
      ),
      DiseaseLibraryScreen(
        onNavigateBack: _handleBack,
      ),
      ProfileScreen(
        onNavigateToHistory: () => _onTabSelected(2),
        onNavigateBack: _handleBack,
      ),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: CaneCareDrawer(
          activeRoute: _getActiveDrawerRoute(),
          onSelectTab: _onTabSelected,
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        bottomNavigationBar: AppBottomNav(
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
        ),
      ),
    );
  }
}
