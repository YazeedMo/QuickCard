// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quick_card/screens/home_screen.dart';
import 'package:quick_card/screens/registration_screen.dart';
import 'package:quick_card/service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  String errorMessage = '';
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _stayLoggedIn = false;

  Future<void> _handleLogin() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Login and set error message if any
    String? error = await _authService.login(username, password, _stayLoggedIn);
    setState(() {
      errorMessage = error ?? '';
      if (error == null) {
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
          title: const Text('QuickCard'),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Visibility(
                    visible: errorMessage.isNotEmpty,
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
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
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: _handleLogin,
                    child: Text('Login'),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrationScreen()));
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
