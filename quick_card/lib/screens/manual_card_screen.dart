// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'dart:io';
import 'package:barcode/barcode.dart' as bc;
import 'package:flutter/material.dart';
import 'package:quick_card/entity/card.dart' as c;
import 'package:quick_card/entity/folder.dart';
import 'package:quick_card/service/card_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_card/service/folder_service.dart';
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
  String _selectedFormat = 'Code 128'; // Default selection

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
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a barcode instance based on the selected type
      bc.Barcode barcodeType = bc.Barcode.code128();

      Folder folder = await FolderService().getCurrentUserDefaultFolder();

      // Generate the SVG string for the barcode
      String svg = barcodeType.toSvg(_manualCode, width: 300, height: 100);

      c.Card newCard = c.Card(
        name: _cardName,
        data: _manualCode,
        barcodeFormat: _selectedFormat,
        svg: svg,
        folderId: folder.id!, // Update with appropriate folder ID
        imagePath: _cardImagePath,
      );

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
                  _selectedImageFile = null; // Clear custom image if premade is chosen
                  _cardNameController.text = _cardName; // Update controller text
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
      appBar: AppBar(
        title: Text('Enter Card Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Centers the content vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Centers the content horizontally
              children: [
                TextFormField(
                  controller: _cardNameController, // Set the controller here
                  decoration: InputDecoration(labelText: 'Card Name'),
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

                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Manual Code'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the code';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _manualCode = value!;
                  },
                ),
                SizedBox(height: 16),
                if (_selectedImageFile != null)
                  Image.file(_selectedImageFile!, height: 150)
                else if (_cardImagePath.isNotEmpty)
                  Image.asset(_cardImagePath, height: 150),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Image from Gallery'),
                ),
                // New button to show premade icons
                ElevatedButton(
                  onPressed: _showPremadeIcons,
                  child: Text('Choose from Premade Icons'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _createNewCard,
                  child: Text('Add Card'),
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
