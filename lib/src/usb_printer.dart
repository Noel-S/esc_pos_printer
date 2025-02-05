/*
 * esc_pos_printer
 * Created by Andrey Ushakov
 * 
 * Copyright (c) 2019-2020. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

// import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:esc_pos_printer/src/printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:image/image.dart';
import './enums.dart';

/// USB Printer
class USBPrinter extends Printer {
  USBPrinter(PaperSize paperSize, CapabilityProfile profile, {int spaceBetweenRows = 5}) : super(paperSize, profile) {
    _generator = Generator(paperSize, profile, spaceBetweenRows: spaceBetweenRows);
  }

  // final PaperSize _paperSize;
  // final CapabilityProfile _profile;
  Generator _generator;
  // Socket _socket;
  final FlutterUsbPrinter _usbWrite = FlutterUsbPrinter();
  // PaperSize get paperSize => _paperSize;
  // CapabilityProfile get profile => _profile;

  @override
  Future<bool> connect({
    String host,
    int port = 9100,
    Duration timeout = const Duration(seconds: 5),
    int vendorId,
    int productId,
    String address,
  }) async {
    try {
      await _usbWrite.connect(vendorId, productId);
      await _usbWrite.write(Uint8List.fromList(_generator.reset()));
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> disconnect({int delayMs}) async {
    _usbWrite.close();
    if (delayMs != null) {
      await Future.delayed(Duration(milliseconds: delayMs), () => null);
    }
  }

  @override
  void reset() {
    _usbWrite.write(Uint8List.fromList(_generator.reset()));
  }

  @override
  void text(
    String text, {
    PosStyles styles = const PosStyles(codeTable: 'CP1252'),
    int linesAfter = 0,
    bool containsChinese = false,
    int maxCharsPerLine,
  }) {
    _usbWrite.write(Uint8List.fromList(
        _generator.text(text, styles: styles, linesAfter: linesAfter, containsChinese: containsChinese, maxCharsPerLine: maxCharsPerLine)));
  }

  @override
  void setGlobalCodeTable(String codeTable) {
    _usbWrite.write(Uint8List.fromList(_generator.setGlobalCodeTable(codeTable)));
  }

  @override
  void setGlobalFont(PosFontType font, {int maxCharsPerLine}) {
    _usbWrite.write(Uint8List.fromList(_generator.setGlobalFont(font, maxCharsPerLine: maxCharsPerLine)));
  }

  @override
  void setStyles(PosStyles styles, {bool isKanji = false}) {
    _usbWrite.write(Uint8List.fromList(_generator.setStyles(styles, isKanji: isKanji)));
  }

  @override
  void rawBytes(List<int> cmd, {bool isKanji = false}) {
    _usbWrite.write(Uint8List.fromList(_generator.rawBytes(cmd, isKanji: isKanji)));
  }

  @override
  void emptyLines(int n) {
    _usbWrite.write(Uint8List.fromList(_generator.emptyLines(n)));
  }

  @override
  void feed(int n) {
    _usbWrite.write(Uint8List.fromList(_generator.feed(n)));
  }

  @override
  void cut({PosCutMode mode = PosCutMode.full}) {
    _usbWrite.write(Uint8List.fromList(_generator.cut(mode: mode)));
  }

  @override
  void printCodeTable({String codeTable}) {
    _usbWrite.write(Uint8List.fromList(_generator.printCodeTable(codeTable: codeTable)));
  }

  @override
  void beep({int n = 3, PosBeepDuration duration = PosBeepDuration.beep450ms}) {
    _usbWrite.write(Uint8List.fromList(_generator.beep(n: n, duration: duration)));
  }

  @override
  void reverseFeed(int n) {
    _usbWrite.write(Uint8List.fromList(_generator.reverseFeed(n)));
  }

  @override
  void row(List<PosColumn> cols) {
    _usbWrite.write(Uint8List.fromList(_generator.row(cols)));
  }

  @override
  void image(Image imgSrc, {PosAlign align = PosAlign.center}) {
    _usbWrite.write(Uint8List.fromList(_generator.image(imgSrc, align: align)));
  }

  @override
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

  @override
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

  @override
  void qrcode(
    String text, {
    PosAlign align = PosAlign.center,
    QRSize size = QRSize.Size4,
    QRCorrection cor = QRCorrection.L,
  }) {
    _usbWrite.write(Uint8List.fromList(_generator.qrcode(text, align: align, size: size, cor: cor)));
  }

  @override
  void drawer({PosDrawer pin = PosDrawer.pin2}) {
    _usbWrite.write(Uint8List.fromList(_generator.drawer(pin: pin)));
  }

  @override
  void hr({String ch = '-', int len, int linesAfter = 0}) {
    _usbWrite.write(Uint8List.fromList(_generator.hr(ch: ch, linesAfter: linesAfter)));
  }

  @override
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
}
