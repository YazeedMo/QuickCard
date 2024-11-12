// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quick_card/components/card_tile.dart';
import 'package:quick_card/entity/folder.dart';
import 'package:quick_card/ui/cards/card_display_screen.dart';
import 'package:quick_card/service/card_service.dart';

class FolderCardsScreen extends StatefulWidget {
  final Folder folder;

  const FolderCardsScreen({super.key, required this.folder});

  @override
  State<FolderCardsScreen> createState() => _FolderCardsScreenState();
}

class _FolderCardsScreenState extends State<FolderCardsScreen> {
  String message = 'no cards in this folder';
  final CardService _cardService = CardService();
  List<dynamic> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    List allCards = await _cardService.getAllCardsByFolderId(widget.folder.id!);
    setState(() {
      _cards = allCards;
    });
  }

  void _deleteCard(int id) async {
    await _cardService.deleteCardById(id);
    _loadCards(); // Reload the list of cards after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDEDCFB),
      appBar: AppBar(
        backgroundColor: Color(0xFFDEDCFB),
        title: Text('folder: ${widget.folder.name} '),
      ),
      body: _cards.isEmpty
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
                  deleteFunction: (context) => _deleteCard(card.id),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardDisplayScreen(svg: card.svg),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
