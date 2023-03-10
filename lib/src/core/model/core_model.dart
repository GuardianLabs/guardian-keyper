import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:messagepack/messagepack.dart';

import '../utils/random_utils.dart';
import '../utils/emoji_codes.dart';

part 'recovery_group_model.dart';
part 'secret_shard_model.dart';
part 'message_model.dart';
part 'peer_address.dart';
part 'key_bunch.dart';
part 'id_model.dart';
part 'globals.dart';

@immutable
abstract class Serializable extends Equatable {
  const Serializable();

  bool get isEmpty;

  bool get isNotEmpty;

  Uint8List toBytes();

  String toBase64url() => base64UrlEncode(toBytes());
}
