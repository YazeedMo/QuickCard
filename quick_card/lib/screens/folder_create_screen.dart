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
  String folderName;
  final String? folderImagePath;

  FolderCreateScreen({
    super.key,
    required this.folderName,
    this.folderImagePath,
  });

  @override
  State<FolderCreateScreen> createState() => _FolderCreateScreenState();
}

class _FolderCreateScreenState extends State<FolderCreateScreen> {
  String message = 'No cards yet. Go scan something 🤦‍♂️';
  final SessionService _sessionService = SessionService();
  final FolderService _folderService = FolderService();
  final CardService _cardService = CardService();
  List<dynamic> _cards = [];
  List<int> _selectedCardIds = [];
  int? _newFolderId;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    Session? currentSession = await _sessionService.getCurrentSession();
    int? currentUserId = currentSession!.currentUser;
    List allUserFolders =
        await _folderService.getFoldersByUserId(currentUserId!);
    Folder userDefaultFolder =
        allUserFolders.firstWhere((folder) => folder.name == 'default');
    List allCards =
        await _cardService.getAllCardsByFolderId(userDefaultFolder.id!);
    setState(() {
      _cards = allCards;
    });
  }

  Future<void> _createFolder() async {
    // Ensure a default folder name if none is provided
    if (widget.folderName.isEmpty) {
      widget.folderName = 'Folder';
    }

    // Retrieve the current user session
    Session? currentSession = await _sessionService.getCurrentSession();
    int currentUserId = currentSession!.currentUser!;

    // Create the new folder
    Folder newFolder = Folder(name: widget.folderName, userId: currentUserId);
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
      appBar: AppBar(
        title: Text('Add cards to folder'),
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
                            } else {
                              _selectedCardIds.remove(card.id);
                            }
                          });
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
                child: Text('Add cards and create folder'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}