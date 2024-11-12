import 'package:quick_card/repository/tables/user_table.dart';
import 'package:sqflite/sqflite.dart';
import '../entity/user.dart';
import 'database_provider.dart';

class UserRepository {
  // Create new User
  Future<int> createUser(User user) async {
    final db = await DatabaseProvider().database;
    return await db.insert(
      UserTable.tableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get User by id
  Future<User?> getUserById(int id) async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> maps = await db.query(UserTable.tableName,
        where: '${UserTable.columnId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Get User by username
  Future<User?> getUserByUsername(String username) async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> maps = await db.query(
      UserTable.tableName,
      where: '${UserTable.columnUsername} = ?',
      whereArgs: [username],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Get User by email
  Future<User?> getUserByEmail(String email) async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> maps = await db.query(
      UserTable.tableName,
      where: '${UserTable.columnEmail} = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Update User
  Future<int> updateUser(User user) async {
    final db = await DatabaseProvider().database;
    return await db.update(
      UserTable.tableName,
      user.toMap(),
      where: '${UserTable.columnId} = ?',
      whereArgs: [user.id],
    );
  }

  // Delete User by id
  Future<int> deleteUser(int id) async {
    final db = await DatabaseProvider().database;
    return await db.delete(
      UserTable.tableName,
      where: '${UserTable.columnId} = ?',
      whereArgs: [id],
    );
  }
}
