import 'package:hive_flutter/hive_flutter.dart';
import 'package:quick_card/entity/card.dart';
import 'package:quick_card/entity/user.dart';

class HiveConfig {

  final String _userBoxName = 'userBox';
  final String _cardBoxName = 'cardBox';

  Future<void> startHive() async {

    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(CardAdapter());
    await Hive.openBox<User>(_userBoxName);
    await Hive.openBox<Card>(_cardBoxName);

  }

}