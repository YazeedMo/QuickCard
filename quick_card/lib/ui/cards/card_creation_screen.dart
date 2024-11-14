import 'dart:io';

import 'package:barcode/barcode.dart' as bc;
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:quick_card/entity/card.dart' as c;
import 'package:quick_card/entity/session.dart';
import 'package:quick_card/service/card_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_card/service/session_service.dart';
import 'package:quick_card/util/card_utils.dart';

class CardCreationScreen extends StatefulWidget {
  final String barcodeData;
  final BarcodeFormat barcodeFormat;
  final bc.Barcode barcodeType;

  const CardCreationScreen(
      {super.key,
      required this.barcodeData,
      required this.barcodeFormat,
      required this.barcodeType});

  @override
  State<CardCreationScreen> createState() => _CardCreationScreenState();
}

class _CardCreationScreenState extends State<CardCreationScreen> {
  final CardService _cardService = CardService();
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  String _cardName = 'card';
  String _cardImagePath = '';
  File? _selectedImageFile;

  final TextEditingController _cardNameController =
      TextEditingController(text: 'card');

  List<Map<String, String>> preloadedIcons = CardUtils().premadeIcons;

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
        _cardImagePath = pickedFile.path;
      });
    }
  }

  void _showPreloadedIcons() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: preloadedIcons.length,
          itemBuilder: (context, index) {
            final icon = preloadedIcons[index];
            return ListTile(
              leading: Image.asset(icon['assetPath']!, width: 40, height: 40),
              title: Text(icon['name']!),
              onTap: () {
                setState(() {
                  _cardImagePath = icon['assetPath']!;
                  _cardName = icon['name']!;
                  _selectedImageFile =
                      null; // Clear custom image if preloaded is chosen
                  _cardNameController.text =
                      _cardName; // Update controller text
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _createNewCard() async {
    Session? session = await SessionService().getCurrentSession();
    int? userId = session!.currentUserId;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a new card object and save it
      c.Card newCard = c.Card(
          name: _cardName,
          data: widget.barcodeData,
          format: widget.barcodeFormat.toString(),
          svg: widget.barcodeType
              .toSvg(widget.barcodeData, width: 300, height: 100),
          imagePath: _cardImagePath,
          userId: userId!);

      // Save the card and return to the HomeScreen
      _cardService.createCard(newCard);
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Enter card details',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make the title bold
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_selectedImageFile != null)
                    Image.file(_selectedImageFile!, height: 150)
                  else if (_cardImagePath.isNotEmpty)
                    Image.asset(_cardImagePath, height: 150)
                  else
                    Image.asset(
                      'assets/default_card_image.jpg',
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(height: 50),
                  TextFormField(
                    controller: _cardNameController, // Set the controller here
                    decoration: const InputDecoration(labelText: 'Card name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a card name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _cardName = value!;
                    },
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF8EE4DF), // Button background color
                      foregroundColor: Colors.black, // Text color
                      minimumSize: const Size(380, 60),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0), // Adjust vertical padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15.0), // Button border radius
                      ),
                    ),
                    child: const Text(
                      'Pick image from gallery',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showPreloadedIcons,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF8EE4DF), // Button background color
                      foregroundColor: Colors.black, // Text color
                      minimumSize: const Size(380, 60),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0), // Adjust vertical padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15.0), // Button border radius
                      ),
                    ),
                    child: const Text(
                      'Choose from common icons',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _createNewCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF8EE4DF), // Button background color
                      foregroundColor: Colors.black, // Text color
                      minimumSize: const Size(380,
                          60), // Set size for the button (height increased)
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0), // Adjust vertical padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15.0), // Button border radius
                      ),
                    ),
                    child: const Text(
                      'Add card',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cardNameController.dispose();
    super.dispose();
  }
}
