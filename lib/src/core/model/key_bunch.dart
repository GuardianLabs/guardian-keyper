part of 'core_model.dart';

@immutable
class KeyBunch extends Serializable {
  static const currentVersion = 1;
  static const aesKeyLength = 32;

  final Uint8List encryptionPublicKey,
      encryptionPrivateKey,
      signPublicKey,
      signPrivateKey,
      encryptionAesKey;

  @override
  List<Object> get props => [
        encryptionPublicKey,
        encryptionPrivateKey,
        signPublicKey,
        signPrivateKey,
        encryptionAesKey,
      ];

  @override
  bool get isEmpty =>
      encryptionPublicKey.isEmpty &&
      encryptionPrivateKey.isEmpty &&
      signPublicKey.isEmpty &&
      signPrivateKey.isEmpty &&
      encryptionAesKey.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  const KeyBunch({
    required this.encryptionPublicKey,
    required this.encryptionPrivateKey,
    required this.signPublicKey,
    required this.signPrivateKey,
    required this.encryptionAesKey,
  });

  factory KeyBunch.fromBytes(List<int> bytes) {
    final u = Unpacker(bytes is Uint8List ? bytes : Uint8List.fromList(bytes));
    final version = u.unpackInt()!;
    switch (version) {
      case 1:
        return KeyBunch(
          encryptionPublicKey: Uint8List.fromList(u.unpackBinary()),
          encryptionPrivateKey: Uint8List.fromList(u.unpackBinary()),
          signPublicKey: Uint8List.fromList(u.unpackBinary()),
          signPrivateKey: Uint8List.fromList(u.unpackBinary()),
          encryptionAesKey: Uint8List.fromList(u.unpackBinary()),
        );
      default:
        throw const FormatException('Unsupported version of KeyBunch');
    }
  }

  @override
  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packBinary(encryptionPublicKey)
      ..packBinary(encryptionPrivateKey)
      ..packBinary(signPublicKey)
      ..packBinary(signPrivateKey)
      ..packBinary(encryptionAesKey);
    return p.takeBytes();
  }
}
