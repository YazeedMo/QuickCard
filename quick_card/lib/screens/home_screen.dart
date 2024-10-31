import 'package:flutter/material.dart';
import 'package:quick_card/screens/account_screen.dart';
import 'package:quick_card/screens/cards_screen.dart';
import 'package:quick_card/screens/folder_screen.dart';
import 'package:quick_card/screens/login_screen.dart';
import 'package:quick_card/screens/shopping_list_screen.dart';
import 'package:quick_card/service/session_service.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final SessionService _sessionService = SessionService();

  String title = '';
  String message = 'No code scanned yet';

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const CardsScreen(),
    const FolderScreen(), // Folders screen
    const ShoppingListScreen(), // Shopping List screen
    AccountScreen(), // Account screen
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
