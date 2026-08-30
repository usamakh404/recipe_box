import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/router.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/app_search_bar.dart';
import '../../core/widgets/empty_state.dart';
import '../favorites/favorites_provider.dart';
import '../recipes/data/recipe_repository.dart';
import '../recipes/models/recipe.dart';
import '../recipes/widgets/recipe_horizontal_card.dart';

const _filters = [
  'Breakfast',
  'Lunch',
  'Dinner',
  'Dessert',
  'Vegetarian',
  'Quick',
  'Easy',
  'High-protein',
  'Favorites',
];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  final Set<String> _activeFilters = {};

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            Text('Search', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: AppSpacing.md),
            AppSearchBar(
              controller: _controller,
              autofocus: false,
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _activeFilters.contains(filter);
                  return FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    showCheckmark: false,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: isSelected ? Colors.white : null,
                        ),
                    onSelected: (selected) => setState(() {
                      selected ? _activeFilters.add(filter) : _activeFilters.remove(filter);
                    }),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: StreamBuilder<List<Recipe>>(
                stream: repository.watchAllRecipes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final all = snapshot.data ?? const <Recipe>[];
                  final results = _filterRecipes(all, favorites);

                  if (results.isEmpty) {
                    return const EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'No recipes found',
                      message: 'Try a different search term or filter.',
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final recipe = results[index];
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

  List<Recipe> _filterRecipes(List<Recipe> recipes, FavoritesProvider favorites) {
    return recipes.where((recipe) {
      final matchesQuery = _query.isEmpty ||
          recipe.title.toLowerCase().contains(_query.toLowerCase()) ||
          recipe.ingredients.any((i) => i.toLowerCase().contains(_query.toLowerCase())) ||
          recipe.cuisine.toLowerCase().contains(_query.toLowerCase());

      if (!matchesQuery) return false;
      if (_activeFilters.isEmpty) return true;

      return _activeFilters.every((filter) {
        if (filter == 'Favorites') return favorites.isFavorite(recipe.id);
        final normalized = filter.toLowerCase();
        return recipe.mealType.toLowerCase() == normalized ||
            recipe.tags.map((t) => t.toLowerCase()).contains(normalized) ||
            recipe.difficulty.label.toLowerCase() == normalized;
      });
    }).toList();
  }
}
