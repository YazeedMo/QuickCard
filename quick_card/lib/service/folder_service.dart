
import 'package:quick_card/data/folder_repository.dart';
import 'package:quick_card/entity/folder.dart';

class FolderService {

  final FolderRepository _folderRepository = FolderRepository();

  // Create a new folder
  Future<int> createFolder(Folder folder) async {
    return await _folderRepository.createFolder(folder);
  }

  // Get all folders by user id
  Future<List<Folder>> getFoldersByUserId(int userId) async {
    return await _folderRepository.getFoldersByUserId(userId);
  }

  // Update a folder
  Future<int> updateFolder(Folder folder) async {
    return await _folderRepository.updateFolder(folder);
  }

  // Delete folder by id
  Future<int> deleteFolder(int id) async {
    return await _folderRepository.deleteFolder(id);
  }

}