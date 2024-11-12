import 'package:quick_card/repository/tables/shopping_list_table.dart';
import 'package:quick_card/entity/shopping_list.dart';
import 'package:sqflite/sqflite.dart';
import 'database_provider.dart';

class ShoppingListRepository {
  // Create new ShoppingList
  Future<int> createShoppingList(ShoppingList shoppingList) async {
    final db = await DatabaseProvider().database;
    return await db.insert(
      ShoppingListTable.tableName,
      shoppingList.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get ShoppingList by id
  Future<ShoppingList?> getShoppingListById(int id) async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> maps = await db.query(
      ShoppingListTable.tableName,
      where: '${ShoppingListTable.columnId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return ShoppingList.fromMap(maps.first);
    }
    return null;
  }

  // Get all ShoppingLists by User id
  Future<List<ShoppingList>> getShoppingListsByUserId(int userId) async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> maps = await db.query(
      ShoppingListTable.tableName,
      where: '${ShoppingListTable.columnUserId} = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => ShoppingList.fromMap(maps[i]));
  }

  // Update ShoppingList
  Future<int> updateShoppingList(ShoppingList shoppingList) async {
    final db = await DatabaseProvider().database;
    return await db.update(
      ShoppingListTable.tableName,
      shoppingList.toMap(),
      where: '${ShoppingListTable.columnId} = ?',
      whereArgs: [shoppingList.id],
    );
  }

  // Delete ShoppingList by id
  Future<int> deleteShoppingList(int id) async {
    final db = await DatabaseProvider().database;
    return await db.delete(
      ShoppingListTable.tableName,
      where: '${ShoppingListTable.columnId} = ?',
      whereArgs: [id],
    );
  }
}
