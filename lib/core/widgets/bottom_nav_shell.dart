import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';

/// The persistent bottom navigation bar + tab content, driven by
/// go_router's [StatefulShellRoute.indexedStack] so each tab keeps its own
/// scroll position/state when switching. "Add Recipe" is visually
/// emphasized per the product spec.
class BottomNavShell extends StatelessWidget {
  const BottomNavShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.divider)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: navigationShell.currentIndex == 0,
                onTap: () => navigationShell.goBranch(0),
              ),
              _NavItem(
                icon: Icons.search_rounded,
                label: 'Search',
                isSelected: navigationShell.currentIndex == 1,
                onTap: () => navigationShell.goBranch(1),
              ),
              _AddRecipeNavItem(
                isSelected: navigationShell.currentIndex == 2,
                onTap: () => navigationShell.goBranch(2),
              ),
              _NavItem(
                icon: Icons.menu_book_rounded,
                label: 'My Recipes',
                isSelected: navigationShell.currentIndex == 3,
                onTap: () => navigationShell.goBranch(3),
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                isSelected: navigationShell.currentIndex == 4,
                onTap: () => navigationShell.goBranch(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primaryGreen : AppColors.mutedText;
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 2),
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The visually emphasized center "Add Recipe" action: a raised terracotta
/// circle instead of a plain icon+label like the other tabs.
class _AddRecipeNavItem extends StatelessWidget {
  const _AddRecipeNavItem({required this.isSelected, required this.onTap});

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: 'Add recipe',
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 48,
          height: 48,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: const BoxDecoration(
            color: AppColors.terracotta,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add_rounded, color: AppColors.white, size: 26),
        ),
      ),
    );
  }
}
