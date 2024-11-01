// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:barcode/barcode.dart' as bc;
import 'package:quick_card/screens/card_create_screen.dart';
import 'package:quick_card/screens/manual_card_screen.dart';
import 'package:quick_card/util/barcode_utils.dart';

class CardScannerScreen extends StatefulWidget {
  @override
  State<CardScannerScreen> createState() => _CardScannerScreenState();
}

class _CardScannerScreenState extends State<CardScannerScreen> {
  final BarcodeUtils _barcodeUtils = BarcodeUtils();

  String? barcodeData;
  BarcodeFormat? barcodeFormat;
  bc.Barcode? barcodeType;
  bool isScanning = true;
  MobileScannerController? mobileScannerController;

  @override
  void initState() {
    super.initState();
    mobileScannerController = MobileScannerController();
    isScanning = true;
  }

  @override
  void dispose() {
    mobileScannerController?.dispose();
    super.dispose();
  }

  Future<void> _addNewCard() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CardCreateScreen(
                barcodeData: barcodeData!,
                barcodeFormat: barcodeFormat!,
                barcodeType: barcodeType!)));
    if (result == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _addNewManualCard() async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ManualCardScreen()));

    if (result == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('mobile scanner',
        style: TextStyle(
          fontWeight: FontWeight.bold), // Make the title bold
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.flash_on),
            onPressed: () {
              setState(() {
                mobileScannerController?.toggleTorch();
              });
            },
          ),
        ],
      ),
      body: isScanning
          ? MobileScanner(
              controller: mobileScannerController,
              onDetect: (barcodeCapture) {
                setState(() {
                  final barcode = barcodeCapture.barcodes.first;
                  barcodeData = barcode.rawValue;
                  barcodeFormat = barcode.format;

                  if (barcodeData != null) {
                    isScanning = false;
                    mobileScannerController?.dispose();
                    barcodeType = _barcodeUtils.getBarcodeType(barcodeFormat);
                  }
                });
                _addNewCard();
              },
            )
          : Center(
              child: Text(
                'processing...',
                style: TextStyle(fontSize: 18),
              ),
            ),
      bottomSheet: Container(
        color: Colors.white,
        height: 100,
        child: Center(
          child: barcodeData != null
              ? Text(
                  'scanned code: $barcodeData',
                  style: TextStyle(fontSize: 18),
                )
              : TextButton(
                  onPressed: () {
                    _addNewManualCard();
                  },


                  child: Text(
                    'or enter barcode manually',
                    style: TextStyle(fontSize: 22, color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                ),
        ),
      ),
    );
  }
}
