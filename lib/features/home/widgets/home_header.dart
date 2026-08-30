import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.onMenuTap,
    this.onNotificationsTap,
  });

  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleIconButton(
          icon: Icons.menu_rounded,
          semanticLabel: 'Open menu',
          onTap: onMenuTap,
        ),
        const Spacer(),
        Text(
          'Recipe Box',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const Spacer(),
        _CircleIconButton(
          icon: Icons.notifications_none_rounded,
          semanticLabel: 'Notifications',
          onTap: onNotificationsTap,
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.semanticLabel,
    this.onTap,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceCream,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Semantics(
            button: true,
            label: semanticLabel,
            child: Icon(icon, color: AppColors.textPrimary, size: 22),
          ),
        ),
      ),
    );
  }
}
