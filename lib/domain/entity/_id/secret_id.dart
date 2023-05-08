import 'dart:typed_data';
import 'package:messagepack/messagepack.dart';

import 'id_base.dart';

class SecretId extends IdBase {
  static const currentVersion = 1;

  SecretId({Uint8List? token, super.name})
      : super(token: token ?? IdBase.getNewToken(length: 8));

  factory SecretId.fromBytes(List<int> token) {
    final u = Unpacker(token is Uint8List ? token : Uint8List.fromList(token));
    final version = u.unpackInt()!;
    if (version != currentVersion) throw const FormatException();
    return SecretId(
      token: Uint8List.fromList(u.unpackBinary()),
      name: u.unpackString()!,
    );
  }

  @override
  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packBinary(token)
      ..packString(name);
    return p.takeBytes();
  }

  SecretId copyWith({String? name}) => SecretId(
        token: token,
        name: name ?? this.name,
      );
}
