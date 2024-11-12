import 'package:flutter/material.dart';
import 'package:quick_card/entity/session.dart';
import 'package:quick_card/entity/user.dart';
import 'package:quick_card/service/session_service.dart';
import 'package:quick_card/service/user_service.dart';
import 'package:quick_card/ui/home/home_screen.dart';
import 'package:quick_card/util/io_utils.dart';

class RegistrationController {
  final SessionService _sessionService = SessionService();
  final IOUtils _ioUtils = IOUtils();

  final TextEditingController usernameController = TextEditingController();
  final FocusNode usernameFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  bool stayLoggedIn = true;

  Future<String?> handleRegistration(BuildContext buildContext) async {
    String? message;

    String username = usernameController.text.trim();
    String email = emailController.text.trim().toLowerCase();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    message = _validateInputs(username, email, password, confirmPassword);

    if (message != null) {
      return message;
    }

    password = _ioUtils.hashPassword(password);

    User user = User(username: username, email: email, password: password);

    message = await _registerUser(user);

    if (message != null) {
      return message;
    }

    if (buildContext.mounted) {
      Navigator.pushReplacement(buildContext,
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
    return null;
  }

  Future<String?> _registerUser(User user) async {
    int? result = await UserService().createUser(user);
    if (result == null) {
      return 'Username already exists';
    } else {
      await _updateSession(result);
    }
    return null;
  }

  Future<void> _updateSession(int userId) async {
    Session? currentSession = await _sessionService.getCurrentSession();
    if (currentSession != null) {
      currentSession.currentUserId = userId;
      currentSession.stayLoggedIn = stayLoggedIn;
      await _sessionService.updateSession(currentSession);
    }
  }

  String? _validateInputs(
      String username, String email, String password, String confirmPassword) {
    if (username.isEmpty) {
      return 'Please enter username';
    }
    if (email.isEmpty) {
      return "Please enter email";
    }
    if (!validateEmail(email)) {
      return 'Invalid email format';
    }
    if (password.isEmpty) {
      return "Please enter password";
    }
    if (confirmPassword.isEmpty) {
      return "Please confirm password";
    }
    if (password != confirmPassword) {
      return "Passwords do not match";
    }
    return null;
  }

  bool validateEmail(String email) {

    // Validate email format here.
    // Return true is valid, false if not
    // (Ethan)

    return true;

  }

}
