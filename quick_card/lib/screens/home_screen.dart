// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quick_card/entity/folder.dart';
import 'package:quick_card/entity/session.dart';
import 'package:quick_card/entity/user.dart';
import 'package:quick_card/screens/cards_screen.dart';
import 'package:quick_card/screens/login_screen.dart';
import 'package:quick_card/service/folder_service.dart';
import 'package:quick_card/service/session_service.dart';
import 'package:quick_card/service/card_service.dart';
import 'package:quick_card/service/user_service.dart';

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
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    CardsScreen(),
    BlankScreen(), // Folders screen
    BlankScreen(), // Shopping List screen
    BlankScreen(), // Account screen
  ];

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        title = "All Cards";
        break;
      case 1:
        title = "Folders";
        break;
      case 2:
        title = "Shopping List";
        break;
      case 3:
        title = "Account";
        break;
    }
    setState(() {
      title;
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    Session? currentSession = await _sessionService.getCurrentSession();
    int? currentUserId = currentSession!.currentUser;
    User? user = await _userService.getUserById(currentUserId!);
    List allUserFolders =
        await _folderService.getFoldersByUserId(currentUserId);
    Folder userDefaultFolder =
        allUserFolders.firstWhere((folder) => folder.name == 'default');
    List allCards =
        await _cardService.getAllCardsByFolderId(userDefaultFolder.id!);
    setState(() {
      title = '${user!.username}\'s Cards';
      _cards = allCards;
    });
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
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Cards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Folders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Shopping List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
      // body: _cards.isEmpty
      //     ? Center(
      //         child: Text(
      //           message,
      //           style: TextStyle(fontSize: 20.0),
      //         ),
      //       )
      //     : ListView.builder(
      //         itemCount: _cards.length,
      //         itemBuilder: (context, index) {
      //           final card = _cards[index];
      //           return CardTile(
      //             card: card,
      //             deleteFunction: (context) =>
      //                 _deleteCard(card.id), // Pass the key to delete
      //             onTap: () {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => SvgDisplayScreen(svg: card.svg),
      //                 ),
      //               );
      //             },
      //           );
      //         },
      //       ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _addNewCard,
      //   backgroundColor: Color(0xff8EE4DF),
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

// Blank screen widget for other tabs
class BlankScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Blank Screen',
          style: TextStyle(fontSize: 24, color: Colors.grey),
        ),
      ),
    );
  }
}
