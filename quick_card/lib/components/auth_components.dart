import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthTextField extends StatefulWidget {
  final BuildContext buildContext;
  final TextEditingController controller;
  final String text;
  final String? imagePath; // Made imagePath nullable
  final bool obscureText;
  final FocusNode thisFocusNode;
  final FocusNode? nextFocusNode;

  const AuthTextField({
    super.key,
    required this.buildContext,
    required this.controller,
    required this.text,
    this.imagePath, // imagePath is now optional
    required this.obscureText,
    required this.thisFocusNode,
    this.nextFocusNode,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscured,
      focusNode: widget.thisFocusNode,
      onSubmitted: (_) {
        if (widget.nextFocusNode != null) {
          FocusScope.of(widget.buildContext).requestFocus(widget.nextFocusNode);
        } else {
          FocusScope.of(widget.buildContext).unfocus();
        }
      },
      decoration: InputDecoration(
        // Check if imagePath is not null, then display prefixIcon
        prefixIcon: widget.imagePath != null
            ? Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            widget.imagePath!,
            width: 15,
            height: 15,
          ),
        )
            : null, // No prefixIcon if imagePath is null
        labelText: widget.text,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color(0xFFDEDCFB),
        suffixIcon: widget.obscureText
            ? GestureDetector(
          onTap: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              _isObscured
                  ? 'assets/eye-slash-solid.svg'
                  : 'assets/eye-solid.svg',
              width: 15,
              height: 15,
            ),
          ),
        )
            : null,
      ),
    );
  }
}


class AuthButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const AuthButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff8EE4DF), // Background color
        foregroundColor: Colors.black, // Text color
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class LoadingButton extends StatelessWidget {
  const LoadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {}, // Disables the button
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff8EE4DF), // Background color
        foregroundColor: Colors.black, // Spinner color
      ),
      child: const SizedBox(
        width: 24.0,
        height: 24.0,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          color: Colors.black, // Spinner color
        ),
      ),
    );
  }
}
