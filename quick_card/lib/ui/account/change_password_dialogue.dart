import 'package:flutter/material.dart';

class ChangePasswordDialogue extends StatefulWidget {
  final String originalPassword;
  final Function(String) changePassword;

  const ChangePasswordDialogue(
      {super.key,
        required this.originalPassword,
        required this.changePassword});

  @override
  State<ChangePasswordDialogue> createState() => _ChangePasswordDialogueState();
}

class _ChangePasswordDialogueState extends State<ChangePasswordDialogue> {
  final formKey = GlobalKey<FormState>();
  String currentPassword = '';
  String newPassword = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Change Password"),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "Current Password"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your current password';
                } else if (value != widget.originalPassword) {
                  return 'Current password is incorrect';
                }
                return null;
              },
              onChanged: (value) {
                currentPassword = value;
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "New Password"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a new password';
                }
                return null;
              },
              onChanged: (value) {
                newPassword = value;
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "Confirm Password"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                } else if (value != newPassword) {
                  return 'Passwords do not match';
                }
                return null;
              },
              onChanged: (value) {
                confirmPassword = value;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        TextButton(
          child: Text("Change"),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              widget.changePassword(newPassword);
              Navigator.of(context).pop(); // Close the dialog
              // Optionally, show a success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Password changed successfully!')),
              );
            }
          },
        ),
      ],
    );
  }
}

