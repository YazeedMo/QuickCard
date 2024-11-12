import 'package:quick_card/repository/card_repository.dart';
import 'package:quick_card/entity/card.dart';
import 'package:quick_card/service/session_service.dart';

class CardService {
  final CardRepository _cardRepository = CardRepository();

  // Create a new Card
  Future<int> createCard(Card card) async {
    return await _cardRepository.createCard(card);
  }

  // Get all Current User Cards
  Future<List<Card>> getAllCurrentUserCards() async {
    int currentUserId = await SessionService().getCurrentUserId();
    return await _cardRepository.getCardsByUserId(currentUserId);
  }

  // Get all Cards by Folder id
  Future<List<Card>> getAllCardsByFolderId(int id) async {
    return await _cardRepository.getCardsByFolderId(id);
  }

  // Get Card by id
  Future<Card?> getCardById(int id) async {
    Card? card = await _cardRepository.getCardById(id);
    if (card != null) {
      return card;
    }
    return null;
  }

  // Add Card to Folder
  Future<void> addCardToFolder(int folderId, int cardId) async {
    await _cardRepository.addCardToFolder(cardId, folderId);
  }

  // Update Card
  Future<Card?> updateCard(Card card) async {
    int updatedCardId = await _cardRepository.updateCard(card);
    return getCardById(updatedCardId);
  }

  // Delete Card by id
  Future<int> deleteCardById(int id) async {
    return await _cardRepository.deleteCardById(id);
  }
}
