import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart' show immutable;

// Settings Model
@immutable
class SettingsModel {
  final String deviceName;
  final String pinCode;

  const SettingsModel({
    this.deviceName = '',
    this.pinCode = '',
  });

  factory SettingsModel.fromMap(Map<String, dynamic> value) => SettingsModel(
        deviceName: value['device_name'] ?? 'Unnamed',
        pinCode: value['pin_code'] ?? '',
      );

  factory SettingsModel.fromJson(String value) =>
      SettingsModel.fromMap(jsonDecode(value));

  Map<String, dynamic> toMap() => {
        'device_name': deviceName,
        'pin_code': pinCode,
      };

  String toJson() => jsonEncode(toMap());
}

// KeyPairModel
@immutable
class KeyPairModel {
  final Uint8List publicKey;
  final Uint8List privateKey;

  const KeyPairModel({required this.privateKey, required this.publicKey});

  factory KeyPairModel.fromMap(Map<String, dynamic> value) => KeyPairModel(
        privateKey: base64Decode(value['private']),
        publicKey: base64Decode(value['public']),
      );

  factory KeyPairModel.fromJson(String value) =>
      KeyPairModel.fromMap(jsonDecode(value));

  static Map<String, dynamic> toMap(KeyPairModel value) => {
        'private': base64Encode(value.privateKey),
        'public': base64Encode(value.publicKey),
      };

  static String toJson(KeyPairModel value) =>
      jsonEncode(KeyPairModel.toMap(value));
}
