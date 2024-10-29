class SessionTable {
  // Define the table name and column names
  static const String tableName = 'sessions';
  static const String columnId = 'id';
  static const String columnCurrentUser = 'currentUser';
  static const String columnStayLoggedIn = 'stayLoggedIn';

  // SQL statement to create the sessions table
  static const String createTableSQL = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnCurrentUser INTEGER,
      $columnStayLoggedIn INTEGER NOT NULL
    )
  ''';
}
