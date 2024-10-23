import 'package:quick_card/data/user_db.dart';
import 'package:quick_card/entity/user.dart';

class UserService {
  // Create new User
  Future<dynamic> createUser(User user) async {
    if (await _usernameExists(user.username)) {
      return 'Username \'${user.username}\' already exists';
    } else {
      return await UserDB().createUser(user);
    }
  }

  // Validate username & password
  Future<dynamic> validateUser(String username, String password) async {
    User? user = await getUserByUsername(username);

    if (user == null || user.password != password) {
      return 'Incorrect username or password';
    } else {
      return user;
    }
  }

  // Get all Users
  Future<List> getAllUsers() async {
    return await UserDB().getAllUsers();
  }

  // Get User by username
  Future<User?> getUserByUsername(String username) async {
    List allUsers = await getAllUsers();

    for (User user in allUsers) {
      if (user.username == username) {
        return user;
      }
    }

    return null;
  }

  // Check if username already exists
  Future<bool> _usernameExists(String username) async {
    List allUsers = await UserDB().getAllUsers();

    for (User user in allUsers) {
      if (user.username == username) {
        return true;
      }
    }

    return false;
  }
}
