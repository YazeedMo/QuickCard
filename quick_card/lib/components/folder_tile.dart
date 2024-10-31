// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quick_card/entity/folder.dart';

class FolderTile extends StatelessWidget {
  final Folder folder;
  final VoidCallback onTap;
  final Function(BuildContext)? deleteFunction;

  const FolderTile(
      {super.key,
      required this.folder,
      required this.onTap,
      required this.deleteFunction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showDeleteConfirmationDialog(context, folder.name),
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
              width: 150,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xffa19bf7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: folder.imagePath != null &&
                        folder.imagePath!.isNotEmpty &&
                        File(folder.imagePath!).existsSync()
                    ? Image.file(
                        File(folder.imagePath!),
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        'assets/default_folder_image.png', // Replace with your asset path
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            SizedBox(width: 16), // Space between image and folder name
            // Folder name text
            Expanded(
              child: Text(
                folder.name,
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
