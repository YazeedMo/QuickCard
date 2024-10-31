import 'package:quick_card/data/folder_repository.dart';
import 'package:quick_card/entity/card.dart';
import 'package:quick_card/entity/folder.dart';
import 'package:quick_card/entity/session.dart';
import 'package:quick_card/service/card_service.dart';
import 'package:quick_card/service/session_service.dart';
import 'package:quick_card/service/user_service.dart';

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

  // Get all current User's folders
  Future<List<Folder>> getCurrentUserFolders() async {
    Session? session = await SessionService().getCurrentSession();
    int? currentUser = session!.currentUser;
    return await FolderService().getFoldersByUserId(currentUser!);
  }

  // Get current User's default folder
  Future<Folder> getCurrentUserDefaultFolder() async {

    Session? session = await SessionService().getCurrentSession();
    List allUserFolders = await getFoldersByUserId(session!.currentUser!);
    Folder defaultFolder = await allUserFolders.firstWhere((folder) => folder.name == 'default');
    return defaultFolder;

  }

  // Get Folder by id
  Future<Folder?> getFolderById(int id) async {
    return await _folderRepository.getFolderById(id);
  }

  // Update a folder
  Future<int> updateFolder(Folder folder) async {
    return await _folderRepository.updateFolder(folder);
  }

  // Delete folder by id
  Future<int> deleteFolder(int id) async {

    Folder defaultFolder = await getCurrentUserDefaultFolder();
    List<Card> allFolderCards = await CardService().getAllCardsByFolderId(id);

    for (Card card in allFolderCards) {
      card.folderId = defaultFolder.id!;
      await CardService().updateCard(card);
    }

    return await _folderRepository.deleteFolder(id);
  }
}
