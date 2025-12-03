import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:myapp/Models/game.dart';

class CartService {
  static Database? _database;
  static const String _tableName = 'cart';

  /// Initialize the database
  static Future<void> init() async {
    if (_database != null) return;

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'cart.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE,
            image TEXT,
            price INTEGER,
            quantity INTEGER DEFAULT 1
          )
        ''');
      },
    );
  }

  /// Get the database instance
  Database get db {
    if (_database == null) {
      throw Exception('CartService not initialized. Call init() first.');
    }
    return _database!;
  }

  /// Add a game to cart (or increment quantity if exists)
  Future<void> addToCart(Game game) async {
    // Check if game already exists in cart
    final existing = await db.query(
      _tableName,
      where: 'name = ?',
      whereArgs: [game.name],
    );

    if (existing.isNotEmpty) {
      // Increment quantity
      await db.rawUpdate(
        'UPDATE $_tableName SET quantity = quantity + 1 WHERE name = ?',
        [game.name],
      );
    } else {
      // Insert new item
      await db.insert(_tableName, {
        ...game.toMap(),
        'quantity': 1,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  /// Remove a game from cart
  Future<void> removeFromCart(Game game) async {
    await db.delete(_tableName, where: 'name = ?', whereArgs: [game.name]);
  }

  /// Update quantity
  Future<void> updateQuantity(Game game, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(game);
    } else {
      await db.update(
        _tableName,
        {'quantity': quantity},
        where: 'name = ?',
        whereArgs: [game.name],
      );
    }
  }

  /// Get quantity of a game in cart
  Future<int> getQuantity(Game game) async {
    final result = await db.query(
      _tableName,
      columns: ['quantity'],
      where: 'name = ?',
      whereArgs: [game.name],
    );

    if (result.isEmpty) return 0;
    return result.first['quantity'] as int;
  }

  /// Check if game is in cart
  Future<bool> isInCart(Game game) async {
    final result = await db.query(
      _tableName,
      where: 'name = ?',
      whereArgs: [game.name],
    );
    return result.isNotEmpty;
  }

  /// Get all cart items
  Future<List<Map<String, dynamic>>> getCartItems() async {
    final result = await db.query(_tableName);
    return result.map((item) {
      return {'game': Game.fromMap(item), 'quantity': item['quantity'] as int};
    }).toList();
  }

  /// Get total price
  Future<int> getTotalPrice() async {
    final result = await db.rawQuery(
      'SELECT SUM(price * quantity) as total FROM $_tableName',
    );
    return (result.first['total'] as int?) ?? 0;
  }

  /// Get total items count
  Future<int> getItemCount() async {
    final result = await db.rawQuery(
      'SELECT SUM(quantity) as count FROM $_tableName',
    );
    return (result.first['count'] as int?) ?? 0;
  }

  /// Clear cart
  Future<void> clearCart() async {
    await db.delete(_tableName);
  }
}
