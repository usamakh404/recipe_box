import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/recipe_image.dart';

/// The large editorial banner near the top of Home: heading, supporting
/// copy, a CTA, and a food photo. Kept as a single self-contained widget
/// since it's specific to Home and unlikely to be reused elsewhere.
class HeroBanner extends StatelessWidget {
  const HeroBanner({
    super.key,
    required this.imageUrl,
    required this.onCtaTap,
  });

  final String imageUrl;
  final VoidCallback onCtaTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        children: [
          RecipeImage(
            imageUrl: imageUrl,
            aspectRatio: 16 / 11,
            borderRadius: BorderRadius.zero,
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.darkGreen.withValues(alpha: 0.78),
                    AppColors.darkGreen.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Find recipes\nyou\u2019ll love',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.white,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Simple ingredients, delicious results.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onCtaTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.textPrimary,
                    minimumSize: const Size(140, 44),
                  ),
                  child: const Text('Explore recipes'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
