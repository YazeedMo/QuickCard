// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quick_card/entity/card.dart' as c;

class CardFolderEdit extends StatelessWidget {
  final c.Card card;
  final bool isSelected; // Indicates whether the card is selected
  final ValueChanged<bool?> onSelected; // Callback for when the checkbox is toggled

  const CardFolderEdit({
    Key? key,
    required this.card,
    this.isSelected = false, // Default to false if not provided
    required this.onSelected, // Callback for checkbox state change
  }) : super(key: key);

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
        width: tileWidth, // Adjust width as needed
        height: tileHeight, // Adjust height as needed
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff382EF2), Color(0xff8EE4DF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3), // Changes shadow position
            ),
          ],
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
                        color: Colors.white,
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
                child: Image.asset(
                  card.imagePath?.isNotEmpty == true
                      ? card.imagePath!
                      : 'assets/default_card_image.jpg',
                  fit: BoxFit.contain,
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
