import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'features/favorites/favorites_provider.dart';
import 'features/recipes/data/recipe_repository.dart';
import 'services/firebase/firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final firebaseReady = await FirebaseService.initialize();

  final favoritesProvider = FavoritesProvider();
  await favoritesProvider.load();

  runApp(
    MultiProvider(
      providers: [
        Provider<RecipeRepository>(
          create: (_) => firebaseReady
              ? FirestoreRecipeRepository()
              : MockRecipeRepository(),
        ),
        ChangeNotifierProvider<FavoritesProvider>.value(
          value: favoritesProvider,
        ),
      ],
      child: const RecipeBoxApp(),
    ),
  );
}
