// card_detail_screen.dart

// ignore_for_file: prefer_const_constructors

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

class CardDetailScreen extends StatefulWidget {
  final String barcodeData;
  final BarcodeFormat barcodeFormat;
  final bc.Barcode barcodeType;

  CardDetailScreen({required this.barcodeData, required this.barcodeFormat, required this.barcodeType});

  @override
  _CardDetailScreenState createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {

  final UserService _userService = UserService();
  final FolderService _folderService = FolderService();
  final CardService _cardService = CardService();
  final SessionService _sessionService = SessionService();

  final _formKey = GlobalKey<FormState>();
  String _cardName = '';
  String _cardDescription = '';
  String _cardImage = '';

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
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cardDescription = value!;
                },
              ),
              // Image picker?
              TextFormField(
                decoration: InputDecoration(labelText: 'Image URL'),
                onSaved: (value) {
                  _cardImage = value ?? '';
                },
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

  void _submit() async{

    Session? session = await _sessionService.getCurrentSession();
    User? currentUser = await _userService.getUserById(session!.currentUser!);
    List allUserFolders = await _folderService.getFoldersByUserId(currentUser!.id!);
    Folder userDefaultFolder = await allUserFolders.firstWhere((folder) => folder.name == 'default');


    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a new card object and save it
      c.Card newCard = c.Card(
        name: _cardName,
        data: widget.barcodeData,
        barcodeFormat: widget.barcodeFormat.toString(),
        svg: widget.barcodeType.toSvg(widget.barcodeData, width: 300, height: 100), // You can generate SVG based on the barcode data if needed
        folderId: userDefaultFolder.id!, // Update this based on your folder logic
      );

      // Save the card and return to the HomeScreen
      _cardService.createCard(newCard);
      Navigator.pop(context, true);

    }
  }
}
