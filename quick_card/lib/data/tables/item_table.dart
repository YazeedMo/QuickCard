class ItemTable {
  // Define the table name and column names
  static const String tableName = 'items';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnCheckedOff = 'checkedOff';
  static const String columnShoppingListId = 'shoppingListId';

  // SQL statement to create the items table
  static const String createTableSQL = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnName TEXT NOT NULL,
      $columnCheckedOff INTEGER NOT NULL,
      $columnShoppingListId INTEGER,
      FOREIGN KEY ($columnShoppingListId) REFERENCES shopping_lists(id) ON DELETE CASCADE
    )
  ''';
}
