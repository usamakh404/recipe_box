# Recipe Box

A warm, editorial-feeling recipe app: discover, save, add, organize, and cook from your own digital recipe box.

## Getting started

```bash
flutter pub get
flutter run
```

The app runs immediately with **sample recipes** even without Firebase configured — `MockRecipeRepository` kicks in automatically (see "Connecting Firebase" below).

## Project structure

```
lib/
├── main.dart                     # Entry point: Firebase init + Provider wiring
├── firebase_options.dart         # PLACEHOLDER — replace via `flutterfire configure`
├── app/
│   ├── app.dart                  # MaterialApp.router
│   ├── router.dart               # go_router config (bottom-nav shell + recipe detail route)
│   └── theme/                    # Centralized colors, typography, ThemeData
├── core/
│   ├── constants/app_spacing.dart
│   └── widgets/                  # Shared building blocks (buttons, cards, states, nav shell)
├── features/
│   ├── home/                     # Home screen + its sections
│   ├── recipes/                  # Recipe model, repository, detail screen, my-recipes
│   ├── search/                   # Search screen with filter chips
│   ├── favorites/                # FavoritesProvider (local persistence)
│   ├── add_recipe/               # Sectioned add-recipe form
│   ├── grocery/                  # Reserved for the grocery list feature (not yet built)
│   └── profile/                  # Placeholder profile screen
└── services/firebase/            # Firebase bootstrap wrapper
```

## Connecting Firebase

This skeleton is wired for Firestore but ships with a placeholder `firebase_options.dart` since real config requires *your* Firebase project. To connect it:

1. Create a project at https://console.firebase.google.com
2. Install the FlutterFire CLI: `dart pub global activate flutterfire_cli`
3. From the project root: `flutterfire configure` — this overwrites `lib/firebase_options.dart` with your real config and registers your platforms.
4. Create a Firestore collection named `recipes`. Each document should match the shape in `Recipe.toMap()` (see `lib/features/recipes/models/recipe.dart`).
5. Run the app — `main.dart` will detect a successful Firebase init and automatically switch from `MockRecipeRepository` to `FirestoreRecipeRepository`. No other code changes needed.

## What's implemented

- Centralized theme (colors, Playfair Display + DM Sans typography, Material 3 `ThemeData`)
- Bottom-nav shell (Home, Search, Add Recipe, My Recipes, Profile) via `go_router`'s `StatefulShellRoute`
- Home screen: header, search entry point, hero banner, quick access, featured recipes (live from repository), dinner-ideas CTA
- Recipe detail screen (image, metadata, ingredients, instructions, favorite toggle)
- Search with text + filter-chip filtering
- Add Recipe form (sectioned: basics, ingredients, instructions, details/tags)
- Favorites, persisted locally via `SharedPreferences`
- Loading / empty / error states throughout

## Known gaps to build next

- **Grocery List** — directory reserved (`lib/features/grocery/`), not yet implemented (see product spec §12)
- **Recently Viewed** — needs a small local history store, same shape as `FavoritesProvider`
- **Auth / Profile** — no accounts yet; `My Recipes` currently shows all recipes rather than filtering by owner
- **Image upload** — Add Recipe currently takes an image URL; wiring a real photo picker + Firebase Storage upload is a self-contained follow-up
- **Dinner Ideas** — currently a stub CTA; needs a recommendation flow (e.g. "what's in your fridge" input)

## A note on Flutter version compatibility

A couple of APIs used here (`CardThemeData`, `Color.withOpacity`) have shifted across recent Flutter versions. If `flutter pub get`/`flutter run` reports a type mismatch on `CardThemeData` in `app_theme.dart`, swap it for `CardTheme` (older SDKs) — everything else in the file is unaffected.
