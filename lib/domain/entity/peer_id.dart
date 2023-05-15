import 'dart:typed_data';
import 'package:messagepack/messagepack.dart';

import 'id_base.dart';

class PeerId extends IdBase {
  static const currentVersion = 1;

  static final empty = PeerId(token: Uint8List(0));

  PeerId({
    required super.token,
    super.name,
  });

  factory PeerId.fromBytes(List<int> token) {
    final u = Unpacker(token is Uint8List ? token : Uint8List.fromList(token));
    final version = u.unpackInt()!;
    if (version != currentVersion) throw const FormatException();
    return PeerId(
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

  PeerId copyWith({String? name}) =>
      PeerId(token: token, name: name ?? this.name);
}
