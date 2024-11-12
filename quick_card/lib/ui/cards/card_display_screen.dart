// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardDisplayScreen extends StatelessWidget {
  final String svg; // String parameter to hold the SVG data

  const CardDisplayScreen({super.key, required this.svg});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), // Custom height for AppBar
        child: AppBar(
          backgroundColor: Colors.white,
          flexibleSpace: Center( // Center content in the AppBar
            child: Text(
              "loyalty card's barcode",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: Center( // Center the whole body content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:  [
            SizedBox(height: 60),
            Image.asset(
              'assets/shopping.gif',
              width: 220,
              height: 220,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 180),

            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Wrap the SVG in a Container for better size control
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: 200, // Set a maximum height
                        maxWidth: 300, // Set a maximum width
                      ),
                      child: SvgPicture.string(
                        svg,
                        fit: BoxFit.contain, // Maintain aspect ratio
                        placeholderBuilder: (BuildContext context) => Container(
                          child: Center(child: CircularProgressIndicator()),
                          height: 100,
                          width: 200,
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
    );
  }
}
