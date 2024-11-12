// database_provider.dart
import 'package:quick_card/repository/tables/card_table.dart';
import 'package:quick_card/repository/tables/folder_table.dart';
import 'package:quick_card/repository/tables/item_table.dart';
import 'package:quick_card/repository/tables/session_table.dart';
import 'package:quick_card/repository/tables/shopping_list_table.dart';
import 'package:quick_card/repository/tables/user_table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  // Singleton pattern to ensure only one instance of DatabaseProvider
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  factory DatabaseProvider() => _instance;
  DatabaseProvider._internal();

  static Database? _database;

  // Get or initialize the database instance
  Future<Database> get database async {
    if (_database != null) return _database!; // Return existing instance if available
    _database = await _initDatabase(); // Initialize if it's null
    return _database!;
  }

  // Initialize the database and set up the tables
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(SessionTable.createTableSQL);
        await db.execute(UserTable.createTableSQL);
        await db.execute(FolderTable.createTableSQL);
        await db.execute(CardTable.createTableSQL);
        await db.execute(ShoppingListTable.createTableSQL);
        await db.execute(ItemTable.createTableSQL);
      },
    );
  }

  // Close the database connection
  Future<void> close() async {
    _database?.close();
  }
}

