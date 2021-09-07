/*
 * esc_pos_printer
 * Created by Andrey Ushakov
 * 
 * Copyright (c) 2019-2020. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

// import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:image/image.dart';
import './enums.dart';

/// USB Printer
class USBPrinter {
  USBPrinter(this._paperSize, this._profile, {int spaceBetweenRows = 5}) {
    _generator =
        Generator(paperSize, profile, spaceBetweenRows: spaceBetweenRows);
  }

  final PaperSize _paperSize;
  final CapabilityProfile _profile;
  Generator _generator;
  // Socket _socket;
  final FlutterUsbPrinter _usbWrite = FlutterUsbPrinter();
  PaperSize get paperSize => _paperSize;
  CapabilityProfile get profile => _profile;

  Future<String> connect({int vendorId, int productId}) async {
    try {
      _usbWrite.connect(vendorId, productId);
      _usbWrite.write(Uint8List.fromList(_generator.reset()));
      return 'success';// Future<PosPrintResult>.value(PosPrintResult.success);
    } catch (e) {
      return '$e';
    }
  }

  /// [delayMs]: milliseconds to wait after destroying the socket
  void disconnect({int delayMs}) async {
    _usbWrite.close();
    if (delayMs != null) {
      await Future.delayed(Duration(milliseconds: delayMs), () => null);
    }
  }

  // ************************ Printer Commands ************************
  void reset() {
    _usbWrite.write(Uint8List.fromList(_generator.reset()));
  }

  void text(
    String text, {
    PosStyles styles = const PosStyles(),
    int linesAfter = 0,
    bool containsChinese = false,
    int maxCharsPerLine,
  }) {
    _usbWrite.write(Uint8List.fromList(_generator.text(text,
        styles: styles,
        linesAfter: linesAfter,
        containsChinese: containsChinese,
        maxCharsPerLine: maxCharsPerLine)));
  }

  void setGlobalCodeTable(String codeTable) {
    _usbWrite.write(Uint8List.fromList(_generator.setGlobalCodeTable(codeTable)));
  }

  void setGlobalFont(PosFontType font, {int maxCharsPerLine}) {
    _usbWrite
        .write(Uint8List.fromList(_generator.setGlobalFont(font, maxCharsPerLine: maxCharsPerLine)));
  }

  void setStyles(PosStyles styles, {bool isKanji = false}) {
    _usbWrite.write(Uint8List.fromList(_generator.setStyles(styles, isKanji: isKanji)));
  }

  void rawBytes(List<int> cmd, {bool isKanji = false}) {
    _usbWrite.write(Uint8List.fromList(_generator.rawBytes(cmd, isKanji: isKanji)));
  }

  void emptyLines(int n) {
    _usbWrite.write(Uint8List.fromList(_generator.emptyLines(n)));
  }

  void feed(int n) {
    _usbWrite.write(Uint8List.fromList(_generator.feed(n)));
  }

  void cut({PosCutMode mode = PosCutMode.full}) {
    _usbWrite.write(Uint8List.fromList(_generator.cut(mode: mode)));
  }

  void printCodeTable({String codeTable}) {
    _usbWrite.write(Uint8List.fromList(_generator.printCodeTable(codeTable: codeTable)));
  }

  void beep({int n = 3, PosBeepDuration duration = PosBeepDuration.beep450ms}) {
    _usbWrite.write(Uint8List.fromList(_generator.beep(n: n, duration: duration)));
  }

  void reverseFeed(int n) {
    _usbWrite.write(Uint8List.fromList(_generator.reverseFeed(n)));
  }

  void row(List<PosColumn> cols) {
    _usbWrite.write(Uint8List.fromList(_generator.row(cols)));
  }

  void image(Image imgSrc, {PosAlign align = PosAlign.center}) {
    _usbWrite.write(Uint8List.fromList(_generator.image(imgSrc, align: align)));
  }

  void imageRaster(
    Image image, {
    PosAlign align = PosAlign.center,
    bool highDensityHorizontal = true,
    bool highDensityVertical = true,
    PosImageFn imageFn = PosImageFn.bitImageRaster,
  }) {
    _usbWrite.write(Uint8List.fromList(_generator.imageRaster(
      image,
      align: align,
      highDensityHorizontal: highDensityHorizontal,
      highDensityVertical: highDensityVertical,
      imageFn: imageFn,
    )));
  }

  void barcode(
    Barcode barcode, {
    int width,
    int height,
    BarcodeFont font,
    BarcodeText textPos = BarcodeText.below,
    PosAlign align = PosAlign.center,
  }) {
    _usbWrite.write(Uint8List.fromList(_generator.barcode(
      barcode,
      width: width,
      height: height,
      font: font,
      textPos: textPos,
      align: align,
    )));
  }

  void qrcode(
    String text, {
    PosAlign align = PosAlign.center,
    QRSize size = QRSize.Size4,
    QRCorrection cor = QRCorrection.L,
  }) {
    _usbWrite.write(Uint8List.fromList(_generator.qrcode(text, align: align, size: size, cor: cor)));
  }

  void drawer({PosDrawer pin = PosDrawer.pin2}) {
    _usbWrite.write(Uint8List.fromList(_generator.drawer(pin: pin)));
  }

  void hr({String ch = '-', int len, int linesAfter = 0}) {
    _usbWrite.write(Uint8List.fromList(_generator.hr(ch: ch, linesAfter: linesAfter)));
  }

  void textEncoded(
    Uint8List textBytes, {
    PosStyles styles = const PosStyles(),
    int linesAfter = 0,
    int maxCharsPerLine,
  }) {
    _usbWrite.write(Uint8List.fromList(_generator.textEncoded(
      textBytes,
      styles: styles,
      linesAfter: linesAfter,
      maxCharsPerLine: maxCharsPerLine,
    )));
  }
  // ************************ (end) Printer Commands ************************
}
