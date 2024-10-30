import 'package:flutter/material.dart';
import 'package:quick_card/entity/folder.dart';
import 'package:quick_card/entity/session.dart';
import 'package:quick_card/entity/user.dart';
import 'package:quick_card/screens/folder_create_screen.dart';
import 'package:quick_card/screens/cards_screen.dart';
import 'package:quick_card/screens/folder_screen.dart';
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
    FolderScreen(), // Folders screen
    FolderScreen(), // Shopping List screen
    BlankScreen(), // Account screen
  ];

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        title = "your";
        break;
      case 1:
        title = "your favourite";
        break;
      case 2:
        title = "shopping list";
        break;
      case 3:
        title = "account";
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
      /*appBar: AppBar(
        title: Text(title, textAlign: TextAlign.center),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Trigger logout on button press
          ),
        ],
      ),*/
      backgroundColor: const Color(0xFFDEDCFB),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 1), // Spacing between titles
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'quick',
                  style: TextStyle(
                    fontSize: 52.0,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: 'cards',
                  style: TextStyle(
                    fontSize: 52.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF382EF2),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/selectedwallet.png"),
            ),
            label: 'cards',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/selected-folder.png"),
            ),
            label: 'folders',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/selected-list.png"),
            ),
            label: 'shopping list',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/user-selected.png"),
            ),
            label: 'account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff000000),
        unselectedItemColor: Colors.black54,
        backgroundColor: Color(0xFFDEDCFB),

        onTap: _onItemTapped,
      ),
    );
  }
}

// Blank screen widget for other tabs
class BlankScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDEDCFB),
      body: Center(
        child: Text(
          'Blank Screen',
          style: TextStyle(fontSize: 24, color: Colors.grey),
        ),
      ),
    );
  }
}
