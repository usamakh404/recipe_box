import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Editorial serif for display copy + clean sans for UI/body.
///
/// Usage: prefer `Theme.of(context).textTheme.*` in widgets so a future
/// palette/type change only touches this file.
abstract final class AppTypography {
  static TextTheme get textTheme => TextTheme(
        // Screen-level hero headings ("Find recipes you'll love")
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 34,
          height: 1.15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        // Section titles ("Featured Recipes", "Quick Access")
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 22,
          height: 1.2,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        // Recipe titles on cards / detail screen
        headlineSmall: GoogleFonts.playfairDisplay(
          fontSize: 18,
          height: 1.25,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        // Standard UI titles (app bar, dialogs)
        titleLarge: GoogleFonts.dmSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        // Body copy
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 16,
          height: 1.5,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 14,
          height: 1.5,
          color: AppColors.textSecondary,
        ),
        // Metadata: cook time, difficulty, dates
        bodySmall: GoogleFonts.dmSans(
          fontSize: 12,
          height: 1.4,
          color: AppColors.mutedText,
        ),
        // Buttons
        labelLarge: GoogleFonts.dmSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        labelMedium: GoogleFonts.dmSans(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      );
}
