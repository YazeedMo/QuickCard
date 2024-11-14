import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onPressed;
  String buttonText;
  AddButton({super.key,
  required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
        color: Color(0xFFDEDCFB),
    ),
      padding: EdgeInsets.only(left: 190, right: 16, top: 16, bottom: 16),
      child: SizedBox(width: 150.0,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xffa4a0f9),
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
          buttonText,
          style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
