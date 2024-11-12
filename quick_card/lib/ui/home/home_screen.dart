import 'package:flutter/material.dart';
import 'package:quick_card/ui/account/account_screen.dart';
import 'package:quick_card/ui/cards/cards_screen.dart';
import 'package:quick_card/ui/folders/folder_screen.dart';
import 'package:quick_card/ui/shopping_list/shopping_list_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String title = 'your';
  String message = 'No code scanned yet';

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const CardsScreen(),
    const FolderScreen(),
    const ShoppingListScreen(),
    const AccountScreen(),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDEDCFB),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 1), // Spacing between titles
          RichText(
            text: const TextSpan(
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
        selectedItemColor: const Color(0xff000000),
        unselectedItemColor: Colors.black54,
        backgroundColor: const Color(0xFFDEDCFB),

        onTap: _onItemTapped,
      ),
    );
  }
}


