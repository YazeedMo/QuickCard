import 'package:quick_card/data/tables/item_table.dart';
import 'package:quick_card/entity/item.dart';
import 'package:sqflite/sqflite.dart';
import 'database_provider.dart';

class ItemRepository {
  // Insert a new item into the database
  Future<int> insertItem(Item item) async {
    final db = await DatabaseProvider().database;
    return await db.insert(
      ItemTable.tableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all items in a specific shopping list
  Future<List<Item>> getItemsByShoppingListId(int shoppingListId) async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> maps = await db.query(
      ItemTable.tableName,
      where: '${ItemTable.columnShoppingListId} = ?',
      whereArgs: [shoppingListId],
    );
    return List.generate(maps.length, (i) => Item.fromMap(maps[i]));
  }

  // Update an item
  Future<int> updateItem(Item item) async {
    final db = await DatabaseProvider().database;
    return await db.update(
      ItemTable.tableName,
      item.toMap(),
      where: '${ItemTable.columnId} = ?',
      whereArgs: [item.id],
    );
  }

  // Delete an item by ID
  Future<int> deleteItem(int id) async {
    final db = await DatabaseProvider().database;
    return await db.delete(
      ItemTable.tableName,
      where: '${ItemTable.columnId} = ?',
      whereArgs: [id],
    );
  }
}
