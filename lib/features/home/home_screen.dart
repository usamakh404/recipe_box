import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/app_search_bar.dart';
import '../recipes/models/recipe.dart';
import 'widgets/dinner_ideas_card.dart';
import 'widgets/featured_recipes_section.dart';
import 'widgets/hero_banner.dart';
import 'widgets/home_header.dart';
import 'widgets/quick_access_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        onRefresh: () async {
          // RecipeRepository streams push updates automatically; this just
          // gives users the pull-to-refresh gesture they expect.
          await Future<void>.delayed(const Duration(milliseconds: 400));
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.md,
          ),
          children: [
            HomeHeader(
              onMenuTap: () {},
              onNotificationsTap: () {},
            ),
            const SizedBox(height: AppSpacing.lg),
            AppSearchBar(
              readOnly: true,
              onTap: () => context.go(AppRoutes.search),
            ),
            const SizedBox(height: AppSpacing.lg),
            HeroBanner(
              imageUrl:
                  'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=1000',
              onCtaTap: () => context.go(AppRoutes.search),
            ),
            const SizedBox(height: AppSpacing.xl),
            QuickAccessSection(
              onFavoritesTap: () => _showComingSoon(context, 'Favorites'),
              onRecentlyViewedTap: () =>
                  _showComingSoon(context, 'Recently Viewed'),
              onMyRecipesTap: () => context.go(AppRoutes.myRecipes),
              onGroceryListTap: () =>
                  _showComingSoon(context, 'Grocery List'),
            ),
            const SizedBox(height: AppSpacing.xl),
            FeaturedRecipesSection(
              onSeeAllTap: () => context.go(AppRoutes.search),
              onRecipeTap: (recipe) => _openRecipeDetail(context, recipe),
            ),
            const SizedBox(height: AppSpacing.xl),
            DinnerIdeasCard(
              onTap: () => _showComingSoon(context, 'Dinner ideas'),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  void _openRecipeDetail(BuildContext context, Recipe recipe) {
    context.push('${AppRoutes.recipeDetail}/${recipe.id}', extra: recipe);
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature is coming soon.')),
    );
  }
}
