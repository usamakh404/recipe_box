import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/router.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../favorites/favorites_provider.dart';
import 'data/recipe_repository.dart';
import 'models/recipe.dart';
import 'widgets/recipe_horizontal_card.dart';

/// Shows the recipes the user has added.
///
/// NOTE: there's no auth/user-account layer yet, so this currently lists
/// every recipe in the repository. Once accounts are added, filter by
/// `recipe.author == currentUser.id` (or a dedicated `ownerId` field).
class MyRecipesScreen extends StatelessWidget {
  const MyRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = context.watch<RecipeRepository>();
    final favorites = context.watch<FavoritesProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            Text('My Recipes', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: StreamBuilder<List<Recipe>>(
                stream: repository.watchAllRecipes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final recipes = snapshot.data ?? const <Recipe>[];
                  if (recipes.isEmpty) {
                    return EmptyState(
                      icon: Icons.menu_book_rounded,
                      title: 'No recipes yet',
                      message: 'Recipes you add will show up here.',
                      actionLabel: 'Add a recipe',
                      onAction: () => context.go(AppRoutes.addRecipe),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    itemCount: recipes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return RecipeHorizontalCard(
                        recipe: recipe,
                        isFavorite: favorites.isFavorite(recipe.id),
                        onFavoriteToggle: () => favorites.toggle(recipe.id),
                        onTap: () => context.push(
                          '${AppRoutes.recipeDetail}/${recipe.id}',
                          extra: recipe,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
