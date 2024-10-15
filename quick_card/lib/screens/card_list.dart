// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:barcode/barcode.dart' as bc;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:quick_card/components/barcode_widget.dart';
import 'dart:typed_data';
import 'package:quick_card/screens/barcode_scanner.dart';


class CardList extends StatefulWidget {
  const CardList({super.key});

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  String? scannedCode;
  BarcodeFormat? scannedCodeFormat;
  String? scannedCodeFormatString;
  Uint8List? barcodeImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cards'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display barcode if scanned
            scannedCode != null
                ? Column(
                    children: [
                      Text(
                        'barcode format: $scannedCodeFormatString',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        'Code: $scannedCode',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20,),
                      BarcodeWidget(data: scannedCode!, barcodeFormat: scannedCodeFormat!)
                    ],
                  )
                : Text(
                    'No code scanned yet',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                // Navigate to the barcode scanner screen
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MobileScannerScreen()),
                );

                // Once returned, set the scanned code value
                if (result != null) {
                  setState(() {
                    scannedCode = result['code'];
                    scannedCodeFormat = result['type'];
                    if (scannedCodeFormat != null) {
                      scannedCodeFormatString = scannedCodeFormat.toString().split('.').last;
                    }
                  });
                }
              },
              child: Text('Scan a Barcode'),
            ),
          ],
        ),
      ),
    );
  }
}
