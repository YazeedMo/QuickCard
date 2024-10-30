// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_card/components/folder_tile.dart';
import 'package:quick_card/entity/folder.dart';
import 'package:quick_card/entity/session.dart';
import 'package:quick_card/screens/folder_cards_screen.dart';
import 'package:quick_card/screens/folder_create_screen.dart';
import 'package:quick_card/service/card_service.dart';
import 'package:quick_card/service/folder_service.dart';
import 'package:quick_card/service/session_service.dart';
import 'package:quick_card/entity/card.dart' as c;

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key});

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  String message = 'No folder yet';
  final SessionService _sessionService = SessionService();
  final FolderService _folderService = FolderService();
  final CardService _cardService = CardService();
  final TextEditingController _folderNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  List<dynamic> _folders = [];

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    Session? currentSession = await _sessionService.getCurrentSession();
    int? currentUserId = currentSession!.currentUser;
    _folders = await _folderService.getFoldersByUserId(currentUserId!);

    setState(() {
      _folders;
    });
  }

  void _deleteFolder(int id) async {
    Session? currentSession = await _sessionService.getCurrentSession();
    int currentUserId = currentSession!.currentUser!;
    Folder? defaultFolder;
    List<Folder> allUserFolders = await _folderService.getFoldersByUserId(currentUserId);
    for (Folder folder in allUserFolders) {
      if (folder.name == 'default') {
        defaultFolder = folder;
        break;
      }
    }
    List<c.Card> allFolderCards = await _cardService.getAllCardsByFolderId(id);
    for (c.Card card in allFolderCards) {
      card.folderId = defaultFolder!.id!;
      await _cardService.updateCard(card);
    }
    await _folderService.deleteFolder(id);
    _loadFolders();
  }

  Future<void> _addNewFolder() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FolderCreateScreen(
                  folderName: _folderNameController.text,
                  folderImagePath: _selectedImage?.path,
                )));
    if (result == true) {
      Navigator.pop(context);
      _loadFolders();
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _folders.isEmpty
          ? Center(
              child: Text(
                message,
                style: TextStyle(fontSize: 20.0),
              ),
            )
          : ListView.builder(
              itemCount: _folders.length,
              itemBuilder: (context, index) {
                Folder folder = _folders[index];
                return FolderTile(
                    folderName: _folders[index].name,
                    deleteFunction: (context) => _deleteFolder(folder.id!),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FolderCardsScreen(folder: folder))
                      )
                    });
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {showCreateFolderModal(context)},
        backgroundColor: Color(0xff8EE4DF),
        child: Icon(Icons.add),
      ),
    );
  }

  void showCreateFolderModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Create New Folder'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Folder Name Input Field
                  TextField(
                    controller: _folderNameController,
                    decoration: InputDecoration(
                      labelText: 'Folder Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Image Picker Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _pickImage();
                      // Update dialog state after picking an image
                      setState(() {});
                    },
                    icon: Icon(Icons.image),
                    label: Text('Add Image from Gallery'),
                  ),
                  SizedBox(height: 10),
                  // Display the selected image preview (if any)
                  _selectedImage != null
                      ? Image.file(
                    _selectedImage!,
                    height: 100,
                  )
                      : Text('No image selected',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
              actions: [
                // Cancel Button
                TextButton(
                  onPressed: () {
                    _folderNameController.clear();
                    _selectedImage = null;
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                // Create Button
                ElevatedButton(
                  onPressed: () {
                    _addNewFolder();
                  },
                  child: Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

}

