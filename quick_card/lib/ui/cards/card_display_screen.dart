import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quick_card/entity/card.dart' as c;
import 'package:quick_card/service/card_service.dart';
import 'package:quick_card/ui/cards/card_edit_screen.dart';

class CardDisplayScreen extends StatefulWidget {
  final c.Card card;

  const CardDisplayScreen({super.key, required this.card});

  @override
  _CardDisplayScreenState createState() => _CardDisplayScreenState();
}

class _CardDisplayScreenState extends State<CardDisplayScreen> {
  late c.Card card;

  @override
  void initState() {
    super.initState();
    card = widget.card; // Initialize card with the passed-in card
  }

  void _editCard(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CardEditScreen(card: card)),
    );

    if (result == true) {
      // Assume that the edited card is returned and update the state accordingly
      setState(() {
        card; // Update card with the edited result if returned
      });
    }
  }

  void _deleteCard(int id) async {
    await CardService().deleteCardById(id);
    Navigator.pop(context, true);
  }

  // Handle the back button press to send true back
  Future<bool> _onWillPop() async {
    Navigator.pop(context, true);  // Send true when back button is pressed
    return false;  // Prevent default back button behavior
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Card'),
          content: Text('Are you sure you want to delete this card?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close dialog
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteCard(card.id!);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Intercept back button press
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0), // Custom height for AppBar
          child: AppBar(
            backgroundColor: Colors.white,
            flexibleSpace: Center( // Center content in the AppBar
              child: Text(
                "Loyalty card's barcode",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.black),
                onPressed: () => _editCard(context),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.black),
                onPressed: _showDeleteConfirmationDialog,
              ),
            ],
          ),
        ),
        body: Center( // Center the whole body content
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              Image.asset(
                'assets/shopping.gif',
                width: 220,
                height: 220,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 180),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Wrap the SVG in a Container for better size control
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: 200, // Set a maximum height
                          maxWidth: 300, // Set a maximum width
                        ),
                        child: SvgPicture.string(
                          card.svg,
                          fit: BoxFit.contain, // Maintain aspect ratio
                          placeholderBuilder: (BuildContext context) => Container(
                            child: Center(child: CircularProgressIndicator()),
                            height: 100,
                            width: 200,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
