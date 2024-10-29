import 'package:quick_card/data/user_repository.dart';
import 'package:quick_card/entity/user.dart';

class UserService {

  final UserRepository _userRepository = UserRepository();

  // Create new User
  Future<int?> createUser(User user) async {

    if (await _usernameExists(user.username)) {
      return null;
    }
    else {
      int userId = await _userRepository.createUser(user);
      return userId;
    }

  }

  // Get User by id
  Future<User?> getUserById(int id) async {
    return _userRepository.getUserById(id);
  }

  // Validate username & password
  Future<User?> validateUser(String username, String password) async {

    User? user = await _userRepository.getUserByUsername(username);

    if (user == null) {
      return null;
    }
    else {
      if (user.password == password) {
        return user;
      }
    }
    return null;

  }

  // Get all Users
  Future<List> getAllUsers() async {
    return _userRepository.getAllUsers();
  }

  // Get User by username
  Future<User?> getUserByUsername(String username) async {

    User? user = await _userRepository.getUserByUsername(username);

    if (user != null) {
      return user;
    }

    return null;

  }

  // Check if username already exists
  Future<bool> _usernameExists(String username) async {

    User? user = await _userRepository.getUserByUsername(username);

    if (user == null) {
      return false;
    }
    return true;
  }

}
