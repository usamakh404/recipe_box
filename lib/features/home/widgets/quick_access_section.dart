import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/quick_access_card.dart';

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({
    super.key,
    required this.onFavoritesTap,
    required this.onRecentlyViewedTap,
    required this.onMyRecipesTap,
    required this.onGroceryListTap,
  });

  final VoidCallback onFavoritesTap;
  final VoidCallback onRecentlyViewedTap;
  final VoidCallback onMyRecipesTap;
  final VoidCallback onGroceryListTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          QuickAccessCard(
            icon: Icons.favorite_rounded,
            label: 'Favorites',
            backgroundColor: AppColors.softGreen,
            onTap: onFavoritesTap,
          ),
          const SizedBox(width: 12),
          QuickAccessCard(
            icon: Icons.history_rounded,
            label: 'Recently\nViewed',
            backgroundColor: AppColors.warmBeige,
            onTap: onRecentlyViewedTap,
          ),
          const SizedBox(width: 12),
          QuickAccessCard(
            icon: Icons.menu_book_rounded,
            label: 'My Recipes',
            backgroundColor: AppColors.softGreen,
            onTap: onMyRecipesTap,
          ),
          const SizedBox(width: 12),
          QuickAccessCard(
            icon: Icons.shopping_basket_rounded,
            label: 'Grocery\nList',
            backgroundColor: AppColors.warmBeige,
            onTap: onGroceryListTap,
          ),
        ],
      ),
    );
  }
}
