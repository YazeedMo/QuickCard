// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quick_card/components/card_tile.dart';
import 'package:quick_card/screens/card_scanner_screen.dart';
import 'package:quick_card/screens/svg_display_screen.dart';
import 'package:quick_card/service/card_service.dart';
import 'package:quick_card/entity/card.dart' as c;

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final CardService _cardService = CardService();
  String message = 'No code scanned yet';
  List<c.Card> _cards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    setState(() {
      _isLoading = true;
    });
    _cards = await _cardService.getAllCurrentUserCards();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _goToCardScanner() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CardScannerScreen()),
    );
    if (result == true) {
      _loadCards();
    }
  }

  void _deleteCard(int id) async {
    await _cardService.deleteCardById(id);
    _loadCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDEDCFB),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator(), // Spinner in center when loading
            )
          : _cards.isEmpty
              ? Center(
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 20.0),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two columns
                    crossAxisSpacing: 10.0, // Spacing between columns
                    mainAxisSpacing: 0, // Spacing between rows
                    childAspectRatio: 0.9, // Aspect ratio of each card
                  ),
                  padding: const EdgeInsets.all(10.0),
                  itemCount: _cards.length,
                  itemBuilder: (context, index) {
                    final card = _cards[index];
                    return CardTile(
                      card: card,
                      deleteFunction: (context) => _deleteCard(card.id!),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SvgDisplayScreen(svg: card.svg),
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: SizedBox(
        width: 150.0,
        child: ElevatedButton(
          onPressed: _goToCardScanner,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xffa4a0f9),
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            'add card',
            style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
