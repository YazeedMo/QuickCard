// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quick_card/entity/user.dart';
import 'package:quick_card/screens/home_screen.dart';
import 'package:quick_card/screens/login_screen.dart';
import 'package:quick_card/service/user_service.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}



class _RegistrationScreenState extends State<RegistrationScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String errorMessage = '';

  void _handleRegistration() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

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
    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        errorMessage = "Please enter a valid email";
      });
      return;
    }
    if (password.isEmpty) {
      setState(() {
        errorMessage = "Please enter password";
      });
      return;
    }
    if (confirmPassword.isEmpty) {
      setState(() {
        errorMessage = "Please confirm password";
      });
      return;
    }
    if (password != confirmPassword) {
      setState(() {
        errorMessage = "Ensure passwords are the same";
      });
      return;
    }

    User user = User(username: username, email: email, password: password);

    try {
      dynamic result = await UserService().createUser(user);
      setState(() {
        if (result is String) {
          errorMessage = result;
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = "Registration failed: ${e.toString()}";
      });
    }
  }

  final Color customColor = Color(0xA08DDAFF);  //Insert custom color for textfields

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 200.0,
          centerTitle: true,
          title: Stack(
              children: [
                Positioned(
                  left: 5,
                  top: 25,
                  child: ClipOval(
                    child: Opacity(
                      opacity: 0.9,
                      child: Image.asset(
                        'assets/holographic.jpeg',
                        width: 1,
                        height: 1,
                        fit: BoxFit.cover, // Ensures the image fills the oval shape
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Text(
                    'register',
                    style: TextStyle(fontSize: 50.0,),
                  ),
                ),
              ]
          )




      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100.0,
            left: 16.0, right: 16.0
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('create your account', textAlign: TextAlign.center,),
              // Error message (initially invisible)
              Visibility(
                visible: errorMessage.isNotEmpty,
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),

              /*ClipOval(
              child: Opacity(
                opacity: 0.9,
                child: Image.asset(
                  'assets/holographic.jpeg',
                  width: 5,
                  height: 15,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),*/




              SizedBox(height: 16.0),
              // Username input field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  prefixIcon: Padding(        //Inserted image in textfield
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
                  prefixIcon: Padding(        //Inserted image in textfield
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
                  prefixIcon: Padding(        //Inserted image in textfield
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
              SizedBox(height: 16.0),
              // Password input field
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Padding(        //Inserted image in textfield
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
              SizedBox(height: 64.0),
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
                padding: EdgeInsets.only(top: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
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

            ]
        ),
      ),
    );
  }
}
