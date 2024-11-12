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
  String newPassword = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("change password ${widget.originalPassword}"),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "new password"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter a new password';
                }
                return null;
              },
              onChanged: (value) {
                newPassword = value;
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "confirm password"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please confirm your password';
                } else if (value != newPassword) {
                  return 'passwords do not match';
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
          child: Text("cancel"),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        TextButton(
          child: Text("change"),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              widget.changePassword(newPassword);
              Navigator.of(context).pop(); // Close the dialog
              // Optionally, show a success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('password changed successfully!')),
              );
            }
          },
        ),
      ],
    );
  }
}
