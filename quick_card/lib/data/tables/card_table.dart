// card_table.dart
class CardTable {
  // Define table name and column names
  static const String tableName = 'cards';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnData = 'data';
  static const String columnBarcodeFormat = 'barcodeFormat';
  static const String columnSvg = 'svg';
  static const String columnImagePath = 'imagePath';
  static const String columnFolderId = 'folderId';

  // SQL statement to create the 'cards' table
  static const String createTableSQL = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnName TEXT NOT NULL,
      $columnData TEXT NOT NULL,
      $columnBarcodeFormat TEXT NOT NULL,
      $columnSvg TEXT NOT NULL,
      $columnImagePath TEXT,
      $columnFolderId INTEGER,
      FOREIGN KEY ($columnFolderId) REFERENCES folders(id) ON DELETE CASCADE
    )
  ''';
}
