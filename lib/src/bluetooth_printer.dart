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
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:image/image.dart';
// import './enums.dart';

/// USB Printer
class BluetoothPrinter extends Printer {
  BluetoothPrinter(PaperSize paperSize, CapabilityProfile profile, {int spaceBetweenRows = 5}) : super(paperSize, profile) {
    _generator = Generator(paperSize, profile, spaceBetweenRows: spaceBetweenRows);
  }

  // final PaperSize _paperSize;
  // final CapabilityProfile _profile;
  Generator _generator;
  // Socket _socket;
  final _bluetoothConnection = BluetoothManager.instance;
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
      final dynamic res = await _bluetoothConnection.connectToAddress(address);
      if (res == true) {
        _bluetoothConnection.writeData(Uint8List.fromList(_generator.reset()));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> disconnect({int delayMs}) async {
    if (delayMs != null) {
      await Future.delayed(Duration(milliseconds: delayMs), () => null);
    }
    await _bluetoothConnection.disconnect();
    // await _bluetoothConnection.destroy();
  }

  @override
  void reset() {
    _bluetoothConnection.writeData(Uint8List.fromList(_generator.reset()));
  }

  @override
  void text(
    String text, {
    PosStyles styles = const PosStyles(codeTable: 'CP1252'),
    int linesAfter = 0,
    bool containsChinese = false,
    int maxCharsPerLine,
  }) {
    _bluetoothConnection.writeData(Uint8List.fromList(
        _generator.text(text, styles: styles, linesAfter: linesAfter, containsChinese: containsChinese, maxCharsPerLine: maxCharsPerLine)));
  }

  @override
  void setGlobalCodeTable(String codeTable) {
    _bluetoothConnection.writeData(Uint8List.fromList(_generator.setGlobalCodeTable(codeTable)));
  }

  @override
  void setGlobalFont(PosFontType font, {int maxCharsPerLine}) {
    _bluetoothConnection.writeData(Uint8List.fromList(_generator.setGlobalFont(font, maxCharsPerLine: maxCharsPerLine)));
  }

  @override
  void setStyles(PosStyles styles, {bool isKanji = false}) {
    _bluetoothConnection.writeData(Uint8List.fromList(_generator.setStyles(styles, isKanji: isKanji)));
  }

  @override
  void rawBytes(List<int> cmd, {bool isKanji = false}) {
    _bluetoothConnection.writeData(Uint8List.fromList(_generator.rawBytes(cmd, isKanji: isKanji)));
  }

  @override
  void emptyLines(int n) {
    _bluetoothConnection.writeData(Uint8List.fromList(_generator.emptyLines(n)));
  }

  @override
  void feed(int n) {
    _bluetoothConnection.writeData(Uint8List.fromList(_generator.feed(n)));
  }

  @override
  void cut({PosCutMode mode = PosCutMode.full}) {
    _bluetoothConnection.writeData(Uint8List.fromList(_generator.cut(mode: mode)));
  }

  @override
  void printCodeTable({String codeTable}) {
    _bluetoothConnection.writeData(Uint8List.fromList(_generator.printCodeTable(codeTable: codeTable)));
  }

  @override
  void beep({int n = 3, PosBeepDuration duration = PosBeepDuration.beep450ms}) {
    _bluetoothConnection.writeData(Uint8List.fromList(_generator.beep(n: n, duration: duration)));
  }

  @override
  void reverseFeed(int n) {
    _bluetoothConnection.writeData(Uint8List.fromList(_generator.reverseFeed(n)));
  }

  @override
  void row(List<PosColumn> cols) {
    _bluetoothConnection.writeData(Uint8List.fromList(_generator.row(cols)));
  }

  void image(Image imgSrc, {PosAlign align = PosAlign.center}) {
    _bluetoothConnection.writeData(Uint8List.fromList(_generator.image(imgSrc, align: align)));
  }

  @override
  void imageRaster(
    Image image, {
    PosAlign align = PosAlign.center,
    bool highDensityHorizontal = true,
    bool highDensityVertical = true,
    PosImageFn imageFn = PosImageFn.bitImageRaster,
  }) {
    _bluetoothConnection.writeData(Uint8List.fromList(_generator.imageRaster(
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
    _bluetoothConnection.writeData(Uint8List.fromList(_generator.barcode(
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
    _bluetoothConnection.writeData(Uint8List.fromList(_generator.qrcode(text, align: align, size: size, cor: cor)));
  }

  @override
  void drawer({PosDrawer pin = PosDrawer.pin2}) {
    _bluetoothConnection.writeData(Uint8List.fromList(_generator.drawer(pin: pin)));
  }

  @override
  void hr({String ch = '-', int len, int linesAfter = 0}) {
    _bluetoothConnection.writeData(Uint8List.fromList(_generator.hr(ch: ch, linesAfter: linesAfter)));
  }

  @override
  void textEncoded(
    Uint8List textBytes, {
    PosStyles styles = const PosStyles(),
    int linesAfter = 0,
    int maxCharsPerLine,
  }) {
    _bluetoothConnection.writeData(Uint8List.fromList(_generator.textEncoded(
      textBytes,
      styles: styles,
      linesAfter: linesAfter,
      maxCharsPerLine: maxCharsPerLine,
    )));
  }

  // Future<dynamic> get allSend => _bluetoothConnection.writeData;
}
