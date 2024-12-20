// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'dart:io';
import 'package:barcode/barcode.dart' as bc;
import 'package:flutter/material.dart';
import 'package:quick_card/entity/card.dart' as c;
import 'package:quick_card/entity/session.dart';
import 'package:quick_card/service/card_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_card/service/session_service.dart';
import 'package:quick_card/util/card_utils.dart';

class ManualCardScreen extends StatefulWidget {
  @override
  State<ManualCardScreen> createState() => _ManualCardScreenState();
}

class _ManualCardScreenState extends State<ManualCardScreen> {
  final CardService _cardService = CardService();
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  String _cardName = '';
  String _manualCode = '';
  String _cardImagePath = '';
  File? _selectedImageFile;

  final TextEditingController _cardNameController = TextEditingController();

  List<Map<String, String>> premadeIcons = CardUtils().premadeIcons;

  // Default barcode formats
  final String _selectedFormat = 'code 128'; // Default selection

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

  void _createNewCard() async {
    Session? session = await SessionService().getCurrentSession();
    int? userId = session!.currentUserId;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a barcode instance based on the selected type
      bc.Barcode barcodeType = bc.Barcode.code128();

      // Generate the SVG string for the barcode
      String svg = barcodeType.toSvg(_manualCode, width: 300, height: 100);

      c.Card newCard = c.Card(
          name: _cardName,
          data: _manualCode,
          format: _selectedFormat,
          svg: svg,
          imagePath: _cardImagePath,
          userId: userId!);

      // Save the card and return to the previous screen
      await _cardService.createCard(newCard);
      Navigator.pop(context, true);
    }
  }

  void _showPremadeIcons() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: premadeIcons.length,
          itemBuilder: (context, index) {
            final icon = premadeIcons[index];
            return ListTile(
              leading: Image.asset(icon['assetPath']!, width: 40, height: 40),
              title: Text(icon['name']!),
              onTap: () {
                setState(() {
                  _cardImagePath = icon['assetPath']!;
                  _cardName = icon['name']!;
                  _selectedImageFile =
                      null; // Clear custom image if premade is chosen
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
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
                mainAxisSize:
                    MainAxisSize.min, // Centers the content vertically
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Centers the content horizontally
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

                  SizedBox(height: 80),
                  TextFormField(
                    controller: _cardNameController, // Set the controller here
                    decoration: InputDecoration(labelText: 'Card name'),
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

                  SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Barcode number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the barcode';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _manualCode = value!;
                    },
                  ),
                  SizedBox(height: 70),
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFF8EE4DF), // Button background color
                      foregroundColor: Colors.black, // Text color
                      minimumSize: Size(380, 60),
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0), // Adjust vertical padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15.0), // Button border radius
                      ),
                    ),
                    child: Text(
                      'Pick image from gallery',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                  // New button to show premade icons
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _showPremadeIcons,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFF8EE4DF), // Button background color
                      foregroundColor: Colors.black, // Text color
                      minimumSize: Size(380, 60),
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0), // Adjust vertical padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15.0), // Button border radius
                      ),
                    ),
                    child: Text(
                      'Choose from premade icons',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _createNewCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFF8EE4DF), // Button background color
                      foregroundColor: Colors.black, // Text color
                      minimumSize: Size(380,
                          60), // Set size for the button (height increased)
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0), // Adjust vertical padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15.0), // Button border radius
                      ),
                    ),
                    child: Text(
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
