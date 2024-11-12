class CardFolderTable {
  // Define the table name and column names
  static const String tableName = 'card_folders';
  static const String columnId = 'id';
  static const String columnCardId = 'cardId';
  static const String columnFolderId = 'folderId';

  // SQL statement to create the items table
  static const String createTableSQL = '''
  CREATE TABLE $tableName (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnCardId INTEGER,
    $columnFolderId INTEGER,
    FOREIGN KEY ($columnCardId) REFERENCES cards(id) ON DELETE CASCADE,
    FOREIGN KEY ($columnFolderId) REFERENCES folders(id) ON DELETE CASCADE
  )
  ''';
}
