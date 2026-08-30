import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/favorite_button.dart';
import '../../../core/widgets/recipe_image.dart';
import '../models/recipe.dart';

/// Horizontal row layout for recipe lists (search results, recently
/// viewed, "my recipes"): small square image, details, favorite action.
class RecipeHorizontalCard extends StatelessWidget {
  const RecipeHorizontalCard({
    super.key,
    required this.recipe,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  final Recipe recipe;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(
                width: 88,
                child: RecipeImage(
                  imageUrl: recipe.imageUrl,
                  aspectRatio: 1,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recipe.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.schedule_rounded,
                            size: 13, color: AppColors.mutedText),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.totalTime.inMinutes} min · ${recipe.difficulty.label}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              FavoriteButton(
                isFavorite: isFavorite,
                onToggle: onFavoriteToggle,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
