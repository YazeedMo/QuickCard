import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:barcode/barcode.dart' as bc;
import 'package:quick_card/ui/cards/card_creation_screen.dart';
import 'package:quick_card/ui/cards/card_manual_entry_screen.dart';
import 'package:quick_card/util/barcode_utils.dart';

class CardScannerController {

  final BarcodeUtils barcodeUtils = BarcodeUtils();

  String? barcodeData;
  BarcodeFormat? barcodeFormat;
  bc.Barcode? barcodeType;
  bool isScanning = true;
  MobileScannerController? mobileScannerController;

  Future<void> addNewCard(BuildContext buildContext) async {
    print("ccccccccccccccccccccccccccccccccccccccccccccccccc");
    final result = await Navigator.push(
        buildContext,
        MaterialPageRoute(
            builder: (context) => CardCreationScreen(
                barcodeData: barcodeData!,
                barcodeFormat: barcodeFormat!,
                barcodeType: barcodeType!)));
    if (result == true && buildContext.mounted) {
      Navigator.pop(buildContext, true);
    }
  }

  Future<void> addNewManualCard(BuildContext buildContext) async {
    final result = await Navigator.push(
        buildContext, MaterialPageRoute(builder: (context) => ManualCardScreen()));

    if (result == true && buildContext.mounted) {
      Navigator.pop(buildContext, true);
    }
  }


}