// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class SplashScreenMain extends StatelessWidget {
  const SplashScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to QuickCard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color
              ),
            ),
            SizedBox(height: 20), // Spacing between the text and the indicator
            CircularProgressIndicator(), // Circular progress indicator
          ],
        ),
      ),
    );
  }
}