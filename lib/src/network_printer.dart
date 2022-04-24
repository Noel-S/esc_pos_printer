/*
 * esc_pos_printer
 * Created by Andrey Ushakov
 * 
 * Copyright (c) 2019-2020. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:esc_pos_printer/src/printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:image/image.dart';
import './enums.dart';

/// Network Printer
class NetworkPrinter extends Printer {
  NetworkPrinter(PaperSize paperSize, CapabilityProfile profile, {int spaceBetweenRows = 5}) : super(paperSize, profile) {
    _generator = Generator(paperSize, profile, spaceBetweenRows: spaceBetweenRows);
  }

  // final PaperSize _paperSize;
  // final CapabilityProfile _profile;
  String _host;
  int _port;
  Generator _generator;
  Socket _socket;

  int get port => _port;
  String get host => _host;
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
    _host = host;
    _port = port;
    try {
      _socket = await Socket.connect(host, port, timeout: timeout);
      _socket.add(_generator.reset());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> disconnect({int delayMs}) async {
    _socket.destroy();
    if (delayMs != null) {
      await Future.delayed(Duration(milliseconds: delayMs), () => null);
    }
  }

  @override
  void reset() {
    _socket.add(_generator.reset());
  }

  @override
  void text(
    String text, {
    PosStyles styles = const PosStyles(codeTable: 'CP1252'),
    int linesAfter = 0,
    bool containsChinese = false,
    int maxCharsPerLine,
  }) {
    _socket.add(_generator.text(text, styles: styles, linesAfter: linesAfter, containsChinese: containsChinese, maxCharsPerLine: maxCharsPerLine));
  }

  @override
  void setGlobalCodeTable(String codeTable) {
    _socket.add(_generator.setGlobalCodeTable(codeTable));
  }

  @override
  void setGlobalFont(PosFontType font, {int maxCharsPerLine}) {
    _socket.add(_generator.setGlobalFont(font, maxCharsPerLine: maxCharsPerLine));
  }

  @override
  void setStyles(PosStyles styles, {bool isKanji = false}) {
    _socket.add(_generator.setStyles(styles, isKanji: isKanji));
  }

  @override
  void rawBytes(List<int> cmd, {bool isKanji = false}) {
    _socket.add(_generator.rawBytes(cmd, isKanji: isKanji));
  }

  @override
  void emptyLines(int n) {
    _socket.add(_generator.emptyLines(n));
  }

  @override
  void feed(int n) {
    _socket.add(_generator.feed(n));
  }

  @override
  void cut({PosCutMode mode = PosCutMode.full}) {
    _socket.add(_generator.cut(mode: mode));
  }

  @override
  void printCodeTable({String codeTable}) {
    _socket.add(_generator.printCodeTable(codeTable: codeTable));
  }

  @override
  void beep({int n = 3, PosBeepDuration duration = PosBeepDuration.beep450ms}) {
    _socket.add(_generator.beep(n: n, duration: duration));
  }

  @override
  void reverseFeed(int n) {
    _socket.add(_generator.reverseFeed(n));
  }

  @override
  void row(List<PosColumn> cols) {
    _socket.add(_generator.row(cols));
  }

  @override
  void image(Image imgSrc, {PosAlign align = PosAlign.center}) {
    _socket.add(_generator.image(imgSrc, align: align));
  }

  @override
  void imageRaster(
    Image image, {
    PosAlign align = PosAlign.center,
    bool highDensityHorizontal = true,
    bool highDensityVertical = true,
    PosImageFn imageFn = PosImageFn.bitImageRaster,
  }) {
    _socket.add(_generator.imageRaster(
      image,
      align: align,
      highDensityHorizontal: highDensityHorizontal,
      highDensityVertical: highDensityVertical,
      imageFn: imageFn,
    ));
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
    _socket.add(_generator.barcode(
      barcode,
      width: width,
      height: height,
      font: font,
      textPos: textPos,
      align: align,
    ));
  }

  @override
  void qrcode(
    String text, {
    PosAlign align = PosAlign.center,
    QRSize size = QRSize.Size4,
    QRCorrection cor = QRCorrection.L,
  }) {
    _socket.add(_generator.qrcode(text, align: align, size: size, cor: cor));
  }

  @override
  void drawer({PosDrawer pin = PosDrawer.pin2}) {
    _socket.add(_generator.drawer(pin: pin));
  }

  @override
  void hr({String ch = '-', int len, int linesAfter = 0}) {
    _socket.add(_generator.hr(ch: ch, linesAfter: linesAfter));
  }

  @override
  void textEncoded(
    Uint8List textBytes, {
    PosStyles styles = const PosStyles(),
    int linesAfter = 0,
    int maxCharsPerLine,
  }) {
    _socket.add(_generator.textEncoded(
      textBytes,
      styles: styles,
      linesAfter: linesAfter,
      maxCharsPerLine: maxCharsPerLine,
    ));
  }
}
