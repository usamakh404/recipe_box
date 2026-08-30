import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Standardized food-photo treatment used on cards and the detail screen:
/// correct aspect ratio, rounded corners, shimmer-free placeholder, and a
/// friendly fallback if the image fails to load.
class RecipeImage extends StatelessWidget {
  const RecipeImage({
    super.key,
    required this.imageUrl,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.aspectRatio = 4 / 3,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final BorderRadius borderRadius;
  final double aspectRatio;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: imageUrl.isEmpty
            ? _placeholder()
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: fit,
                placeholder: (context, url) => _placeholder(),
                errorWidget: (context, url, error) => _errorPlaceholder(),
              ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.surfaceCream,
      child: const Center(
        child: Icon(
          Icons.restaurant_menu_rounded,
          color: AppColors.mutedText,
          size: 28,
        ),
      ),
    );
  }

  Widget _errorPlaceholder() {
    return Container(
      color: AppColors.surfaceCream,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.mutedText,
          size: 28,
        ),
      ),
    );
  }
}
