// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:barcode/barcode.dart' as bc;
import 'package:quick_card/screens/card_detail_screen.dart';
import 'package:quick_card/util/barcode_utils.dart';

class MobileScannerScreen extends StatefulWidget {
  @override
  _MobileScannerScreenState createState() => _MobileScannerScreenState();
}

class _MobileScannerScreenState extends State<MobileScannerScreen> {

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
      MaterialPageRoute(builder: (context) => CardDetailScreen(
          barcodeData: barcodeData!,
          barcodeFormat: barcodeFormat!,
          barcodeType: barcodeType!))
    );
    if (result == true) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Scanner'),
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
                    // Stop further scanning and return the value
                    isScanning = false;
                    mobileScannerController?.dispose();
                    barcodeType = _barcodeUtils.getBarcodeType(barcodeFormat);
                    // Pop the screen and pass the scanned barcode back to the main screen
                  }
                });
                _addNewCard();
              },
            )
          : Center(
              child: Text(
                'Processing...',
                style: TextStyle(fontSize: 18),
              ),
            ),
      bottomSheet: barcodeData != null
          ? Container(
              color: Colors.white,
              height: 100,
              child: Center(
                child: Text(
                  'Scanned Code: $barcodeData',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          : Container(
              height: 100,
              color: Colors.white,
              child: Center(
                child: Text(
                  'Scan a code',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
    );
  }
}
