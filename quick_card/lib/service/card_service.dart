import 'package:quick_card/data/card_repository.dart';
import 'package:quick_card/entity/card.dart';
import 'package:quick_card/entity/folder.dart';
import 'package:quick_card/entity/session.dart';
import 'package:quick_card/service/folder_service.dart';
import 'package:quick_card/service/session_service.dart';

class CardService {
  final CardRepository _cardRepository = CardRepository();

  // Create a new Card
  Future<int> createCard(Card card) async {
    return await _cardRepository.createCard(card);
  }

  // Get all cards
  Future<List> getAllCards() async {
    return _cardRepository.getAllCards();
  }

  // Get all Current User cards
  Future<List<Card>> getAllCurrentUserCards() async {
    Session? session = await SessionService().getCurrentSession();
    int? userId = session!.currentUser;
    List<Folder> allUserFolders =
        await FolderService().getFoldersByUserId(userId!);
    List<Card> allUserCards = [];
    for (Folder folder in allUserFolders) {
      List<Card> allFolderCards =
          await getAllCardsByFolderId(folder.id!);
      allUserCards.addAll(allFolderCards);
    }
    return allUserCards;
  }

  // Get all cards by Folder id
  Future<List<Card>> getAllCardsByFolderId(int id) async {
    return await _cardRepository.getCardsByFolderId(id);
  }

  // Get card by id
  Future<Card?> getCardById(int id) async {
    Card? card = await _cardRepository.getCardById(id);

    if (card != null) {
      return card;
    }

    return null;
  }

  // Update Card
  Future<Card?> updateCard(Card card) async {
    int updatedCardId = await _cardRepository.updateCard(card);
    return getCardById(updatedCardId);
  }

  // Delete card by id
  Future<int> deleteCardById(int id) async {
    return await _cardRepository.deleteCardById(id);
  }
}
