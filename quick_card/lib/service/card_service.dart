import '../data/card_db.dart';
import '../entity/card.dart';

class CardService {
  final CardDB _cardDB = CardDB();

  Future<void> init() async {
    await _cardDB.openBox();
  }

  Future<int> saveCard(Card card) async {
    return await _cardDB.saveCard(card);
  }

  Card? getCard(int key) {
    return _cardDB.getCard(key);
  }

  List<Card> getAllCards() {
    // Business
    return _cardDB.getAllCards();
  }

  Future<void> deleteCardByIndex(int index) async {
    await _cardDB.deleteCardByIndex(index);
  }

  Future<void> close() async {
    await _cardDB.closeBox();
  }
}
