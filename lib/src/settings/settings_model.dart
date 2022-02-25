import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

// KeyPairModel
@immutable
class KeyPairModel {
  const KeyPairModel({required this.privateKey, required this.publicKey});

  factory KeyPairModel.fromMap(Map<String, dynamic> value) => KeyPairModel(
        privateKey: base64Decode(value['private'] as String),
        publicKey: base64Decode(value['public'] as String),
      );

  factory KeyPairModel.fromJson(String value) =>
      KeyPairModel.fromMap(jsonDecode(value));

  static Map<String, dynamic> toMap(KeyPairModel value) => {
        'private': base64Encode(value.privateKey),
        'public': base64Encode(value.publicKey),
      };

  static String toJson(KeyPairModel value) =>
      jsonEncode(KeyPairModel.toMap(value));

  final Uint8List publicKey;
  final Uint8List privateKey;

  // String get publicKeyHex => publicKey.toString(); //TBD
  // String get privateKeyHex => privateKey.toString(); //TBD
}
