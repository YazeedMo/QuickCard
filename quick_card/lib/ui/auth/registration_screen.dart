import 'package:flutter/material.dart';
import 'package:quick_card/components/auth_components.dart';
import 'package:quick_card/components/snackbar_message.dart';
import 'package:quick_card/ui/auth/registration_controller.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final RegistrationController _registrationController =
      RegistrationController();
  final SnackBarMessage _snackBarMessage = SnackBarMessage();

  bool _isLoading = false;

  Future<void> _handleRegistration() async {
    setState(() {
      _isLoading = true;
    });

    String? message = await _registrationController.handleRegistration(context);
    if (message != null && mounted) {
      _snackBarMessage.showSnackBar(context, message, 2);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // Automatically adjusts for the keyboard
      body: SafeArea(
        child: SingleChildScrollView(
          // Makes the view scrollable
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Profile photo at the top
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // First Profile photo
                    Padding(
                      padding: const EdgeInsets.only(top:0),
            child: Image.asset(
              'assets/register-bubble.png',
              width: 330.0,
              height: 255.0,
              fit: BoxFit.contain,
            ),
          ),



                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top:0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 52.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10.0), // Spacing between the labels
                        const Text(
                          'Create your account',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16.0),
                        // username
                        AuthTextField(
                          buildContext: context,
                          controller:
                              _registrationController.usernameController,
                          text: 'Username',
                          imagePath: 'assets/user.png',
                          obscureText: false,
                          thisFocusNode:
                              _registrationController.usernameFocusNode,
                          nextFocusNode: _registrationController.emailFocusNode,
                        ),
                        const SizedBox(height: 16.0),
                        // email
                        AuthTextField(
                            buildContext: context,
                            controller: _registrationController.emailController,
                            text: 'Email address',
                            imagePath: 'assets/mail.png',
                            obscureText: false,
                            thisFocusNode:
                                _registrationController.emailFocusNode,
                            nextFocusNode:
                                _registrationController.passwordFocusNode),
                        const SizedBox(height: 16.0),
                        // password
                        AuthTextField(
                            buildContext: context,
                            controller:
                                _registrationController.passwordController,
                            text: 'Password',
                            imagePath: 'assets/lock.png',
                            obscureText: true,
                            thisFocusNode:
                                _registrationController.passwordFocusNode,
                            nextFocusNode: _registrationController
                                .confirmPasswordFocusNode),
                        const SizedBox(height: 16.0),
                        // confirm password
                        AuthTextField(
                            buildContext: context,
                            controller: _registrationController
                                .confirmPasswordController,
                            text: 'Confirm password',
                            imagePath: 'assets/lock.png',
                            obscureText: true,
                            thisFocusNode: _registrationController
                                .confirmPasswordFocusNode),

                        const SizedBox(height: 4.0),
                        // Stay logged in checkbox
                        CheckboxListTile(
                          title: const Text("Stay logged in"),
                          value: _registrationController.stayLoggedIn,
                          onChanged: (value) {
                            setState(() {
                              _registrationController.stayLoggedIn =
                                  value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        const SizedBox(height: 25.0),
                        // register button
                        _isLoading == true
                            ? const LoadingButton()
                            : AuthButton(
                                onTap: _handleRegistration, text: 'Register'),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text.rich(
                              TextSpan(
                                text: 'Already have an account? ',
                                children: [
                                  TextSpan(
                                    text: 'Login', // Bold text
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is removed from the widget tree
    _registrationController.usernameController.dispose();
    _registrationController.emailController.dispose();
    _registrationController.passwordController.dispose();
    _registrationController.confirmPasswordController.dispose();
    super.dispose();
  }
}
