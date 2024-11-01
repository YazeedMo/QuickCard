// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_card/components/add_button.dart';
import 'package:quick_card/components/folder_tile.dart';
import 'package:quick_card/entity/folder.dart';
import 'package:quick_card/screens/folder_cards_screen.dart';
import 'package:quick_card/screens/folder_create_screen.dart';
import 'package:quick_card/service/folder_service.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key});

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  final FolderService _folderService = FolderService();

  String message = 'no folder yet';
  final TextEditingController _folderNameController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String _folderImagePath = '';
  File? _selectedImageFile;

  List<dynamic> _folders = [];

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    _folders = await _folderService.getCurrentUserFolders();
    setState(() {
      _folders;
    });
  }

  Future<void> _addNewFolder() async {
    String folderName = _folderNameController.text.trim();
    if (folderName.isEmpty) {
      folderName = 'card folder';
    }
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FolderCreateScreen(
                  folderName: folderName,
                  folderImagePath: _folderImagePath,
                )));
    if (result == true && mounted) {
      Navigator.pop(context);
      _loadFolders();
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
        _folderImagePath = pickedFile.path;
      });
    }
  }

  void _deleteFolder(int id) async {
    await _folderService.deleteFolder(id);
    _loadFolders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDEDCFB),
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
                  folder: folder,
                    deleteFunction: (context) => _deleteFolder(folder.id!),
                    onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FolderCardsScreen(folder: folder)))
                        });
              },
            ),

    floatingActionButton: AddButton(buttonText: 'add folder',onPressed: () => {showCreateFolderModal(context)},)
    );
  }

  void showCreateFolderModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('create new folder'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Folder Name Input Field
                    TextField(
                      controller: _folderNameController,
                      decoration: InputDecoration(
                        labelText: 'folder name',
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
                      label: Text('add image from gallery'),
                    ),
                    SizedBox(height: 10),
                    // Display the selected image preview (if any)
                    _selectedImageFile != null
                        ? Image.file(
                      _selectedImageFile!,
                      height: 100,
                    )
                        : Text('no image selected',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              actions: [
                // Cancel Button
                TextButton(
                  onPressed: () {
                    _folderNameController.clear();
                    _selectedImageFile = null;
                    Navigator.of(context).pop();
                  },
                  child: Text('cancel'),
                ),
                // Create Button
                ElevatedButton(
                  onPressed: () {
                    _addNewFolder();
                  },
                  child: Text('create'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
