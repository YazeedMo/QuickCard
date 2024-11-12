// folder_table.dart
class FolderTable {
  // Define the table name and column names
  static const String tableName = 'folders';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnDescription = 'description';
  static const String columnImagePath = 'imagePath';
  static const String columnUserId = 'userId';

  // SQL statement to create the folders table
  static const String createTableSQL = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnName TEXT NOT NULL,
      $columnDescription TEXT,
      $columnImagePath TEXT,
      $columnUserId INTEGER,
      FOREIGN KEY ($columnUserId) REFERENCES users(id) ON DELETE CASCADE
    )
  ''';
}
