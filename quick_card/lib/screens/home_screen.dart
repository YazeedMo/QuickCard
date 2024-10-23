// ignore_for_file: prefer_const_constructors
//test message
import 'package:barcode/src/barcode.dart' as bc;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:quick_card/components/card_tile.dart';
import 'package:quick_card/data/card_db.dart';
import 'package:quick_card/screens/code_display_screen.dart';
import 'dart:typed_data';
import 'package:quick_card/screens/mobile_scanner_screen.dart';
import 'package:quick_card/util/barcode_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? scannedCode;
  BarcodeFormat? scannedCodeFormat;
  bc.Barcode? barcodeType;
  String? scannedCodeFormatString;
  String? svg;
  CardDatabase db = CardDatabase();

  void openCardBox() async {
    var cardBox = Hive.box("cardBox");

    if (cardBox.get("CARDLIST") != null) {
      db.loadData();
    }
  }

  @override
  void initState() {
    openCardBox();
    super.initState();
  }

  void openScanner() async {
    // Navigate to the barcode scanner screen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MobileScannerScreen()),
    );

    // Once returned, set the scanned code value
    if (result != null) {
      setState(() {
        scannedCode = result['code'];
        scannedCodeFormat = result['type'];
        if (scannedCodeFormat != null) {
          scannedCodeFormatString =
              scannedCodeFormat.toString().split('.').last;
        }
        barcodeType = BarcodeUtils().getBarcodeType(scannedCodeFormat);
        svg = barcodeType!.toSvg(scannedCode!, width: 300, height: 100);
        db.cardList.add(svg);
        db.updateDatabase();
      });
    }
  }

  void deleteCard(int index) {
    setState(() {
      db.cardList.removeAt(index);
      db.updateDatabase();
    });
  }

  void displayCode(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SvgDisplayScreen(svg: db.cardList[index])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("All Cards"),
          ),
          backgroundColor: Colors.grey[500],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: openScanner,
          child: Icon(Icons.add),
        ),
        body: db.cardList.length == 0
            ? Center(
                child: Text(
                  "No code scanned yet",
                  style: TextStyle(fontSize: 20.0),
                ),
              )
            : ListView.builder(
                itemCount: db.cardList.length,
                itemBuilder: (context, index) {
                  return CardTile(
                    svg: db.cardList[index]!,
                    cardTitle: 'title placeholder',
                    deleteFunction: (context) => deleteCard(index),
                    onTap: () => displayCode(index),
                  );
                }));
  }
}
