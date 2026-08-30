import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/favorite_button.dart';
import '../../../core/widgets/recipe_image.dart';
import '../models/recipe.dart';

/// Vertical card for "Featured Recipes" grids/carousels: image on top,
/// title + metadata below, favorite button overlaid on the photo.
class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
    this.width = 200,
  });

  final Recipe recipe;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    RecipeImage(imageUrl: recipe.imageUrl),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: FavoriteButton(
                        isFavorite: isFavorite,
                        onToggle: onFavoriteToggle,
                        size: 32,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  recipe.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.schedule_rounded,
                        size: 14, color: AppColors.mutedText),
                    const SizedBox(width: 4),
                    Text(
                      '${recipe.totalTime.inMinutes} min',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 10),
                    _DifficultyDot(difficulty: recipe.difficulty),
                    const SizedBox(width: 4),
                    Text(
                      recipe.difficulty.label,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DifficultyDot extends StatelessWidget {
  const _DifficultyDot({required this.difficulty});

  final RecipeDifficulty difficulty;

  @override
  Widget build(BuildContext context) {
    final color = switch (difficulty) {
      RecipeDifficulty.easy => AppColors.primaryGreen,
      RecipeDifficulty.medium => AppColors.goldenAccent,
      RecipeDifficulty.hard => AppColors.terracotta,
    };
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
