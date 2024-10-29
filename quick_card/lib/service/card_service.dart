import 'package:quick_card/data/card_repository.dart';
import 'package:quick_card/entity/card.dart';


class CardService {

  final CardRepository cardRepository = CardRepository();

  // Create a new Card
  Future<int> createCard(Card card) async {

    return await cardRepository.createCard(card);

  }

  // Get all cards
  Future<List> getAllCards() async {
    return cardRepository.getAllCards();
  }

  // Get all cards by Folder id
  Future<List<Card>> getAllCardsByFolderId(int id) async {
    return await cardRepository.getCardsByFolderId(id);
  }

  // Get card by id
  Future<Card?> getCardById(int id) async {

    Card? card = await cardRepository.getCardById(id);

    if (card != null) {
      return card;
    }

    return null;

  }

  // Delete card by id
  Future<int> deleteCardById(int id) async {
    return await cardRepository.deleteCardById(id);
  }

}
