// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quick_card/entity/folder.dart';
import 'package:quick_card/entity/session.dart';
import 'package:quick_card/entity/user.dart';
import 'package:quick_card/screens/login_screen.dart';
import 'package:quick_card/screens/mobile_scanner_screen.dart';
import 'package:quick_card/screens/svg_display_screen.dart';
import 'package:quick_card/entity/card.dart' as c;
import 'package:quick_card/service/folder_service.dart';
import 'package:quick_card/service/session_service.dart';
import 'package:quick_card/service/card_service.dart';
import 'package:quick_card/service/user_service.dart';
import '../components/card_tile.dart';
import 'package:barcode/src/barcode.dart' as bc;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String title = '';
  String message = 'No code scanned yet';
  final SessionService _sessionService = SessionService();
  final UserService _userService = UserService();
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
    User? user = await _userService.getUserById(currentUserId!);
    List allUserFolders = await _folderService.getFoldersByUserId(currentUserId);
    Folder userDefaultFolder = allUserFolders.firstWhere((folder) => folder.name == 'default');
    List allCards = await _cardService.getAllCardsByFolderId(userDefaultFolder.id!);
    setState(() {
      title = '${user!.username}\'s Cards';
      _cards = allCards;
    });
  }

  void _deleteCard(int id) async {
    await _cardService.deleteCardById(id);
    _loadCards(); // Reload the list of cards after deletion
  }

  void _logout() async {
    // Handle logout logic
    await _sessionService.clearSession();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false, // This will remove all routes before the LoginScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Trigger logout on button press
          ),
        ],
      ),
      body: _cards.isEmpty
          ? Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 20.0),
        ),
      )
          : ListView.builder(
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          return CardTile(
            card: card,
            deleteFunction: (context) => _deleteCard(card.id), // Pass the key to delete
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

    if (result != null && result is Map<String, dynamic>) {
      String barcodeData = result['data'];
      bc.Barcode barcodeFormat = result['format'];

      Session? currentSession = await _sessionService.getCurrentSession();
      int? currentUserId = currentSession?.currentUser;
      if (currentUserId != null) {
        List<Folder> userFolders = await _folderService.getFoldersByUserId(currentUserId);
        c.Card newCard = c.Card(
          name: 'Card Name',
          data: barcodeData,
          barcodeFormat: barcodeFormat.toString(),
          svg: barcodeFormat.toSvg(barcodeData, width: 300, height: 100),
          folderId: userFolders[0].id!,
        );
        await _cardService.createCard(newCard);
        _loadCards(); // Reload cards to reflect the new addition
      }
    }
  }
}
