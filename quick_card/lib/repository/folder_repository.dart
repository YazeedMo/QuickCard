import 'package:quick_card/repository/tables/card_folder_table.dart';
import 'package:quick_card/repository/tables/folder_table.dart';
import 'package:quick_card/entity/folder.dart';
import 'package:sqflite/sqflite.dart';
import 'database_provider.dart';

class FolderRepository {
  // Create new Folder
  Future<int> createFolder(Folder folder) async {
    final db = await DatabaseProvider().database;
    return await db.insert(
      FolderTable.tableName,
      folder.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get Folder by id
  Future<Folder?> getFolderById(int id) async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> maps = await db.query(
      FolderTable.tableName,
      where: '${FolderTable.columnId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Folder.fromMap(maps.first);
    }
    return null;
  }

  // Get all Folders by User id
  Future<List<Folder>> getFoldersByUserId(int userId) async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> maps = await db.query(
      FolderTable.tableName,
      where: '${FolderTable.columnUserId} = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => Folder.fromMap(maps[i]));
  }

  // Add Card to Folder
  Future<void> addCardToFolder(int folderId, int cardId) async {
    final db = await DatabaseProvider().database;

    await db.insert(
      CardFolderTable.tableName,
      {
        CardFolderTable.columnFolderId: folderId,
        CardFolderTable.columnCardId: cardId,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // Update Folder
  Future<int> updateFolder(Folder folder) async {
    final db = await DatabaseProvider().database;
    return await db.update(
      FolderTable.tableName,
      folder.toMap(),
      where: '${FolderTable.columnId} = ?',
      whereArgs: [folder.id],
    );
  }

  // Delete Folder by id
  Future<int> deleteFolder(int id) async {
    final db = await DatabaseProvider().database;
    return await db.delete(
      FolderTable.tableName,
      where: '${FolderTable.columnId} = ?',
      whereArgs: [id],
    );
  }
}
