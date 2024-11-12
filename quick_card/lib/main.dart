// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quick_card/entity/session.dart';
import 'package:quick_card/ui/home/home_screen.dart';
import 'package:quick_card/ui/auth/login_screen.dart';
import 'package:quick_card/ui/splash/splash_screen_main.dart';
import 'package:quick_card/service/session_service.dart';

void main() async {
  // Ensure Flutter binding is initialized before using any async code
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final SessionService _sessionService = SessionService();

  Future<bool> _initializeAndCheckStayLoggedIn() async {
    // Simulating a longer loading time for testing
    // Initialize session if needed
    Session session = await _sessionService.initializeSessionIfNeeded();
    // Return the stayLoggedIn status from the session
    return session.stayLoggedIn ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _initializeAndCheckStayLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreenMain();
          }
          if (snapshot.hasData && snapshot.data == true) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
