import 'package:flutter/material.dart';
import 'package:quick_card/components/auth_components.dart';
import 'package:quick_card/components/snackbar_message.dart';
import 'package:quick_card/ui/auth/login_controller.dart';
import 'package:quick_card/ui/auth/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController loginController = LoginController();
  final SnackBarMessage _snackBarMessage = SnackBarMessage();

  String? _message;
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    _message = await loginController.handleLogin(context);
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
      backgroundColor: Colors.white,
        body: Center(
            child: SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Profile photo at the top
                  Align(
                    alignment: Alignment.topCenter,  // Aligns the image to the top of the screen
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),  // Ensure no padding at the top
                      child: Image.asset(
                        'assets/login-bubble.jpg',
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.30,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

            Center(
              child: Column(
                children: [
                  const Text(
                    'Welcome to',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  RichText(
                    text: const TextSpan(
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
            const SizedBox(height: 20.0),
            // Login subtitle
            const Center(
              child: Text(
                'Login to your account',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            // username
            AuthTextField(
                buildContext: context,
                controller: loginController.usernameController,
                text: 'Username',
                imagePath: 'assets/user.png',
                obscureText: false,
                thisFocusNode: loginController.usernameFocusNode,
                nextFocusNode: loginController.passwordFocusNode),
            const SizedBox(height: 25.0),
            // password
            AuthTextField(
                buildContext: context,
                controller: loginController.passwordController,
                text: 'Password',
                imagePath: 'assets/lock.png',
                obscureText: true,
                thisFocusNode: loginController.passwordFocusNode),
            const SizedBox(height: 4.0),
            CheckboxListTile(
              title: const Text('Remember me?'),
              value: loginController.stayLoggedIn,
              onChanged: (value) {
                setState(() {
                  loginController.stayLoggedIn = value ?? true;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            // Login button with bold black text
            const SizedBox(height: 10.0),
            _isLoading == true
                ? const LoadingButton()
                : AuthButton(onTap: _handleLogin, text: 'Login'),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen()));
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    children: [
                      TextSpan(
                        text: 'Sign up', // Bold text
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
