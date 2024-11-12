import 'package:quick_card/repository/folder_repository.dart';
import 'package:quick_card/repository/user_repository.dart';
import 'package:quick_card/entity/folder.dart';
import 'package:quick_card/entity/shopping_list.dart';
import 'package:quick_card/entity/user.dart';
import 'package:quick_card/service/shopping_list_service.dart';

class UserService {
  final UserRepository _userRepository = UserRepository();

  // Create new User
  Future<int?> createUser(User user) async {
    if (await _usernameExists(user.username)) {
      return null;
    } else {
      int userId = await _userRepository.createUser(user);
      await _createDefaultFolder(userId);
      await _createDefaultShoppingList(userId);

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
    } else {
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

  // Create default folder for new User
  Future<void> _createDefaultFolder(int userId) async {
    Folder folder = Folder(name: 'default', userId: userId);
    await FolderRepository().createFolder(folder);
  }

  // Create default Shopping List for User
  Future<void> _createDefaultShoppingList(int userId) async {
    ShoppingList shoppingList = ShoppingList(name: 'default', userId: userId);
    await ShoppingListService().createShoppingList(shoppingList);
  }

  // Update User
  Future<int> updateUser(User user) async {
    return await _userRepository.updateUser(user);
  }

  // Delete User by id
  Future<int> deleteUserById(int id) async {
    int userId = await _userRepository.deleteUser(id);
    return userId;
  }

}
