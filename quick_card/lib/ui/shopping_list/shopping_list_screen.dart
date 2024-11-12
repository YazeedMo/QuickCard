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
    setState(() {});
  }

  Future<void> deleteItem(int id) async {
    bool confirmDelete = await _showConfirmDeleteDialog();
    if (confirmDelete) {
      await _itemService.deleteItemById(id);
      _loadItems();
    }
  }

  Future<bool> _showConfirmDeleteDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ??
        false; // Return false if the dialog is dismissed
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
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : _items.isEmpty
                ? Center(
              child: Text(
                'No items',
                style: TextStyle(fontSize: 20.0),
              ),
            )
                : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  title: Text(
                    item.name,
                    style: TextStyle(
                      decoration: item.checkedOff
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  leading: Checkbox(
                    value: item.checkedOff,
                    onChanged: (value) {
                      toggleItemChecked(item, value);
                    },
                  ),
                  trailing: Visibility(
                    visible: item.checkedOff,
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteItem(item.id!),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFDEDCFB),
            ),
            padding: EdgeInsets.only(left: 190, bottom: 16, right: 16),
            child: AddButton(
              buttonText: 'Add item',
              onPressed: _showAddItemDialog,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddItemDialog() async {
    String newItemName = "";
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add new item"),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Enter item name",
            ),
            onChanged: (value) {
              newItemName = value;
            },
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Add"),
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
