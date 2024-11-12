class Session {
  int? id;
  int? currentUserId;
  bool stayLoggedIn;

  Session({
    this.id,
    this.currentUserId,
    this.stayLoggedIn = false,
  });

  // Convert Session object into a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'currentUserId': currentUserId,
      'stayLoggedIn': stayLoggedIn ? 1 : 0, // Store boolean as integer
    };
  }

  // Convert map to  Session object
  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      currentUserId: map['currentUserId'],
      stayLoggedIn: map['stayLoggedIn'] == 1, // Convert integer back to boolean
    );
  }
}
