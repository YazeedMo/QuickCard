import 'package:quick_card/entity/session.dart';
import 'package:quick_card/entity/user.dart';
import 'package:quick_card/service/session_service.dart';
import 'package:quick_card/service/user_service.dart';

class AuthService {
  final SessionService _sessionService = SessionService();
  final UserService _userService = UserService();

  Future<String?> login(
      String username, String password, bool stayLoggedIn) async {
    // Check if fields are empty
    if (username.isEmpty) return "Please enter username";
    if (password.isEmpty) return "Please enter password";

    // Attempt to validate user
    User? user = await _userService.validateUser(username, password);
    if (user == null) {
      return "Incorrect username or password";
    }

    // Handle session if user exists
    Session? currentSession = await _sessionService.getCurrentSession();
    if (currentSession != null) {
      currentSession.currentUser = user.id;
      currentSession.stayLoggedIn = stayLoggedIn;
      await _sessionService.updateSession(currentSession);
    }

    return null; // No error message means success
  }
}
