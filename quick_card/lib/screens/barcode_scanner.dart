// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MobileScannerScreen extends StatefulWidget {
  @override
  _MobileScannerScreenState createState() => _MobileScannerScreenState();
}

class _MobileScannerScreenState extends State<MobileScannerScreen> {
  String? barcodeValue;
  BarcodeFormat? barcodeFormat;

  bool isScanning = true;

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
                // Toggle flashlight logic (implement torch control if needed)
              });
            },
          ),
        ],
      ),
      body: isScanning
          ? MobileScanner(
              onDetect: (barcodeCapture) {
                setState(() {
                  final barcode = barcodeCapture.barcodes.first;
                  // Store the scanned barcode value
                  barcodeValue = barcode.rawValue;
                  // Get the format of the barcode
                  barcodeFormat = barcode.format;

                  if (barcodeValue != null) {
                    // Stop further scanning and return the value
                    setState(() {
                      isScanning = false;
                    });
                  }
                  // Pop the screen and pass the scanned barcode back to the main screen
                  Navigator.pop(context, {
                      'code': barcodeValue,
                      'type': barcodeFormat,
                  });
                });
              },
            )
          : Center(
              child: Text(
                'Processing...',
                style: TextStyle(fontSize: 18),
              ),
            ),
      bottomSheet: barcodeValue != null
          ? Container(
              color: Colors.white,
              height: 100,
              child: Center(
                child: Text(
                  'Scanned Code: $barcodeValue',
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
