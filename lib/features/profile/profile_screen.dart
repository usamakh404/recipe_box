import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/constants/app_spacing.dart';

/// Placeholder Profile screen.
///
/// TODO(auth): once accounts exist, this becomes the home for sign-in,
/// display name/avatar, and account settings.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            Text('Profile', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: AppSpacing.xl),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: AppColors.softGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_rounded, color: AppColors.primaryGreen, size: 32),
                    ),
                    const SizedBox(height: 16),
                    Text('Sign in coming soon', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 6),
                    Text(
                      'Your account, settings, and preferences will live here.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
