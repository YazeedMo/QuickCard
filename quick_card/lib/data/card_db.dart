import 'package:hive/hive.dart';

class CardDatabase {
  List cardList = [];

  final cardBox = Hive.box("cardBox");

  // Load data from database
  void loadData() {
    cardList = cardBox.get("CARDLIST");
  }

  void updateDatabase() {
    cardBox.put("CARDLIST", cardList);
  }
}
