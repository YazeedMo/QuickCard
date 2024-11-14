import 'package:flutter/material.dart';
import 'package:quick_card/service/auth_service.dart';
import 'package:quick_card/ui/home/home_screen.dart';
import 'package:quick_card/util/io_utils.dart';

class LoginController {
  final AuthService _authService = AuthService();
  final IOUtils _ioUtils = IOUtils();

  final TextEditingController usernameController = TextEditingController();
  final FocusNode usernameFocusNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  bool stayLoggedIn = false;

  Future<String?> handleLogin(BuildContext context) async {
    String username = usernameController.text.trim();
    String password = passwordController.text;

    String? message = _validateInput();

    if (message != null) {
      return message;
    }

    password = _ioUtils.hashPassword(password);
    // Perform the login and await the result
    message = await _authService.login(username, password, stayLoggedIn);

    // Check if the widget is still mounted in the tree
    if (message == null && context.mounted) {
      // Safely use BuildContext after the async call
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      return null;
    } else {
      return message;
    }
  }

  String? _validateInput() {
    if (usernameController.text.trim().isEmpty) {
      return 'Please enter username';
    } else if (passwordController.text.isEmpty) {
      return 'Please enter password';
    }
    return null;
  }
}
