import 'package:hive/hive.dart';
import 'package:quick_card/entity/user.dart';

class UserDB {
  final String _boxName = 'userBox';

  // Open the Hive box
  Future<void> openBox() async {
    await Hive.openBox<User>(_boxName);
  }

  // Create new User
  Future<int> createUser(User user) async {
    try {
      final box = Hive.box<User>(_boxName);
      final key = await box.add(user);
      return key;
    }
    catch(e) {
      print('error: $e');
    }

    return -3;

  }

  // Get all users
  List<User> getAllUsers() {
    final box = Hive.box<User>(_boxName);
    return box.values.toList();
  }
}
