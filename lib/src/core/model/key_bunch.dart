part of 'core_model.dart';

@immutable
class KeyBunch extends Serializable {
  static const currentVersion = 1;
  static const aesKeyLength = 32;

  final Uint8List encryptionSeed,
      encryptionPublicKey,
      encryptionPrivateKey,
      signSeed,
      signPublicKey,
      signPrivateKey,
      encryptionAesKey;

  @override
  List<Object> get props => [
        encryptionSeed,
        encryptionPublicKey,
        encryptionPrivateKey,
        signSeed,
        signPublicKey,
        signPrivateKey,
        encryptionAesKey,
      ];

  @override
  bool get isEmpty =>
      encryptionSeed.isEmpty &&
      encryptionPublicKey.isEmpty &&
      encryptionPrivateKey.isEmpty &&
      signSeed.isEmpty &&
      signPublicKey.isEmpty &&
      signPrivateKey.isEmpty &&
      encryptionAesKey.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  const KeyBunch({
    required this.encryptionSeed,
    required this.encryptionPublicKey,
    required this.encryptionPrivateKey,
    required this.signSeed,
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
          encryptionSeed: Uint8List.fromList(u.unpackBinary()),
          encryptionPublicKey: Uint8List.fromList(u.unpackBinary()),
          encryptionPrivateKey: Uint8List.fromList(u.unpackBinary()),
          signSeed: Uint8List.fromList(u.unpackBinary()),
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
      ..packBinary(encryptionSeed)
      ..packBinary(encryptionPublicKey)
      ..packBinary(encryptionPrivateKey)
      ..packBinary(signSeed)
      ..packBinary(signPublicKey)
      ..packBinary(signPrivateKey)
      ..packBinary(encryptionAesKey);
    return p.takeBytes();
  }
}
