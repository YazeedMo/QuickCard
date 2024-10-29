import 'package:quick_card/data/tables/session_table.dart';
import 'package:quick_card/entity/session.dart';
import 'package:sqflite/sqflite.dart';
import 'database_provider.dart';

class SessionRepository {
  // Insert a new session into the database
  Future<int> createSession(Session session) async {
    final db = await DatabaseProvider().database;
    return await db.insert(
      SessionTable.tableName,
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve Session by id
  Future<Session?> getSessionById(int id) async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> maps = await db.query(
      SessionTable.tableName,
      where: '${SessionTable.columnId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Session.fromMap(maps.first);
    }
    return null;
  }

  // Retrieve the current session
  Future<Session?> getCurrentSession() async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> maps = await db.query(
      SessionTable.tableName,
      limit: 1,
      orderBy: '${SessionTable.columnId} DESC', // Get the most recent session
    );
    if (maps.isNotEmpty) {
      return Session.fromMap(maps.first);
    }
    return null;
  }

  // Update a session
  Future<int> updateSession(Session session) async {
    final db = await DatabaseProvider().database;
    return await db.update(
      SessionTable.tableName,
      session.toMap(),
      where: '${SessionTable.columnId} = ?',
      whereArgs: [session.id],
    );
  }

  // Delete the session
  Future<int> deleteSession(int id) async {
    final db = await DatabaseProvider().database;
    return await db.delete(
      SessionTable.tableName,
      where: '${SessionTable.columnId} = ?',
      whereArgs: [id],
    );
  }
}
