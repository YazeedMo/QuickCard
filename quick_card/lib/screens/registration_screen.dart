// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:quick_card/entity/user.dart';
import 'package:quick_card/screens/home_screen.dart';
import 'package:quick_card/service/user_service.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String errorMessage = '';

  void _handleRegistration() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    // Clear any previous error messages
    setState(() {
      errorMessage = '';
    });

    // Validate user input
    if (username.isEmpty) {
      setState(() {
        errorMessage = "Please enter username";
      });
      return;
    }
    if (email.isEmpty) {
      setState(() {
        errorMessage = "Please enter email";
      });
      return;
    }
    if (password.isEmpty) {
      setState(() {
        errorMessage = "Please enter password";
      });
      return;
    }

    User user = User(username: username, email: email, password: password);

    // Call the registration service
    dynamic result = await UserService().createUser(user);

    setState(() {
      if (result is String) {
        // Set error message if registration fails
        errorMessage = result;
      } else {
        // Navigate to home screen on successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
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
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            // Email input field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            // Password input field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            // Register button
            ElevatedButton(
              onPressed: () {
                _handleRegistration();
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
