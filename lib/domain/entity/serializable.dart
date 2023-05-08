import 'dart:convert';
import 'dart:typed_data';

abstract class Serializable {
  const Serializable();

  bool get isEmpty;

  bool get isNotEmpty => !isEmpty;

  Uint8List toBytes();

  String toBase64url() => base64UrlEncode(toBytes());
}
