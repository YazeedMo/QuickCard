class Session {
  int? id;
  int? currentUser;
  bool stayLoggedIn;

  Session({
    this.id,
    this.currentUser,
    this.stayLoggedIn = false,
  });

  // Convert Session object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'currentUser': currentUser,
      'stayLoggedIn': stayLoggedIn ? 1 : 0, // Store boolean as integer
    };
  }

  // Create a Session object from a map
  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      currentUser: map['currentUser'],
      stayLoggedIn: map['stayLoggedIn'] == 1, // Convert integer back to boolean
    );
  }
}
