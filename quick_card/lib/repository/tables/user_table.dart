// user_table.dart
class UserTable {
  // Define the table name and column names as constants
  static const String tableName = 'users';
  static const String columnId = 'id';
  static const String columnUsername = 'username';
  static const String columnEmail = 'email';
  static const String columnPassword = 'password';

  // SQL statement for creating the 'users' table
  static const String createTableSQL = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnUsername TEXT NOT NULL,
      $columnEmail TEXT NOT NULL UNIQUE,
      $columnPassword TEXT NOT NULL
    )
  ''';
}
