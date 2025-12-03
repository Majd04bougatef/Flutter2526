import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/Models/game.dart';

class FavoriteService {
  static const String _boxName = 'favorites';
  static Box<Game>? _box;

  /// Initialize Hive and open the favorites box
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(GameAdapter());
    _box = await Hive.openBox<Game>(_boxName);
  }

  /// Get the favorites box
  Box<Game> get box {
    if (_box == null || !_box!.isOpen) {
      throw Exception('FavoriteService not initialized. Call init() first.');
    }
    return _box!;
  }

  /// Add a game to favorites
  Future<void> addFavorite(Game game) async {
    // Use game name as key to avoid duplicates
    await box.put(game.name, game);
  }

  /// Remove a game from favorites
  Future<void> removeFavorite(Game game) async {
    await box.delete(game.name);
  }

  /// Check if a game is in favorites
  bool isFavorite(Game game) {
    return box.containsKey(game.name);
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(Game game) async {
    if (isFavorite(game)) {
      await removeFavorite(game);
      return false;
    } else {
      await addFavorite(game);
      return true;
    }
  }

  /// Get all favorite games
  List<Game> getAllFavorites() {
    return box.values.toList();
  }

  /// Clear all favorites
  Future<void> clearAll() async {
    await box.clear();
  }

  /// Get favorites count
  int get count => box.length;
}
