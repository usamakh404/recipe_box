import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'core/config/api_config.dart';
import 'features/favorites/favorites_provider.dart';
import 'features/recipes/data/recipe_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final favoritesProvider = FavoritesProvider();
  await favoritesProvider.load();

  runApp(
    MultiProvider(
      providers: [
        // Switch to `MockRecipeRepository()` if you want to preview UI
        // without the Laravel API running — see lib/core/config/api_config.dart
        // for where the API URL is set.
        Provider<RecipeRepository>(
          create: (_) => ApiRecipeRepository(baseUrl: apiBaseUrl),
        ),
        ChangeNotifierProvider<FavoritesProvider>.value(
          value: favoritesProvider,
        ),
      ],
      child: const RecipeBoxApp(),
    ),
  );
}
