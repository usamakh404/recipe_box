import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/bottom_nav_shell.dart';
import '../features/add_recipe/add_recipe_screen.dart';
import '../features/home/home_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/recipes/models/recipe.dart';
import '../features/recipes/recipe_detail_screen.dart';
import '../features/recipes/my_recipes_screen.dart';
import '../features/search/search_screen.dart';

/// Route paths, centralized so screens navigate via named constants
/// instead of hardcoded strings scattered through the app.
abstract final class AppRoutes {
  static const home = '/';
  static const search = '/search';
  static const addRecipe = '/add-recipe';
  static const myRecipes = '/my-recipes';
  static const profile = '/profile';
  static const recipeDetail = '/recipe';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BottomNavShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.search,
            builder: (context, state) => const SearchScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.addRecipe,
            builder: (context, state) => const AddRecipeScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.myRecipes,
            builder: (context, state) => const MyRecipesScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ]),
      ],
    ),
    // Recipe detail is pushed full-screen on top of the shell (not a tab).
    GoRoute(
      path: '${AppRoutes.recipeDetail}/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final recipe = state.extra as Recipe?;
        final id = state.pathParameters['id']!;
        return RecipeDetailScreen(recipeId: id, recipe: recipe);
      },
    ),
  ],
);
