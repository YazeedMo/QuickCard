import 'dart:io';
import 'package:flutter/material.dart';

class CardImageWidget extends StatelessWidget {
  final String? imagePath;

  const CardImageWidget({super.key, this.imagePath});

  Widget _buildImage() {
    if (imagePath == null || imagePath!.isEmpty) {
      // Show default image if `imagePath` is null or empty
      return Image.asset(
        'assets/default_card_image.jpg',
        fit: BoxFit.contain,
      );
    } else if (imagePath!.startsWith("assets/")) {
      // Load asset image
      return Image.asset(
        imagePath!,
        fit: BoxFit.contain,
      );
    } else {
      // Try loading from file, fallback to default image if file doesn't exist
      final file = File(imagePath!);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.contain,
        );
      } else {
        return Image.asset(
          'assets/default_card_image.jpg',
          fit: BoxFit.contain,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Center(
        child: _buildImage(),
      ),
    );
  }
}
