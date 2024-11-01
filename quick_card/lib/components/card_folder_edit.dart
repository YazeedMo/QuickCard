// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quick_card/entity/card.dart' as c;

class CardFolderEdit extends StatelessWidget {
  final c.Card card;
  final bool isSelected;
  final ValueChanged<bool?> onSelected;

  const CardFolderEdit({
    super.key,
    required this.card,
    this.isSelected = false,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Set tile dimensions as a fraction of the screen size
    final tileWidth = screenWidth * 0.4;
    final tileHeight = screenHeight * 0.2;

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        width: tileWidth * 0.9,
        height: tileHeight * 0.6,
        decoration: BoxDecoration(
          color: Color(0xffa19bf7),
          borderRadius: BorderRadius.circular(20),
          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Checkbox for selection
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: onSelected,
                  activeColor: Colors.tealAccent,
                ),
                // Card Name at the top
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.0),
                    child: Text(
                      card.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 1, // Prevents overflow by limiting to a single line
                      overflow: TextOverflow.ellipsis, // Adds "..." if text is too long
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Main Image/Logo or Default Image in the center
            Container(
              width: tileWidth * 0.8,
              height: tileHeight * 0.6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: card.imagePath != null &&
                    card.imagePath!.isNotEmpty &&
                    File(card.imagePath!).existsSync()
                    ? Image.file(
                  File(card.imagePath!),
                  fit: BoxFit.contain,
                )
                    : Image.asset(
                  'assets/default_card_image.jpg', // Replace with your asset path
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
