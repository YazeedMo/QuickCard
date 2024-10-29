import 'package:quick_card/data/tables/shopping_list_table.dart';
import 'package:quick_card/entity/shopping_list.dart';
import 'package:sqflite/sqflite.dart';
import 'database_provider.dart';

class ShoppingListRepository {
  // Insert a new shopping list into the database
  Future<int> insertShoppingList(ShoppingList shoppingList) async {
    final db = await DatabaseProvider().database;
    return await db.insert(
      ShoppingListTable.tableName,
      shoppingList.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all shopping lists for a specific user
  Future<List<ShoppingList>> getShoppingListsByUserId(int userId) async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> maps = await db.query(
      ShoppingListTable.tableName,
      where: '${ShoppingListTable.columnUserId} = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => ShoppingList.fromMap(maps[i]));
  }

  // Update a shopping list
  Future<int> updateShoppingList(ShoppingList shoppingList) async {
    final db = await DatabaseProvider().database;
    return await db.update(
      ShoppingListTable.tableName,
      shoppingList.toMap(),
      where: '${ShoppingListTable.columnId} = ?',
      whereArgs: [shoppingList.id],
    );
  }

  // Delete a shopping list by ID
  Future<int> deleteShoppingList(int id) async {
    final db = await DatabaseProvider().database;
    return await db.delete(
      ShoppingListTable.tableName,
      where: '${ShoppingListTable.columnId} = ?',
      whereArgs: [id],
    );
  }
}
