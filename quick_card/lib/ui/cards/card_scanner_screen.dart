// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:quick_card/ui/cards/card_scanner_controller.dart';

class CardScannerScreen extends StatefulWidget {
  @override
  State<CardScannerScreen> createState() => _CardScannerScreenState();
}

class _CardScannerScreenState extends State<CardScannerScreen> {

  final CardScannerController _controller = CardScannerController();

  @override
  void initState() {
    super.initState();
    _controller.mobileScannerController = MobileScannerController();
    _controller.isScanning = true;
  }

  @override
  void dispose() {
    _controller.mobileScannerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Mobile scanner',
        style: TextStyle(
          fontWeight: FontWeight.bold), // Make the title bold
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.flash_on),
            onPressed: () {
              setState(() {
                _controller.mobileScannerController?.toggleTorch();
              });
            },
          ),
        ],
      ),
      body: _controller.isScanning
          ? MobileScanner(
              controller: _controller.mobileScannerController,
              onDetect: (barcodeCapture) {
                setState(() {
                  final barcode = barcodeCapture.barcodes.first;
                  _controller.barcodeData = barcode.rawValue;
                  _controller.barcodeFormat = barcode.format;

                  if (_controller.barcodeData != null) {
                    _controller.isScanning = false;
                    _controller.mobileScannerController?.dispose();
                    _controller.barcodeType = _controller.barcodeUtils.getBarcodeType(_controller.barcodeFormat);
                  }
                });
                _controller.addNewCard(context);
              },
            )
          : Center(
              child: Text(
                'Processing...',
                style: TextStyle(fontSize: 18),
              ),
            ),
      bottomSheet: Container(
        color: Colors.white,
        height: 100,
        child: Center(
          child: _controller.barcodeData != null
              ? Text(
                  'scanned code: $_controller.barcodeData',
                  style: TextStyle(fontSize: 18),
                )
              : TextButton(
                  onPressed: () {
                    _controller.addNewManualCard(context);
                  },


                  child: Text(
                    'Or enter barcode manually',
                    style: TextStyle(fontSize: 22, color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                ),
        ),
      ),
    );
  }
}
