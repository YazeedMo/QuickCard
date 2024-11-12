class CardTable {
  // Define table name and column names
  static const String tableName = 'cards';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnData = 'data';
  static const String columnFormat = 'format';
  static const String columnSvg = 'svg';
  static const String columnImagePath = 'imagePath';
  static const String columnFavourite = 'favourite';
  static const String columnUserId = 'userId';

  // SQL statement to create the 'cards' table
  static const String createTableSQL = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnName TEXT NOT NULL,
      $columnData TEXT NOT NULL,
      $columnFormat TEXT NOT NULL,
      $columnSvg TEXT NOT NULL,
      $columnImagePath TEXT,
      $columnFavourite INTEGER NOT NULL,
      $columnUserId INTEGER,
      FOREIGN KEY ($columnUserId) REFERENCES users(id) ON DELETE CASCADE
    )
  ''';
}
