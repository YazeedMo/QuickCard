// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:quick_card/screens/home_screen.dart';
import 'package:quick_card/screens/registration_screen.dart';
import 'package:quick_card/service/user_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String errorMessage = '';

  void _handleLogin() async {

    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty) {
      setState(() {
        errorMessage = "Please enter username";
      });
    } else if (password.isEmpty) {
      setState(() {
        errorMessage = "Please enter password";
      });
    } else {
      dynamic result = await UserService().validateUser(username, password);

      setState(() {
        if (result is String) {
          errorMessage = result;
        } else {
          // Navigate only if validation is successful
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QuickCard'),
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
            // Login button
            ElevatedButton(
              onPressed: () {
                _handleLogin();
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16.0,),
            // Registration button
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
              },
              child: Text('Register'),
            )
          ],
        ),
      ),
    );
  }
}
