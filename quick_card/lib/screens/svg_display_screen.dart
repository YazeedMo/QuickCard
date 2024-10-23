// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgDisplayScreen extends StatelessWidget {
  final String svg; // String parameter to hold the SVG data

  const SvgDisplayScreen({Key? key, required this.svg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Code Display'),
      ),
      body: Center(
        child: SingleChildScrollView(
          // To allow scrolling if the SVG is larger than the screen
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the SVG image
              SvgPicture.string(
                svg,
                height: 100, // Adjust height as needed
                width: 50, // Adjust width as needed
                placeholderBuilder: (BuildContext context) =>
                    Container(
                      child: Center(child: CircularProgressIndicator()),
                      height: 300,
                      width: 300,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
