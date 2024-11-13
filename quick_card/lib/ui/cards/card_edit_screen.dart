import 'dart:io';

import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_card/components/auth_components.dart';
import 'package:quick_card/components/card_image_widget.dart';
import 'package:quick_card/components/snackbar_message.dart';
import 'package:quick_card/entity/card.dart' as c;
import 'package:quick_card/entity/session.dart';
import 'package:quick_card/service/card_service.dart';
import 'package:quick_card/service/session_service.dart';
import 'package:quick_card/util/barcode_utils.dart';
import 'package:quick_card/util/card_utils.dart';

class CardEditScreen extends StatefulWidget {
  final c.Card card;

  const CardEditScreen({super.key, required this.card});

  @override
  State<CardEditScreen> createState() => _CardEditScreenState();
}

class _CardEditScreenState extends State<CardEditScreen> {
  final CardService _cardService = CardService();
  final ImagePicker _imagePicker = ImagePicker();
  final SnackBarMessage _snackBarMessage = SnackBarMessage();

  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final FocusNode _cardNameFocusNode = FocusNode();
  final FocusNode _cardNumberFocusNode = FocusNode();

  String _cardName = '';
  String _cardImagePath = '';
  File? _selectedImageFile;

  List<Map<String, String>> preLoadedIcons = CardUtils().premadeIcons;

  final String _selectedFormat = 'code 128';

  @override
  void initState() {
    super.initState();
    _cardNameController.text = widget.card.name;
    _cardNumberController.text = widget.card.data;
  }

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
        widget.card.imagePath = pickedFile.path;
      });
    }
  }

  void _showPreloadedIcons() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: preLoadedIcons.length,
          itemBuilder: (context, index) {
            final icon = preLoadedIcons[index];
            return ListTile(
              leading: Image.asset(icon['assetPath']!, width: 40, height: 40),
              title: Text(icon['name']!),
              onTap: () {
                setState(() {
                  widget.card.imagePath = icon['assetPath']!;
                  _cardName = icon['name']!;
                  _selectedImageFile =
                  null; // Clear custom image if preloaded is chosen
                  _cardNameController.text =
                      _cardName; // Update controller text
                });
                Navigator.pop(context, true);
              },
            );
          },
        );
      },
    );
  }

  void _createNewCard() async {

    String? message = validateInput();
    if (message != null) {
      _snackBarMessage.showSnackBar(context, message, 2);
      return;
    }

    widget.card.name = _cardNameController.text.trim();
    widget.card.data = _cardNumberController.text.trim();
    Barcode barcode = BarcodeUtils().getBarcodeType(null);
    widget.card.svg = barcode.toSvg(widget.card.data, width: 200, height: 100);

    await _cardService.updateCard(widget.card);

    if (mounted) {
      Navigator.pop(context, true);
    }

  }

  String? validateInput() {
    if (_cardNameController.text.isEmpty) {
      return 'Please enter card name';
    }
    if (_cardNumberController.text.isEmpty) {
      return 'Please enter barcode number';
    }
    return null;
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
            fontWeight: FontWeight.bold,

          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  height: 150,
                    child: CardImageWidget(imagePath: widget.card.imagePath,),
                ),
                SizedBox(height: 30,),
                AuthTextField(
                  buildContext: context,
                  controller: _cardNameController,
                  text: 'Card name',
                  obscureText: false,
                  thisFocusNode: _cardNameFocusNode,
                  nextFocusNode: _cardNumberFocusNode,
                ),
                SizedBox(height: 30,),
                AuthTextField(
                    buildContext: context,
                    controller: _cardNumberController,
                    text: 'Barcode number',
                    obscureText: false,
                    thisFocusNode: _cardNumberFocusNode,
                ),
                SizedBox(height: 80,),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffa4a0f9), // Background color
                    foregroundColor: Colors.black, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),

                    ),
                    minimumSize: Size(double.infinity, 70),
                  ),
                  child: Text(
                    "Pick image from gallery",
                    style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 50,),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffa4a0f9), // Background color
                    foregroundColor: Colors.black, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: Size(double.infinity, 70),
                  ),
                  child: Text(
                    "Choose from premade icons",
                    style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 50,),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffa4a0f9), // Background color
                    foregroundColor: Colors.black, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: Size(double.infinity, 70),
                  ),
                  child: Text(
                    "Add card",
                    style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
