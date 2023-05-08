import 'dart:typed_data';
import 'package:messagepack/messagepack.dart';

import 'id_base.dart';

class MessageId extends IdBase {
  static const currentVersion = 1;

  MessageId({Uint8List? token})
      : super(token: token ?? IdBase.getNewToken(length: 16));

  factory MessageId.fromBytes(List<int> token) {
    final u = Unpacker(token is Uint8List ? token : Uint8List.fromList(token));
    final version = u.unpackInt()!;
    if (version != currentVersion) throw const FormatException();
    return MessageId(token: Uint8List.fromList(u.unpackBinary()));
  }

  @override
  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packBinary(token);
    return p.takeBytes();
  }
}
