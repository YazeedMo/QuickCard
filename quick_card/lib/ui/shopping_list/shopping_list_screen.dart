// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quick_card/components/item_tile.dart';
import 'package:quick_card/components/add_button.dart';
import 'package:quick_card/entity/item.dart';
import 'package:quick_card/entity/shopping_list.dart';
import 'package:quick_card/service/item_service.dart';
import 'package:quick_card/service/shopping_list_service.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final ShoppingListService _shoppingListService = ShoppingListService();
  final ItemService _itemService = ItemService();

  List<Item> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });
    _items = await _itemService.getAllCurrentUserItems();
    setState(() {
      _isLoading = false;
    });
  }

  void toggleItemChecked(Item item, bool? value) async {
    item.checkedOff = value!;
    await _itemService.updateItem(item);
    setState(() {

    });
  }


  void deleteItem(int id) {
    _itemService.deleteItemById(id);
    setState(() {
      _loadItems();
    });
  }

  void _addItem(String itemName) async {
    ShoppingList userDefaultList =
        await _shoppingListService.getCurrentUserDefaultShoppingList();
    Item item = Item(name: itemName, shoppingListId: userDefaultList.id!);
    await _itemService.createItem(item);
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDEDCFB),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _items.isEmpty
              ? Center(
                  child: Text(
                    'no items',
                    style: TextStyle(fontSize: 20.0),
                  ),
                )
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return ItemTile(
                      item: item,
                      onChecked: (value) => toggleItemChecked(item, value),
                      onDelete: () => deleteItem(item.id!),
                    );
                  },
                ),
      floatingActionButton: AddButton(buttonText: 'add item',onPressed: _showAddItemDialog)
    );
  }

  Future<void> _showAddItemDialog() async {
    String newItemName = "";
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(" add new item"),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: "enter item name",
            ),
            onChanged: (value) {
              newItemName = value;
            },
          ),
          actions: [
            TextButton(
              child: Text("cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("add"),
              onPressed: () {
                if (newItemName.isNotEmpty) {
                  _addItem(newItemName);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
