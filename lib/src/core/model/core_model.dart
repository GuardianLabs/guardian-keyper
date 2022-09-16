import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:messagepack/messagepack.dart';

import '../utils/random_utils.dart';

export 'dart:typed_data' show Uint8List;

part 'recovery_group_model.dart';
part 'secret_shard_model.dart';
part 'event_bus_model.dart';
part 'settings_model.dart';
part 'qr_code_model.dart';
part 'message_model.dart';
part 'token_model.dart';

@immutable
class GlobalsModel {
  final String? bsAddressV4;
  final String? bsAddressV6;
  final int maxNameLength;
  final int minNameLength;
  final int passCodeLength;
  final int maxSecretLength;
  final Duration pageChangeDuration;
  final Duration retryNetworkTimeout;
  final Duration snackBarDuration;
  final Duration qrCodeExpires;

  const GlobalsModel({
    this.bsAddressV4,
    this.bsAddressV6,
    this.maxNameLength = 25,
    this.minNameLength = 3,
    this.passCodeLength = 6,
    this.maxSecretLength = 256,
    this.pageChangeDuration = const Duration(milliseconds: 250),
    this.retryNetworkTimeout = const Duration(seconds: 3),
    this.snackBarDuration = const Duration(seconds: 4),
    this.qrCodeExpires = const Duration(days: 1),
  });
}

@immutable
class KeyBunch {
  final Uint8List encryptionPublicKey;
  final Uint8List encryptionPrivateKey;
  final Uint8List singPublicKey;
  final Uint8List singPrivateKey;
  final Uint8List encryptionAesKey;

  const KeyBunch({
    required this.encryptionPublicKey,
    required this.encryptionPrivateKey,
    required this.singPublicKey,
    required this.singPrivateKey,
    required this.encryptionAesKey,
  });
}
