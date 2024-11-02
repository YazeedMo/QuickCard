// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quick_card/entity/card.dart' as c;

class CardTile extends StatelessWidget {
  final c.Card card;
  final Function(BuildContext)? deleteFunction;
  final VoidCallback onTap;

  const CardTile({
    Key? key,
    required this.card,
    required this.deleteFunction,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final tileWidth = screenWidth * 0.6;
    final tileHeight = screenHeight * 0.3;

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showDeleteConfirmationDialog(context),
        child: Container(
          width: tileWidth,
          height: tileHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0.0),
                child: Text(
                  card.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: tileWidth * 0.9,
                height: tileHeight * 0.6,
                decoration: BoxDecoration(
                  color: Color(0xffa19bf7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), // Rounded corners from Version 1
                  child: Center(
                    child: card.imagePath != null &&
                        card.imagePath!.isNotEmpty
                        ? (card.imagePath!.startsWith("assets/")
                        ? Image.asset(
                      card.imagePath!,
                      fit: BoxFit.contain, // Uses BoxFit from Version 2
                    )
                        : (File(card.imagePath!).existsSync()
                        ? Image.file(
                      File(card.imagePath!),
                      fit: BoxFit.contain, // Uses BoxFit from Version 2
                    )
                        : Image.asset(
                      'assets/default_card_image.jpg',
                      fit: BoxFit.contain, // Uses BoxFit from Version 2
                    )))
                        : Image.asset(
                      'assets/default_card_image.jpg', // Default image if path is empty
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

              ),

            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Card'),
          content: Text('Are you sure you want to delete this card?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close dialog
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (deleteFunction != null) {
                  deleteFunction!(context); // Call delete function
                }
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

