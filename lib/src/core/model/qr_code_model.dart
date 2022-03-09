import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

@immutable
class QRCodeModel {
  final Uint8List header;
  final Uint8List authToken;
  final Uint8List pubKey;
  final Uint8List signPubKey;

  const QRCodeModel({
    required this.header,
    required this.authToken,
    required this.pubKey,
    required this.signPubKey,
  });

  factory QRCodeModel.fromString(String qrCode) {
    final packet = base64Decode(qrCode);
    return QRCodeModel(
      header: packet.sublist(0, 3),
      authToken: packet.sublist(4, 35),
      pubKey: packet.sublist(36, 67),
      signPubKey: packet.sublist(68, 99),
    );
  }

  @override
  String toString() {
    var qr = Uint8List(0);
    qr.addAll(header);
    qr.addAll(authToken);
    qr.addAll(pubKey);
    qr.addAll(signPubKey);
    return base64Encode(qr);
  }
}
