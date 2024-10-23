import 'package:hive/hive.dart';

import '../entity/card.dart';

class CardDB {
  static const String _boxName = 'cardBox';

  // Open the Hive box
  Future<void> openBox() async {
    await Hive.openBox<Card>(_boxName);
  }

  // Create a card
  Future<int> saveCard(Card card) async {
    try {
      final box = Hive.box<Card>(_boxName);
      final key = await box.add(card);
      return key;
    }
    catch (e) {
      print('error: $e');
    }

    return -3;

  }

  // Get a card by key
  Card? getCard(int key) {
    final box = Hive.box<Card>(_boxName);
    return box.get(key);
  }

  // Get all cards
  List<Card> getAllCards() {
    final box = Hive.box<Card>(_boxName);
    return box.values.toList();
  }

  // Delete a card by index
  Future<void> deleteCardByIndex(int index) async {
    final box = Hive.box<Card>(_boxName);
    await box.deleteAt(index);
  }

  // Close the box when done
  Future<void> closeBox() async {
    final box = Hive.box<Card>(_boxName);
    await box.close();
  }
}
