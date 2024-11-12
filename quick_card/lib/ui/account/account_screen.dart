// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quick_card/entity/session.dart';
import 'package:quick_card/entity/user.dart';
import 'package:quick_card/ui/account/change_password_dialogue.dart';
import 'package:quick_card/ui/auth/login_screen.dart';
import 'package:quick_card/service/session_service.dart';
import 'package:quick_card/service/user_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final SessionService _sessionService = SessionService();
  final UserService _userService = UserService();

  User? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    Session? session = await _sessionService.getCurrentSession();
    User? currentUser = await _userService.getUserById(session!.currentUserId!);
    setState(() {
      user = currentUser;
    });
  }

  void _logout() async {
    // Handle logout logic
    await _sessionService.clearSession();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false, // This will remove all routes before the LoginScreen
    );
  }

  void _changePassword(String newPassword) async {

    user!.password = newPassword;
    await _userService.updateUser(user!);

  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("delete account"),
          content: Text("are you sure you want to delete your account? this action cannot be undone."),
          actions: [
            TextButton(
              child: Text("cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("delete"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteAccount();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount() async {
    await _userService.deleteUserById(user!.id!);
    _logout();
  }

  void _showChangePasswordDialog() {
    showDialog(context: context, builder: (BuildContext context) {
      return ChangePasswordDialogue(originalPassword: user!.password, changePassword: _changePassword);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDEDCFB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Username and Email display
            Center(
              child: Column(
                children: [
                  Text(
                    user?.username ?? 'loading...',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    user?.email ?? 'loading...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 60),

            // Change Password button
            ElevatedButton(
              onPressed: _showChangePasswordDialog, // Show change password dialog
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffa4a0f9),
                padding: EdgeInsets.symmetric(vertical: 14.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: Text(
                'change password',
                style: TextStyle(fontSize: 23, color: Colors.black,fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),

            // Logout button
            ElevatedButton(
              onPressed: _logout, // Use the logout function
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffa4a0f9),
                padding: EdgeInsets.symmetric(vertical: 14.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: Text(
                'logout',
                style: TextStyle(fontSize: 23, color: Colors.black,fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),

            // Delete Account button
            ElevatedButton(
              onPressed: _showDeleteAccountDialog, // Show delete confirmation dialog
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffa4a0f9),
                padding: EdgeInsets.symmetric(vertical: 14.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: Text(
                'delete account',
                style: TextStyle(fontSize: 23, color: Colors.black,fontWeight: FontWeight.bold ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
