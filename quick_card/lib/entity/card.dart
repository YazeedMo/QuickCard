import 'package:hive/hive.dart';
part 'card.g.dart';

@HiveType(typeId: 1)
class Card {

  @HiveField(0)
  String name;

  @HiveField(1)
  String data;

  @HiveField(2)
  String barcodeFormat;

  @HiveField(3)
  String svg;

  Card({
    required this.name,
    required this.data,
    required this.barcodeFormat,
    required this.svg,
  });

  @override
  String toString() {
    return 'Card(name: $name, data: $data, barcodeFormat: ${barcodeFormat})';
  }
}

// flutter packages pub run build_runner build