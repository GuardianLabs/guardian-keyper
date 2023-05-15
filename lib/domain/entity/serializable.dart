import 'dart:convert';
import 'dart:typed_data';

abstract class Serializable {
  const Serializable();

  Uint8List toBytes();

  String toBase64url() => base64UrlEncode(toBytes());
}
