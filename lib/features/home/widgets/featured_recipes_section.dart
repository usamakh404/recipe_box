import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/section_header.dart';
import '../../favorites/favorites_provider.dart';
import '../../recipes/data/recipe_repository.dart';
import '../../recipes/models/recipe.dart';
import '../../recipes/widgets/recipe_card.dart';

class FeaturedRecipesSection extends StatelessWidget {
  const FeaturedRecipesSection({
    super.key,
    required this.onSeeAllTap,
    required this.onRecipeTap,
  });

  final VoidCallback onSeeAllTap;
  final ValueChanged<Recipe> onRecipeTap;

  @override
  Widget build(BuildContext context) {
    final repository = context.watch<RecipeRepository>();
    final favorites = context.watch<FavoritesProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Featured Recipes',
          actionLabel: 'See all',
          onActionTap: onSeeAllTap,
        ),
        const SizedBox(height: 14),
        StreamBuilder<List<Recipe>>(
          stream: repository.watchFeaturedRecipes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 240,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return const SizedBox(
                height: 200,
                child: AppErrorState(
                  title: "Recipes didn't load",
                  message: 'Pull down to refresh, or try again shortly.',
                ),
              );
            }
            final recipes = snapshot.data ?? const [];
            if (recipes.isEmpty) {
              return const SizedBox(
                height: 200,
                child: EmptyState(
                  icon: Icons.restaurant_menu_rounded,
                  title: 'No recipes yet',
                  message: 'Add your first recipe to see it featured here.',
                ),
              );
            }
            return SizedBox(
              height: 240,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recipes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return RecipeCard(
                    recipe: recipe,
                    isFavorite: favorites.isFavorite(recipe.id),
                    onTap: () => onRecipeTap(recipe),
                    onFavoriteToggle: () => favorites.toggle(recipe.id),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
