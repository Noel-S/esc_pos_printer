import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:image/image.dart';

abstract class Printer {
  Printer(this._paperSize, this._profile);

  final PaperSize _paperSize;
  final CapabilityProfile _profile;

  PaperSize get paperSize => _paperSize;
  CapabilityProfile get profile => _profile;

  Future<dynamic> connect({
    String host,
    int port = 9100,
    Duration timeout = const Duration(seconds: 5),
    int vendorId,
    int productId,
    String address,
  }) async {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  /// [delayMs]: milliseconds to wait after destroying the socket
  Future<void> disconnect({int delayMs}) async {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  // ************************ Printer Commands ************************
  void reset() {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void text(
    String text, {
    PosStyles styles,
    int linesAfter = 0,
    bool containsChinese = false,
    int maxCharsPerLine,
  }) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void setGlobalCodeTable(String codeTable) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void setGlobalFont(PosFontType font, {int maxCharsPerLine}) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void setStyles(PosStyles styles, {bool isKanji = false}) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void rawBytes(List<int> cmd, {bool isKanji = false}) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void emptyLines(int n) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void feed(int n) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void cut({PosCutMode mode = PosCutMode.full}) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void printCodeTable({String codeTable}) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void beep({int n = 3, PosBeepDuration duration = PosBeepDuration.beep450ms}) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void reverseFeed(int n) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void row(List<PosColumn> cols) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void image(Image imgSrc, {PosAlign align = PosAlign.center}) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void imageRaster(
    Image image, {
    PosAlign align = PosAlign.center,
    bool highDensityHorizontal = true,
    bool highDensityVertical = true,
    PosImageFn imageFn = PosImageFn.bitImageRaster,
  }) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void barcode(
    Barcode barcode, {
    int width,
    int height,
    BarcodeFont font,
    BarcodeText textPos = BarcodeText.below,
    PosAlign align = PosAlign.center,
  }) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void qrcode(
    String text, {
    PosAlign align = PosAlign.center,
    QRSize size = QRSize.Size4,
    QRCorrection cor = QRCorrection.L,
  }) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void drawer({PosDrawer pin = PosDrawer.pin2}) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void hr({String ch = '-', int len, int linesAfter = 0}) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void textEncoded(
    Uint8List textBytes, {
    PosStyles styles = const PosStyles(),
    int linesAfter = 0,
    int maxCharsPerLine,
  }) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  void printGenerator(Generator generator) {
    // TODO: implement dispose
    throw UnimplementedError();
  }
  // ************************ (end) Printer Commands ************************
}
