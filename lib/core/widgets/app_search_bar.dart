import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// The rounded "Search recipes..." field used on Home and the Search
/// screen. Read-only mode (via [onTap]) lets Home hand off to the full
/// Search screen instead of trying to own search logic itself.
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search recipes...',
    this.onTap,
    this.onChanged,
    this.readOnly = false,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      autofocus: autofocus,
      onTap: onTap,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.mutedText,
        ),
      ),
    );
  }
}
