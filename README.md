# Recipe Box

A warm, editorial-feeling recipe app: discover, save, add, organize, and cook from your own digital recipe box.

## Getting started

```bash
flutter pub get
```

Then point the app at your backend — edit `lib/core/config/api_config.dart` and set `apiBaseUrl` to your deployed Laravel API's URL (see the companion `recipe_box_api` project). Once your backend is running:

```bash
flutter run
```

No backend running yet? Swap `ApiRecipeRepository` for `MockRecipeRepository` in `lib/main.dart` to preview the UI with 6 built-in sample recipes and no network calls.

## Project structure

```
lib/
├── main.dart                     # Entry point: provider wiring
├── app/
│   ├── app.dart                  # MaterialApp.router
│   ├── router.dart               # go_router config (bottom-nav shell + recipe detail route)
│   └── theme/                    # Centralized colors, typography, ThemeData
├── core/
│   ├── config/api_config.dart    # Backend URL — the one line to edit per environment
│   ├── constants/app_spacing.dart
│   └── widgets/                  # Shared building blocks (buttons, cards, states, nav shell)
└── features/
    ├── home/                     # Home screen + its sections
    ├── recipes/                  # Recipe model, repository (API + mock), detail screen, my-recipes
    ├── search/                   # Search screen with filter chips
    ├── favorites/                # FavoritesProvider (local persistence)
    ├── add_recipe/               # Sectioned add-recipe form
    ├── grocery/                  # Reserved for the grocery list feature (not yet built)
    └── profile/                  # Placeholder profile screen
```

## Backend

The app talks to a companion Laravel + MySQL API — see the `recipe_box_api` project and its own README for setup (scaffolding, migrations, seeding, and deployment to shared hosting).

`RecipeRepository` is an interface with two implementations:
- `ApiRecipeRepository` — talks to the Laravel API over HTTP. Used by default.
- `MockRecipeRepository` — in-memory sample data, no network. Handy for UI work when the backend isn't running.

Only `lib/main.dart` decides which one is used — no screen code changes when switching.

## What's implemented

- Centralized theme (colors, Playfair Display + DM Sans typography, Material 3 `ThemeData`)
- Bottom-nav shell (Home, Search, Add Recipe, My Recipes, Profile) via `go_router`'s `StatefulShellRoute`
- Home screen: header, search entry point, hero banner, quick access, featured recipes (live from the API), dinner-ideas CTA
- Recipe detail screen (image, metadata, ingredients, instructions, favorite toggle)
- Search with text + filter-chip filtering
- Add Recipe form (sectioned: basics, ingredients, instructions, details/tags) — saves via `POST /api/recipes`
- Favorites, persisted locally via `SharedPreferences`
- Loading / empty / error states throughout

## Known gaps to build next

- **Grocery List** — directory reserved (`lib/features/grocery/`), not yet implemented
- **Recently Viewed** — needs a small local history store, same shape as `FavoritesProvider`
- **Auth / Profile** — the Laravel API has register/login/logout endpoints ready (Sanctum), but the app doesn't call them yet — `My Recipes` currently shows all recipes rather than filtering by owner
- **Image upload** — Add Recipe currently takes an image URL; wiring a real photo picker + server-side upload is a self-contained follow-up
- **Dinner Ideas** — currently a stub CTA; needs a recommendation flow (e.g. "what's in your fridge" input)
- **Live updates** — recipe lists refetch on rebuild rather than pushing live changes (HTTP has no Firestore-style listener); fine for this app's scale, but worth knowing

## A note on Flutter version compatibility

A couple of APIs used here (`CardThemeData`) have shifted across recent Flutter versions. If `flutter pub get`/`flutter run` reports a type mismatch on `CardThemeData` in `app_theme.dart`, swap it for `CardTheme` (older SDKs) — everything else in the file is unaffected.
