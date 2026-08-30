import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/recipe.dart';

/// Abstraction over "where recipes come from" so screens never talk to
/// Firestore (or any backend) directly.
abstract class RecipeRepository {
  Stream<List<Recipe>> watchFeaturedRecipes();
  Stream<List<Recipe>> watchAllRecipes();
  Future<Recipe?> getRecipeById(String id);
  Future<void> addRecipe(Recipe recipe);
}

/// Firestore-backed implementation.
///
/// Expects a top-level `recipes` collection where each document matches
/// [Recipe.toMap]. "Featured" is currently just the most recently created
/// recipes — swap the query for a `featured: true` flag once curation is
/// needed.
class FirestoreRecipeRepository implements RecipeRepository {
  FirestoreRecipeRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _recipes =>
      _firestore.collection('recipes');

  @override
  Stream<List<Recipe>> watchFeaturedRecipes() {
    return _recipes
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .map(_snapshotToRecipes);
  }

  @override
  Stream<List<Recipe>> watchAllRecipes() {
    return _recipes
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_snapshotToRecipes);
  }

  @override
  Future<Recipe?> getRecipeById(String id) async {
    final doc = await _recipes.doc(id).get();
    if (!doc.exists) return null;
    return Recipe.fromMap(doc.id, doc.data()!);
  }

  @override
  Future<void> addRecipe(Recipe recipe) async {
    await _recipes.add(recipe.toMap());
  }

  List<Recipe> _snapshotToRecipes(QuerySnapshot<Map<String, dynamic>> snap) {
    return snap.docs.map((d) => Recipe.fromMap(d.id, d.data())).toList();
  }
}

/// In-memory implementation used until a Firebase project is connected
/// (or for widget tests/design review). Swapped in automatically by
/// `main.dart` when Firebase fails to initialize.
class MockRecipeRepository implements RecipeRepository {
  final List<Recipe> _recipes = _sampleRecipes();

  @override
  Stream<List<Recipe>> watchFeaturedRecipes() =>
      Stream.value(_recipes.take(6).toList());

  @override
  Stream<List<Recipe>> watchAllRecipes() => Stream.value(_recipes);

  @override
  Future<Recipe?> getRecipeById(String id) async {
    try {
      return _recipes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addRecipe(Recipe recipe) async {
    _recipes.insert(0, recipe);
  }

  static List<Recipe> _sampleRecipes() {
    final now = DateTime.now();
    return [
      Recipe(
        id: 'r1',
        title: 'Lemon Herb Roast Chicken',
        description:
            'A juicy weeknight roast chicken brightened with lemon, garlic, and fresh herbs.',
        imageUrl:
            'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=800',
        author: 'Recipe Box',
        prepTimeMinutes: 15,
        cookTimeMinutes: 60,
        servings: 4,
        difficulty: RecipeDifficulty.medium,
        ingredients: const [
          '1 whole chicken (about 4 lb)',
          '2 lemons',
          '4 cloves garlic',
          '2 tbsp olive oil',
          'Fresh thyme and rosemary',
          'Salt and pepper',
        ],
        instructions: const [
          'Preheat oven to 425°F (220°C).',
          'Pat chicken dry and season generously inside and out.',
          'Stuff cavity with halved lemon, garlic, and herbs.',
          'Roast for 60 minutes until juices run clear.',
          'Rest for 10 minutes before carving.',
        ],
        tags: const ['dinner', 'high-protein'],
        cuisine: 'American',
        mealType: 'Dinner',
        createdAt: now,
        updatedAt: now,
      ),
      Recipe(
        id: 'r2',
        title: 'Creamy Tomato Basil Pasta',
        description:
            'A quick, comforting pasta with a silky tomato-basil sauce.',
        imageUrl:
            'https://images.unsplash.com/photo-1608219992759-8d74ed8d76eb?w=800',
        author: 'Recipe Box',
        prepTimeMinutes: 10,
        cookTimeMinutes: 20,
        servings: 3,
        difficulty: RecipeDifficulty.easy,
        ingredients: const [
          '12 oz pasta',
          '2 cups crushed tomatoes',
          '1/2 cup cream',
          'Fresh basil',
          '2 cloves garlic',
          'Parmesan, to serve',
        ],
        instructions: const [
          'Cook pasta until al dente.',
          'Sauté garlic, add tomatoes, simmer 10 minutes.',
          'Stir in cream and torn basil.',
          'Toss with pasta and finish with Parmesan.',
        ],
        tags: const ['dinner', 'vegetarian', 'quick'],
        cuisine: 'Italian',
        mealType: 'Dinner',
        createdAt: now,
        updatedAt: now,
      ),
      Recipe(
        id: 'r3',
        title: 'Fluffy Buttermilk Pancakes',
        description: 'Weekend-morning pancakes, soft in the middle with crisp edges.',
        imageUrl:
            'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800',
        author: 'Recipe Box',
        prepTimeMinutes: 10,
        cookTimeMinutes: 15,
        servings: 4,
        difficulty: RecipeDifficulty.easy,
        ingredients: const [
          '2 cups flour',
          '2 tbsp sugar',
          '2 tsp baking powder',
          '2 cups buttermilk',
          '2 eggs',
          '1/4 cup melted butter',
        ],
        instructions: const [
          'Whisk dry ingredients together.',
          'Whisk wet ingredients, then combine gently with dry.',
          'Cook on a buttered griddle until bubbles form, then flip.',
        ],
        tags: const ['breakfast', 'vegetarian'],
        cuisine: 'American',
        mealType: 'Breakfast',
        createdAt: now,
        updatedAt: now,
      ),
      Recipe(
        id: 'r4',
        title: 'Crispy Sesame Tofu Bowl',
        description: 'Crispy pan-fried tofu over rice with a sticky sesame glaze.',
        imageUrl:
            'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=800',
        author: 'Recipe Box',
        prepTimeMinutes: 15,
        cookTimeMinutes: 20,
        servings: 2,
        difficulty: RecipeDifficulty.medium,
        ingredients: const [
          '1 block firm tofu',
          '2 tbsp cornstarch',
          '3 tbsp soy sauce',
          '1 tbsp sesame oil',
          '1 tbsp honey',
          'Cooked rice, to serve',
        ],
        instructions: const [
          'Press and cube tofu, toss in cornstarch.',
          'Pan-fry until golden and crisp on all sides.',
          'Whisk sauce ingredients and toss with tofu.',
          'Serve over rice with sesame seeds and scallions.',
        ],
        tags: const ['dinner', 'vegetarian', 'high-protein'],
        cuisine: 'Asian',
        mealType: 'Dinner',
        createdAt: now,
        updatedAt: now,
      ),
      Recipe(
        id: 'r5',
        title: 'Chocolate Chip Skillet Cookie',
        description: 'A gooey, giant cookie baked in a skillet — best served warm.',
        imageUrl:
            'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=800',
        author: 'Recipe Box',
        prepTimeMinutes: 15,
        cookTimeMinutes: 25,
        servings: 6,
        difficulty: RecipeDifficulty.easy,
        ingredients: const [
          '1 cup butter, softened',
          '1 cup brown sugar',
          '2 cups flour',
          '1 egg',
          '1 1/2 cups chocolate chips',
        ],
        instructions: const [
          'Cream butter and sugar, beat in egg.',
          'Fold in flour and chocolate chips.',
          'Press into a skillet and bake at 350°F for 25 minutes.',
        ],
        tags: const ['dessert', 'vegetarian'],
        cuisine: 'American',
        mealType: 'Dessert',
        createdAt: now,
        updatedAt: now,
      ),
      Recipe(
        id: 'r6',
        title: '15-Minute Garlic Shrimp',
        description: 'Fast, punchy garlic-butter shrimp — ready before the rice is done.',
        imageUrl:
            'https://images.unsplash.com/photo-1633504581786-316c8002b1b9?w=800',
        author: 'Recipe Box',
        prepTimeMinutes: 5,
        cookTimeMinutes: 10,
        servings: 2,
        difficulty: RecipeDifficulty.easy,
        ingredients: const [
          '1 lb shrimp, peeled',
          '4 cloves garlic, minced',
          '3 tbsp butter',
          'Juice of 1 lemon',
          'Chopped parsley',
        ],
        instructions: const [
          'Melt butter, sauté garlic until fragrant.',
          'Add shrimp, cook 2–3 minutes per side.',
          'Finish with lemon juice and parsley.',
        ],
        tags: const ['dinner', 'quick', 'high-protein'],
        cuisine: 'Mediterranean',
        mealType: 'Dinner',
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
