// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class FolderTile extends StatelessWidget {
  final String folderName;
  final String? imagePath; // Image path of the latest card in the folder (optional)
  final VoidCallback onTap;

  const FolderTile({
    required this.folderName,
    this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Trigger the onTap function when tapped
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3), // Adds shadow below the component
            ),
          ],
        ),
        child: Row(
          children: [
            // Folder image or default image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[200],
                image: DecorationImage(
                  image: imagePath != null
                      ? AssetImage(imagePath!)
                      : AssetImage('assets/default_folder.png'), // Placeholder default image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16), // Space between image and folder name
            // Folder name text
            Expanded(
              child: Text(
                folderName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
