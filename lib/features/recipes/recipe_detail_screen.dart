import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/favorite_button.dart';
import '../../core/widgets/recipe_image.dart';
import '../favorites/favorites_provider.dart';
import 'data/recipe_repository.dart';
import 'models/recipe.dart';

/// Full recipe view — reads like a page from a modern digital cookbook.
///
/// Accepts an optional [recipe] passed via navigation `extra` for an
/// instant render; falls back to fetching by [recipeId] (e.g. on deep
/// link / cold start where `extra` isn't available).
class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key, required this.recipeId, this.recipe});

  final String recipeId;
  final Recipe? recipe;

  @override
  Widget build(BuildContext context) {
    if (recipe != null) {
      return _RecipeDetailContent(recipe: recipe!);
    }

    final repository = context.read<RecipeRepository>();
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      body: FutureBuilder<Recipe?>(
        future: repository.getRecipeById(recipeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return const SafeArea(
              child: AppErrorState(
                title: "Recipe not found",
                message: "This recipe may have been removed.",
              ),
            );
          }
          return _RecipeDetailContent(recipe: snapshot.data!);
        },
      ),
    );
  }
}

class _RecipeDetailContent extends StatelessWidget {
  const _RecipeDetailContent({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final isFavorite = favorites.isFavorite(recipe.id);

    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            backgroundColor: AppColors.backgroundCream,
            surfaceTintColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: _RoundIconButton(
                icon: Icons.arrow_back_rounded,
                label: 'Back',
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: FavoriteButton(
                  isFavorite: isFavorite,
                  onToggle: () => favorites.toggle(recipe.id),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: RecipeImage(
                imageUrl: recipe.imageUrl,
                borderRadius: BorderRadius.zero,
                aspectRatio: 4 / 3,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.title, style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(height: 8),
                  Text(recipe.description, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 20),
                  _MetaRow(recipe: recipe),
                  const SizedBox(height: 28),
                  Text('Ingredients', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  ...recipe.ingredients.map((i) => _IngredientRow(text: i)),
                  const SizedBox(height: 28),
                  Text('Instructions', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  ...recipe.instructions.asMap().entries.map(
                        (e) => _InstructionRow(step: e.key + 1, text: e.value),
                      ),
                  if (recipe.notes.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    Text('Notes', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(recipe.notes, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetaItem(
            icon: Icons.schedule_rounded,
            label: 'Total time',
            value: '${recipe.totalTime.inMinutes} min',
          ),
        ),
        Expanded(
          child: _MetaItem(
            icon: Icons.people_alt_rounded,
            label: 'Servings',
            value: '${recipe.servings}',
          ),
        ),
        Expanded(
          child: _MetaItem(
            icon: Icons.bar_chart_rounded,
            label: 'Difficulty',
            value: recipe.difficulty.label,
          ),
        ),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primaryGreen),
        const SizedBox(height: 6),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.goldenAccent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}

class _InstructionRow extends StatelessWidget {
  const _InstructionRow({required this.step, required this.text});

  final int step;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.softGreen,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$step',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white.withOpacity(0.9),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Semantics(
            button: true,
            label: label,
            child: Icon(icon, size: 20, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
