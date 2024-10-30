// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class FolderTile extends StatelessWidget {
  final String folderName;
  final String? imagePath; // Image path of the latest card in the folder (optional)
  final VoidCallback onTap;
  final Function(BuildContext)? deleteFunction;

  const FolderTile({
    required this.folderName,
    this.imagePath,
    required this.onTap,
    required this.deleteFunction
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showDeleteConfirmationDialog(context, folderName),
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
                      : AssetImage('assets/default_folder_image.png'), // Placeholder default image
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

  void _showDeleteConfirmationDialog(BuildContext context, String folderName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Determine the appropriate dialog to show
        if (folderName == 'default') {
          return AlertDialog(
            title: Text('Default Folder'),
            content: Text('You cannot delete the default folder.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // Close dialog
                child: Text('OK'),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text('Delete Folder'),
            content: Text('Are you sure you want to delete this folder?'),
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
        }
      },
    );
  }


}


