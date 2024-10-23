import 'package:barcode/barcode.dart' as bc;
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeUtils {
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
