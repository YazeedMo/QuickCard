import 'package:quick_card/data/tables/item_table.dart';
import 'package:quick_card/entity/item.dart';
import 'package:quick_card/entity/session.dart';
import 'package:quick_card/entity/shopping_list.dart';
import 'package:quick_card/service/item_service.dart';
import 'package:quick_card/service/session_service.dart';
import 'package:quick_card/service/shopping_list_service.dart';
import 'package:sqflite/sqflite.dart';
import 'database_provider.dart';

class ItemRepository {

  // Create new Item
  Future<int> createItem(Item item) async {
    final db = await DatabaseProvider().database;
    return await db.insert(
      ItemTable.tableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all Items by Shopping List id
  Future<List<Item>> getItemsByShoppingListId(int shoppingListId) async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> maps = await db.query(
      ItemTable.tableName,
      where: '${ItemTable.columnShoppingListId} = ?',
      whereArgs: [shoppingListId],
    );
    return List.generate(maps.length, (i) => Item.fromMap(maps[i]));
  }

  // Get Item by id
  Future<Item?> getItemById(int id) async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> maps = await db.query(
      ItemTable.tableName,
      where: '${ItemTable.columnId} = ?',
      whereArgs: [id]
    );
    if (maps.isNotEmpty) {
      return Item.fromMap(maps.first);
    }
    return null;
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

  // Delete Item by Id
  Future<int> deleteItem(int id) async {
    final db = await DatabaseProvider().database;
    return await db.delete(
      ItemTable.tableName,
      where: '${ItemTable.columnId} = ?',
      whereArgs: [id],
    );
  }
}
