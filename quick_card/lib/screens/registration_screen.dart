// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:quick_card/data/folder_repository.dart';
import 'package:quick_card/entity/folder.dart';
import 'package:quick_card/entity/session.dart';
import 'package:quick_card/entity/user.dart';
import 'package:quick_card/screens/home_screen.dart';
import 'package:quick_card/screens/login_screen.dart';
import 'package:quick_card/service/session_service.dart';
import 'package:quick_card/service/user_service.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final SessionService _sessionService = SessionService();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String errorMessage = '';
  bool _stayLoggedIn = true;

  @override
  void dispose() {
    // Clean up the controllers when the widget is removed from the widget tree
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegistration() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    // Clear any previous error messages
    setState(() {
      errorMessage = '';
    });

    // Validate user input
    if (_validateInputs(username, email, password, confirmPassword)) return;

    User user = User(username: username, email: email, password: password);
    await _registerUser(user);
  }

  bool _validateInputs(
      String username, String email, String password, String confirmPassword) {
    if (username.isEmpty) {
      setState(() {
        errorMessage = "Please enter username";
      });
      return true;
    }
    if (email.isEmpty) {
      setState(() {
        errorMessage = "Please enter email";
      });
      return true;
    }
    if (password.isEmpty) {
      setState(() {
        errorMessage = "Please enter password";
      });
      return true;
    }
    if (confirmPassword.isEmpty) {
      setState(() {
        errorMessage = "Please confirm password";
      });
      return true;
    }
    if (password != confirmPassword) {
      setState(() {
        errorMessage = "Ensure passwords are the same";
      });
      return true;
    }
    return false;
  }

  Future<void> _registerUser(User user) async {
    int? result = await UserService().createUser(user);
    if (result == null) {
      setState(() {
        errorMessage = 'Username already exists';
      });
    } else {
      await _createDefaultFolder(result);
      await _updateSession(result);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  Future<void> _createDefaultFolder(int userId) async {
    Folder folder = Folder(name: 'default', userId: userId);
    await FolderRepository().createFolder(folder);
  }

  Future<void> _updateSession(int userId) async {
    Session? currentSession = await _sessionService.getCurrentSession();
    if (currentSession != null) {
      currentSession.currentUser = userId;
      currentSession.stayLoggedIn = _stayLoggedIn;
      await _sessionService.updateSession(currentSession);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QuickCard Registration'),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'REGISTER',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.0), // Spacing between the labels
                  Text(
                    'Create your account',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Error message (initially invisible)
                  Visibility(
                    visible: errorMessage.isNotEmpty,
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Username input field
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        //Inserted image in textfield
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/user.png',
                          width: 15,
                          height: 15,
                        ),
                      ),
                      labelText: 'username',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFFDEDCFB),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Email input field
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        //Inserted image in textfield
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/mail.png',
                          width: 15,
                          height: 15,
                        ),
                      ),
                      labelText: 'email address',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFFDEDCFB),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Password input field
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        //Inserted image in textfield
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/lock.png',
                          width: 15,
                          height: 15,
                        ),
                      ),
                      labelText: 'password',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFFDEDCFB),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Confirm password input field
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        //Inserted image in text field
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/lock.png',
                          width: 15,
                          height: 15,
                        ),
                      ),
                      labelText: 'confirm password',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFFDEDCFB),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  // Stay logged in checkbox
                  CheckboxListTile(
                    title: Text("Stay logged in"),
                    value: _stayLoggedIn,
                    onChanged: (value) {
                      setState(() {
                        _stayLoggedIn = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  // Register button
                  ElevatedButton(
                    onPressed: () {
                      _handleRegistration();
                    },
                    style: ElevatedButton.styleFrom(

                      backgroundColor: Color (0xff8EE4DF), // Background color
                      foregroundColor: Colors.black, // Text color
                    ),
                    child: Text(
                      'register',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text.rich(
                        TextSpan(
                          text: 'already have an account? ',
                          children: [
                            TextSpan(
                              text: 'login', // Bold text
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
  //
  // Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false}) {
  //   return TextField(
  //     controller: controller,
  //     obscureText: obscureText,
  //     decoration: InputDecoration(
  //       labelText: label,
  //       border: OutlineInputBorder(),
  //     ),
  //   );
  // }
}
