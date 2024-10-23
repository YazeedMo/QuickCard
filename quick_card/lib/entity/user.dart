import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class User {

  @HiveField(0)
  String username;

  @HiveField(1)
  String email;

  @HiveField(2)
  String password;

  User({
    required this.username,
    required this.email,
    required this.password
});

  @override
  String toString() {
    return 'User{username: $username, email: $email, password: $password}';
  }
}