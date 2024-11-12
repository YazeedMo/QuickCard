import 'package:flutter/material.dart';
import 'package:quick_card/components/card_tile.dart';
import 'package:quick_card/components/add_button.dart';
import 'package:quick_card/ui/cards/card_scanner_screen.dart';
import 'package:quick_card/ui/cards/card_display_screen.dart';
import 'package:quick_card/service/card_service.dart';
import 'package:quick_card/entity/card.dart' as c;


class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final CardService _cardService = CardService();
  String message = 'no code scanned yet';
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
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

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

  void displayBarcode(c.Card card) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CardDisplayScreen(card: card)));
    if (result == true) {
      _loadCards();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDEDCFB),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(), // Spinner in center when loading
            )
          : _cards.isEmpty
              ? Center(
                  child: Text(
                    message,
                    style: const TextStyle(fontSize: 20.0),
                  ),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        displayBarcode(card);
                      },
                    );
                  },
                ),
      floatingActionButton: AddButton(buttonText: 'add card',onPressed: _goToCardScanner)
    );
  }
}
