// card_create_screen.dart

// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'dart:io';

import 'package:barcode/barcode.dart' as bc;
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:quick_card/entity/card.dart' as c;
import 'package:quick_card/entity/folder.dart';
import 'package:quick_card/entity/session.dart';
import 'package:quick_card/entity/user.dart';
import 'package:quick_card/service/card_service.dart';
import 'package:quick_card/service/folder_service.dart';
import 'package:quick_card/service/session_service.dart';
import 'package:quick_card/service/user_service.dart';
import 'package:image_picker/image_picker.dart';

class CardCreateScreen extends StatefulWidget {
  final String barcodeData;
  final BarcodeFormat barcodeFormat;
  final bc.Barcode barcodeType;

  CardCreateScreen(
      {required this.barcodeData,
      required this.barcodeFormat,
      required this.barcodeType});

  @override
  _CardCreateScreenState createState() => _CardCreateScreenState();
}

class _CardCreateScreenState extends State<CardCreateScreen> {
  final UserService _userService = UserService();
  final FolderService _folderService = FolderService();
  final CardService _cardService = CardService();
  final SessionService _sessionService = SessionService();
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  String _cardName = 'card';
  String _cardImagePath = '';
  File? _selectedImageFile;

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
        _cardImagePath = pickedFile.path;
      });
    } else {
      print("No image selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Card Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
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
              // Image picker?
              _selectedImageFile != null
                  ? Image.file(_selectedImageFile!, height: 150)
                  : ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Pick Image from Gallery'),
                    ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Add Card'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    Session? session = await _sessionService.getCurrentSession();
    User? currentUser = await _userService.getUserById(session!.currentUser!);
    List allUserFolders =
        await _folderService.getFoldersByUserId(currentUser!.id!);
    Folder userDefaultFolder =
        await allUserFolders.firstWhere((folder) => folder.name == 'default');

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a new card object and save it
      c.Card newCard = c.Card(
        name: _cardName,
        data: widget.barcodeData,
        barcodeFormat: widget.barcodeFormat.toString(),
        svg: widget.barcodeType.toSvg(widget.barcodeData,
            width: 300,
            height: 100),
        folderId: userDefaultFolder.id!,
        imagePath: _cardImagePath
      );

      // Save the card and return to the HomeScreen
      _cardService.createCard(newCard);
      Navigator.pop(context, true);
    }
  }
}
