import 'package:mobile_scanner/mobile_scanner.dart';

class Card {
  String name;
  String data;
  BarcodeFormat barcodeFormat;

  Card({
    required this.name,
    required this.data,
    required this.barcodeFormat,
  });

  @override
  String toString() {
    return 'Card(name: $name, data: $data, barcodeFormat: ${barcodeFormat.name})';
  }
}
