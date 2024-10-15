// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors

import 'package:barcode/barcode.dart' as bc;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeWidget extends StatelessWidget {
  final String data;
  final BarcodeFormat barcodeFormat;

  BarcodeWidget({required this.data, required this.barcodeFormat});

  @override
  Widget build(BuildContext context) {
    final svg = getBarcodeType(barcodeFormat).toSvg(data, width: 200, height: 100);
    return Container(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Center(
          child: SvgPicture.string(svg),
        ),
      ),
    );
  }

  // Function to map BarcodeFormat to BarcodeType
  bc.Barcode getBarcodeType(BarcodeFormat? format) {
    switch (format) {
      case BarcodeFormat.code128:
        return bc.Barcode.code128();
      case BarcodeFormat.code39:
        return bc.Barcode.code39();
      case BarcodeFormat.qrCode:
        return bc.Barcode.qrCode();
      case BarcodeFormat.ean8:
        return bc.Barcode.ean8();
      case BarcodeFormat.ean13:
        return bc.Barcode.ean13();
      default:
        return bc.Barcode.code128();
    }
  }

}
