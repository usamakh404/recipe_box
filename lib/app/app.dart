import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/app_theme.dart';

class RecipeBoxApp extends StatelessWidget {
  const RecipeBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Recipe Box',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
