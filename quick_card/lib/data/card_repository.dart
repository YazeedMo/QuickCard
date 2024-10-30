import 'package:quick_card/data/tables/card_table.dart';
import 'package:quick_card/entity/card.dart';
import 'package:sqflite/sqflite.dart';
import 'database_provider.dart';

class CardRepository {
  // Insert a new card into the database
  Future<int> createCard(Card card) async {
    final db = await DatabaseProvider().database;
    return await db.insert(
      CardTable.tableName,
      card.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all cards
  Future<List<Card>> getAllCards() async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> maps = await db.query(CardTable.tableName);
    return List.generate(maps.length, (i) => Card.fromMap(maps[i]));
  }

  // Retrieve all cards in a specific folder
  Future<List<Card>> getCardsByFolderId(int folderId) async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> maps = await db.query(
      CardTable.tableName,
      where: '${CardTable.columnFolderId} = ?',
      whereArgs: [folderId],
    );
    return List.generate(maps.length, (i) => Card.fromMap(maps[i]));
  }

  // Retrieve card by id
  Future<Card?> getCardById(int id) async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> maps = await db.query(
      CardTable.tableName,
      where: '${CardTable.columnId} = ?',
      whereArgs: [id]
    );
    if (maps.isNotEmpty) {
      return Card.fromMap(maps.first);
    }
    return null;
  }

  // Update a card
  Future<int> updateCard(Card card) async {
    final db = await DatabaseProvider().database;
    return await db.update(
      CardTable.tableName,
      card.toMap(),
      where: '${CardTable.columnId} = ?',
      whereArgs: [card.id],
    );
  }

  // Delete a card by ID
  Future<int> deleteCardById(int id) async {
    final db = await DatabaseProvider().database;
    return await db.delete(
      CardTable.tableName,
      where: '${CardTable.columnId} = ?',
      whereArgs: [id],
    );
  }
}
