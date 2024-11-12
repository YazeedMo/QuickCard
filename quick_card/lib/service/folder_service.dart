import 'package:quick_card/repository/folder_repository.dart';
import 'package:quick_card/entity/folder.dart';
import 'package:quick_card/service/session_service.dart';

class FolderService {
  final FolderRepository _folderRepository = FolderRepository();

  // Create a new folder
  Future<int> createFolder(Folder folder) async {
    return await _folderRepository.createFolder(folder);
  }

  // Get all Folders by user id
  Future<List<Folder>> getFoldersByUserId(int userId) async {
    return await _folderRepository.getFoldersByUserId(userId);
  }

  // Get all current User's folders
  Future<List<Folder>> getCurrentUserFolders() async {
    int currentUserId = await SessionService().getCurrentUserId();
    return await FolderService().getFoldersByUserId(currentUserId);
  }

  // Get Folder by id
  Future<Folder?> getFolderById(int id) async {
    return await _folderRepository.getFolderById(id);
  }

  // Add Card to Folder
  Future<void> addCardToFolder(int folderId, int cardId) async {
    await _folderRepository.addCardToFolder(folderId, cardId);
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
