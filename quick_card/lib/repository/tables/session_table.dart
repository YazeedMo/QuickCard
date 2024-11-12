class SessionTable {
  // Define the table name and column names
  static const String tableName = 'sessions';
  static const String columnId = 'id';
  static const String columnCurrentUserId = 'currentUserId';
  static const String columnStayLoggedIn = 'stayLoggedIn';

  // SQL statement to create the sessions table
  static const String createTableSQL = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnCurrentUserId INTEGER,
      $columnStayLoggedIn INTEGER NOT NULL
    )
  ''';
}
