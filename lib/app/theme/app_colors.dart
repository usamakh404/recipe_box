import 'package:flutter/material.dart';

/// Centralized Recipe Box color palette.
///
/// Every widget should pull colors from here (or from [ThemeData] built
/// with these values) rather than hardcoding hex values inline.
abstract final class AppColors {
  // Brand greens
  static const Color primaryGreen = Color(0xFF294522);
  static const Color darkGreen = Color(0xFF20381C);
  static const Color softGreen = Color(0xFFE5E8D6);

  // Neutrals / surfaces
  static const Color backgroundCream = Color(0xFFFDFBF5);
  static const Color surfaceCream = Color(0xFFF3EEE2);
  static const Color warmBeige = Color(0xFFE8DDC8);

  // Accents
  static const Color goldenAccent = Color(0xFFA76A13);
  static const Color terracotta = Color(0xFFB64B31);

  // Text
  static const Color textPrimary = Color(0xFF292823);
  static const Color textSecondary = Color(0xFF69675F);
  static const Color mutedText = Color(0xFF8A877D);

  // Base
  static const Color white = Color(0xFFFFFFFF);

  // Semantic
  static const Color error = terracotta;
  static const Color success = primaryGreen;
  static const Color divider = Color(0xFFE3DCCB);

  // Difficulty chips
  static const Color difficultyEasy = softGreen;
  static const Color difficultyMedium = warmBeige;
  static const Color difficultyHard = Color(0xFFEBD3CB);
}
