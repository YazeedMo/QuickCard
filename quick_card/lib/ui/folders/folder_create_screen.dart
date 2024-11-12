// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quick_card/components/card_folder_edit.dart';
import 'package:quick_card/entity/folder.dart';
import 'package:quick_card/entity/session.dart';
import 'package:quick_card/service/card_service.dart';
import 'package:quick_card/service/folder_service.dart';
import 'package:quick_card/service/session_service.dart';
import 'package:quick_card/entity/card.dart' as q;

class FolderCreateScreen extends StatefulWidget {
  final String folderName;
  final String? folderImagePath;

  const FolderCreateScreen({
    super.key,
    required this.folderName,
    this.folderImagePath,
  });

  @override
  State<FolderCreateScreen> createState() => _FolderCreateScreenState();
}

class _FolderCreateScreenState extends State<FolderCreateScreen> {

  final SessionService _sessionService = SessionService();
  final FolderService _folderService = FolderService();
  final CardService _cardService = CardService();

  String message = 'no cards yet. go scan something️';

  List<dynamic> _cards = [];
  List<int> _selectedCardIds = [];
  int? _newFolderId;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    Folder userDefaultFolder = await _folderService.getCurrentUserDefaultFolder();
    List allCards =
        await _cardService.getAllCardsByFolderId(userDefaultFolder.id!);
    setState(() {
      _cards = allCards;
    });
  }

  Future<void> _createFolder() async {

    // Retrieve the current user session
    Session? currentSession = await _sessionService.getCurrentSession();
    int currentUserId = currentSession!.currentUser!;

    // Create the new folder
    Folder newFolder = Folder(name: widget.folderName, userId: currentUserId, imagePath: widget.folderImagePath);
    _newFolderId = await _folderService.createFolder(newFolder);

    // Assign each selected card to the new folder
    for (var cardId in _selectedCardIds) {
      await _assignFolderToCard(cardId);
    }

    Navigator.pop(context, true);  // Close the dialog and pass success status
  }

  Future<void> _assignFolderToCard(int id) async {
    q.Card? card = await _cardService.getCardById(id);

    if (card != null) {
      card.folderId = _newFolderId!;
      await _cardService.updateCard(card);
    }
    else {
      print('Error: Card with ID $id not found');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDEDCFB),
      appBar: AppBar(
        backgroundColor: Color(0xFFDEDCFB),
        title: Text('add cards to folder'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _cards.isEmpty
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
                      return CardFolderEdit(
                        card: card,
                        isSelected: _selectedCardIds.contains(card.id),
                        onSelected: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedCardIds.add(card.id);
                            }
                            else {
                              _selectedCardIds.remove(card.id);
                            }
                          }
                          );
                        },
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  _createFolder();
                },
                child: Text('add cards and create folder'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
