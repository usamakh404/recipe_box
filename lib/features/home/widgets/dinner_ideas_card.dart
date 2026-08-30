import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class DinnerIdeasCard extends StatelessWidget {
  const DinnerIdeasCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryGreen,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'What\u2019s for dinner?',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.white,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Get recipe ideas based on what you have on hand.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.white.withValues(alpha: 0.85),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.goldenAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
