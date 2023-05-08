import 'dart:typed_data';
import 'package:messagepack/messagepack.dart';

import 'id_base.dart';

class VaultId extends IdBase {
  static const currentVersion = 1;

  VaultId({super.name, Uint8List? token})
      : super(token: token ?? IdBase.getNewToken(length: 8));

  factory VaultId.fromBytes(List<int> token) {
    final u = Unpacker(token is Uint8List ? token : Uint8List.fromList(token));
    final version = u.unpackInt()!;
    if (version != currentVersion) throw const FormatException();
    return VaultId(
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

  VaultId copyWith({String? name}) => VaultId(
        token: token,
        name: name ?? this.name,
      );
}
