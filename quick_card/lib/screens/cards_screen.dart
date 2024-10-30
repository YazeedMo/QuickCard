// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quick_card/components/card_tile.dart';
import 'package:quick_card/entity/folder.dart';
import 'package:quick_card/entity/session.dart';
import 'package:quick_card/screens/mobile_scanner_screen.dart';
import 'package:quick_card/screens/svg_display_screen.dart';
import 'package:quick_card/service/card_service.dart';
import 'package:quick_card/service/folder_service.dart';
import 'package:quick_card/service/session_service.dart';
import 'package:quick_card/entity/card.dart' as c;

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  String message = 'No code scanned yet';
  final SessionService _sessionService = SessionService();
  final FolderService _folderService = FolderService();
  final CardService _cardService = CardService();
  List<dynamic> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    Session? currentSession = await _sessionService.getCurrentSession();
    int? currentUserId = currentSession!.currentUser;
    List<Folder> allUserFolders =
        await _folderService.getFoldersByUserId(currentUserId!);
    List<c.Card> allCards = [];
    for (Folder folder in allUserFolders) {
      List<c.Card> allFolderCards = await _cardService.getAllCardsByFolderId(folder.id!);
      allCards.addAll(allFolderCards);
    }
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
                        builder: (context) => SvgDisplayScreen(svg: card.svg),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCard,
        backgroundColor: Color(0xff8EE4DF),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addNewCard() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MobileScannerScreen()),
    );
    if (result == true) {
      _loadCards();
    }
  }
}
