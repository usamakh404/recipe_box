import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// A section title with an optional "See all" action, used throughout the
/// app (Featured Recipes, Quick Access, Dinner Ideas, ...).
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onActionTap,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.goldenAccent,
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}
