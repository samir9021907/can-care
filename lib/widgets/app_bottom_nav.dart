import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE5EDE7), width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: loc.translate('nav_home'),
              ),
              _buildScanNavItem(
                index: 1,
                label: loc.translate('nav_scan'),
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.access_time_rounded,
                activeIcon: Icons.access_time_filled_rounded,
                label: loc.translate('nav_history'),
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.menu_book_outlined,
                activeIcon: Icons.menu_book_rounded,
                label: loc.translate('nav_diseases'),
              ),
              _buildNavItem(
                index: 4,
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: loc.translate('nav_profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanNavItem({
    required int index,
    required String label,
  }) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFEDF6EE),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Color(0xFF165228),
                size: 19,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF165228)
                    : const Color(0xFF6B8074),
              ),
              maxLines: 1,
            ),
            if (isSelected) ...[
              const SizedBox(height: 2),
              Container(
                width: 4.5,
                height: 4.5,
                decoration: const BoxDecoration(
                  color: Color(0xFF165228),
                  shape: BoxShape.circle,
                ),
              ),
            ] else
              const SizedBox(height: 6.5),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = currentIndex == index;
    final color =
        isSelected ? const Color(0xFF165228) : const Color(0xFF6B8074);

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: color,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: color,
              ),
              maxLines: 1,
            ),
            if (isSelected) ...[
              const SizedBox(height: 2),
              Container(
                width: 4.5,
                height: 4.5,
                decoration: const BoxDecoration(
                  color: Color(0xFF165228),
                  shape: BoxShape.circle,
                ),
              ),
            ] else
              const SizedBox(height: 6.5),
          ],
        ),
      ),
    );
  }
}
