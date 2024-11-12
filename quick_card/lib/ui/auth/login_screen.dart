// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:quick_card/components/auth_components.dart';
import 'package:quick_card/components/snackbar_message.dart';
import 'package:quick_card/ui/auth/login_controller.dart';
import 'package:quick_card/ui/auth/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _authController = LoginController();
  final SnackBarMessage _snackBarMessage = SnackBarMessage();

  String? _message;
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    _message = await _authController.handleLogin(context);
    if (_message != null && mounted) {
      _snackBarMessage.showSnackBar(context, _message!, 2);
    }

    setState(() {
      _isLoading = false;
    });

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Profile photo at the top
            Padding(
              padding:
                  EdgeInsets.only(top: 20, bottom: 20), // Padding for spacing
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/greenlight.png', // Replace with your image path
                      width: 150.0,
                      height: 170.0,
                      opacity: const AlwaysStoppedAnimation(.6),
                    ),
                  ),
                  SizedBox(width: 20), // Space between the two images
                  // Second circular image
                  ClipOval(
                    child: Image.asset(
                      'assets/purplelight.png', // Second image path
                      width: 170.0, // Adjust width
                      height: 150.0, // Adjust height
                      opacity: const AlwaysStoppedAnimation(0.6),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    'welcome to',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'quick',
                          style: TextStyle(
                            fontSize: 52.0,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'card',
                          style: TextStyle(
                            fontSize: 52.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF382EF2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0),
            // Login subtitle
            Center(
              child: Text(
                'login to your account',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            // username
            AuthTextField(
                buildContext: context,
                controller: _authController.usernameController,
                text: 'username',
                imagePath: 'assets/user.png',
                obscureText: false,
                thisFocusNode: _authController.usernameFocusNode,
                nextFocusNode: _authController.passwordFocusNode),
            SizedBox(height: 25.0),
            // password
            AuthTextField(
                buildContext: context,
                controller: _authController.passwordController,
                text: 'password',
                imagePath: 'assets/lock.png',
                obscureText: true,
                thisFocusNode: _authController.passwordFocusNode),
            SizedBox(height: 4.0),
            CheckboxListTile(
              title: Text('remember me?'),
              value: _authController.stayLoggedIn,
              onChanged: (value) {
                setState(() {
                  _authController.stayLoggedIn = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            // Login button with bold black text
            SizedBox(height: 25.0),
            _isLoading == true
                ? LoadingButton()
                : AuthButton(onTap: _handleLogin, text: 'login'),
            Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen()));
                },
                child: Text.rich(
                  TextSpan(
                    text: "don't have an account? ",
                    children: [
                      TextSpan(
                        text: 'sign up', // Bold text
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    )));
  }
}
