import 'package:quick_card/repository/folder_repository.dart';
import 'package:quick_card/repository/tables/card_folder_table.dart';
import 'package:quick_card/repository/tables/card_table.dart';
import 'package:quick_card/entity/card.dart';
import 'package:sqflite/sqflite.dart';
import 'database_provider.dart';

class CardRepository {

  final FolderRepository _folderRepository = FolderRepository();

  // Create new Card
  Future<int> createCard(Card card) async {
    final db = await DatabaseProvider().database;
    return await db.insert(
      CardTable.tableName,
      card.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get Cards by User id
  Future<List<Card>> getCardsByUserId(int userId) async {

    final db = await DatabaseProvider().database;

    final List<Map<String, dynamic>> cardMaps = await db.query(
      CardTable.tableName,
      where: '${CardTable.columnUserId} = ?',
      whereArgs: [userId],
    );


    if (cardMaps.isEmpty) {
      return [];
    }

    return List.generate(cardMaps.length, (i) => Card.fromMap(cardMaps[i]));

  }

  // Get all Cards by Folder id
  Future<List<Card>> getCardsByFolderId(int folderId) async {
    final db = await DatabaseProvider().database;

    // Get all card IDs associated with the folderId from the CardFolder table
    final List<Map<String, dynamic>> cardFolderMaps = await db.query(
      CardFolderTable.tableName,
      columns: [CardFolderTable.columnCardId],
      where: '${CardFolderTable.columnFolderId} = ?',
      whereArgs: [folderId],
    );

    // Extract card IDs from the results
    final List<int> cardIds = cardFolderMaps
        .map((map) => map[CardFolderTable.columnCardId] as int)
        .toList();

    return await getCardsByIds(cardIds);

  }

  // Get Cards by list of Card ids
  Future<List<Card>> getCardsByIds(List<int> cardIds) async {

    final db = await DatabaseProvider().database;

    // If no card IDS provided, return an empty list
    if (cardIds.isEmpty) {
      return [];
    }

    // Query Card table where card IDs match the provided list
    final List<Map<String, dynamic>> cardMaps = await db.query(
      CardTable.tableName,
      where: '${CardTable.columnId} IN (${List.filled(cardIds.length, '?').join(', ')})',
      whereArgs: cardIds,
    );

    // Convert each card map to a Card object and return as a list
    return List.generate(cardMaps.length, (i) => Card.fromMap(cardMaps[i]));

  }

  // Get Card by id
  Future<Card?> getCardById(int id) async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> maps = await db.query(CardTable.tableName,
        where: '${CardTable.columnId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Card.fromMap(maps.first);
    }
    return null;
  }

  // Add Card to Folder
  Future<void> addCardToFolder(int cardId, int folderId) async {
    await _folderRepository.addCardToFolder(folderId, cardId);
  }

  // Update Card
  Future<int> updateCard(Card card) async {
    final db = await DatabaseProvider().database;
    return await db.update(
      CardTable.tableName,
      card.toMap(),
      where: '${CardTable.columnId} = ?',
      whereArgs: [card.id],
    );
  }

  // Delete a Card by id
  Future<int> deleteCardById(int id) async {
    final db = await DatabaseProvider().database;
    return await db.delete(
      CardTable.tableName,
      where: '${CardTable.columnId} = ?',
      whereArgs: [id],
    );
  }
}
