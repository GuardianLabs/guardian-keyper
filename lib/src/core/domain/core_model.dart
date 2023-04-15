import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:messagepack/messagepack.dart';

export '/src/vaults/domain/vault_model.dart';
export '/src/vaults/domain/secret_shard_model.dart';
export '/src/message/domain/message_model.dart';

part 'id_base.dart';
part 'peer_id.dart';

abstract class Serializable {
  const Serializable();

  bool get isEmpty;

  bool get isNotEmpty => !isEmpty;

  Uint8List toBytes();

  String toBase64url() => base64UrlEncode(toBytes());
}
