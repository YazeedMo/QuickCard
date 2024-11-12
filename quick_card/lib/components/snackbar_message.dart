import 'package:flutter/material.dart';

class SnackBarMessage {

  bool isVisible = false;

  void showSnackBar(BuildContext buildContext, String message, int seconds) {
    if (!isVisible) {
      isVisible = true;
      ScaffoldMessenger.of(buildContext)
      .showSnackBar(
        SnackBar(
            content: Text(message),
          duration: Duration(seconds: seconds)
        ),
      )
      .closed
      .then((_) {
        isVisible = false;
      });
    }
  }

}