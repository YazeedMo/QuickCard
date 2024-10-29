import 'package:quick_card/data/tables/folder_table.dart';
import 'package:quick_card/entity/folder.dart';
import 'package:sqflite/sqflite.dart';
import 'database_provider.dart';

class FolderRepository {
  // Insert a new folder into the database
  Future<int> createFolder(Folder folder) async {
    final db = await DatabaseProvider().database;
    return await db.insert(
      FolderTable.tableName,
      folder.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // import 'dart:io';
  //
  // Image.file(File(folder.imagePath ?? 'default_image_path_here'));


  // Retrieve all folders for a specific user
  Future<List<Folder>> getFoldersByUserId(int userId) async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> maps = await db.query(
      FolderTable.tableName,
      where: '${FolderTable.columnUserId} = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => Folder.fromMap(maps[i]));
  }

  // Update a folder
  Future<int> updateFolder(Folder folder) async {
    final db = await DatabaseProvider().database;
    return await db.update(
      FolderTable.tableName,
      folder.toMap(),
      where: '${FolderTable.columnId} = ?',
      whereArgs: [folder.id],
    );
  }

  // Delete a folder by ID
  Future<int> deleteFolder(int id) async {
    final db = await DatabaseProvider().database;
    return await db.delete(
      FolderTable.tableName,
      where: '${FolderTable.columnId} = ?',
      whereArgs: [id],
    );
  }
}
