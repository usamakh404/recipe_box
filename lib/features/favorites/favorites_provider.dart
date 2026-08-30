import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tracks which recipe ids are favorited.
///
/// Persisted locally via [SharedPreferences] for now. When accounts/sync
/// are added, this is the seam to swap in a Firestore-backed store without
/// touching any UI code — screens only ever call [isFavorite]/[toggle].
class FavoritesProvider extends ChangeNotifier {
  static const _prefsKey = 'favorite_recipe_ids';

  final Set<String> _favoriteIds = {};
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteIds
      ..clear()
      ..addAll(prefs.getStringList(_prefsKey) ?? const []);
    _isLoaded = true;
    notifyListeners();
  }

  bool isFavorite(String recipeId) => _favoriteIds.contains(recipeId);

  Future<void> toggle(String recipeId) async {
    if (_favoriteIds.contains(recipeId)) {
      _favoriteIds.remove(recipeId);
    } else {
      _favoriteIds.add(recipeId);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, _favoriteIds.toList());
  }
}
