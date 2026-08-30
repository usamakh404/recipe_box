import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// A small circular favorite toggle with a subtle scale animation.
///
/// Purely presentational — callers own the favorite state and pass
/// [isFavorite] + [onToggle] (typically backed by `FavoritesProvider`).
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onToggle,
    this.size = 36,
  });

  final bool isFavorite;
  final VoidCallback onToggle;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: isFavorite ? 'Remove from favorites' : 'Save to favorites',
      child: Material(
        color: AppColors.white.withValues(alpha: 0.9),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onToggle,
          child: SizedBox(
            width: size,
            height: size,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                key: ValueKey(isFavorite),
                color: isFavorite ? AppColors.terracotta : AppColors.textPrimary,
                size: size * 0.55,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
