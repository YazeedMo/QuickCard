class User {
  int? id;
  String username;
  String email;
  String password;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password
  });

  // Convert a User object into a map for the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  // Convert a map from the database back into a User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
    );
  }

}