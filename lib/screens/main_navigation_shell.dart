import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
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
    setState(() {
      _currentIndex = index;
    });
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
        onNavigateToHistory: () {
          setState(() {
            _currentIndex = 2;
          });
        },
        onNavigateToDiseases: () {
          setState(() {
            _currentIndex = 3;
          });
        },
        onNavigateToProfile: () {
          setState(() {
            _currentIndex = 4;
          });
        },
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
      ),
      const DiseaseLibraryScreen(),
      ProfileScreen(
        onNavigateToHistory: () {
          setState(() {
            _currentIndex = 2;
          });
        },
      ),
    ];

    return Scaffold(
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
    );
  }
}

