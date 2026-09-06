/// Difficulty levels a recipe can be tagged with.
enum RecipeDifficulty {
  easy,
  medium,
  hard;

  String get label {
    switch (this) {
      case RecipeDifficulty.easy:
        return 'Easy';
      case RecipeDifficulty.medium:
        return 'Medium';
      case RecipeDifficulty.hard:
        return 'Hard';
    }
  }

  static RecipeDifficulty fromString(String? value) {
    return RecipeDifficulty.values.firstWhere(
      (d) => d.name == value,
      orElse: () => RecipeDifficulty.easy,
    );
  }
}

/// Core content model for Recipe Box.
///
/// Times are stored in minutes (not [Duration]) because that's the natural
/// representation coming from/going to the API; [prepTime]/[cookTime]/
/// [totalTime] expose them as [Duration] for convenient use in the UI.
class Recipe {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String author;

  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final RecipeDifficulty difficulty;

  final List<String> ingredients;
  final List<String> instructions;
  final String notes;
  final List<String> tags;
  final String cuisine;
  final String mealType;

  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.author,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.difficulty,
    required this.ingredients,
    required this.instructions,
    required this.tags,
    required this.cuisine,
    required this.mealType,
    required this.createdAt,
    required this.updatedAt,
    this.notes = '',
    this.isFavorite = false,
  });

  Duration get prepTime => Duration(minutes: prepTimeMinutes);
  Duration get cookTime => Duration(minutes: cookTimeMinutes);
  Duration get totalTime =>
      Duration(minutes: prepTimeMinutes + cookTimeMinutes);

  Recipe copyWith({bool? isFavorite}) {
    return Recipe(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      author: author,
      prepTimeMinutes: prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes,
      servings: servings,
      difficulty: difficulty,
      ingredients: ingredients,
      instructions: instructions,
      notes: notes,
      tags: tags,
      cuisine: cuisine,
      mealType: mealType,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory Recipe.fromMap(String id, Map<String, dynamic> map) {
    return Recipe(
      id: id,
      title: map['title'] as String? ?? 'Untitled recipe',
      description: map['description'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      author: map['author'] as String? ?? 'Recipe Box',
      prepTimeMinutes: (map['prepTimeMinutes'] as num?)?.toInt() ?? 0,
      cookTimeMinutes: (map['cookTimeMinutes'] as num?)?.toInt() ?? 0,
      servings: (map['servings'] as num?)?.toInt() ?? 1,
      difficulty: RecipeDifficulty.fromString(map['difficulty'] as String?),
      ingredients: List<String>.from(map['ingredients'] as List? ?? const []),
      instructions:
          List<String>.from(map['instructions'] as List? ?? const []),
      notes: map['notes'] as String? ?? '',
      tags: List<String>.from(map['tags'] as List? ?? const []),
      cuisine: map['cuisine'] as String? ?? '',
      mealType: map['mealType'] as String? ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'author': author,
      'prepTimeMinutes': prepTimeMinutes,
      'cookTimeMinutes': cookTimeMinutes,
      'servings': servings,
      'difficulty': difficulty.name,
      'ingredients': ingredients,
      'instructions': instructions,
      'notes': notes,
      'tags': tags,
      'cuisine': cuisine,
      'mealType': mealType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
