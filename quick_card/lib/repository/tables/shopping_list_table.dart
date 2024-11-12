class ShoppingListTable {
  // Define the table name and column names
  static const String tableName = 'shopping_lists';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnUserId = 'userId';

  // SQL statement to create the shopping_lists table
  static const String createTableSQL = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnName TEXT NOT NULL,
      $columnUserId INTEGER,
      FOREIGN KEY ($columnUserId) REFERENCES users(id) ON DELETE CASCADE
    )
  ''';
}
