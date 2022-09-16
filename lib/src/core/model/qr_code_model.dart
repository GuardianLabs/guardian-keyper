part of 'core_model.dart';

@immutable
class QRCode extends Equatable {
  static const currentVersion = 1;

  static QRCode? tryParseBase64(String value) {
    try {
      return QRCode.fromBase64(value);
    } catch (_) {
      return null;
    }
  }

  final int version;
  final int issuedAt;
  final OperationType type;
  final Nonce nonce;
  final PeerId peerId;
  final String peerName;
  final List<InternetAddress> addresses;

  @override
  List<Object> get props => [nonce, peerId, type, addresses];

  DateTime get createdAt => DateTime.fromMillisecondsSinceEpoch(issuedAt);

  const QRCode({
    this.version = currentVersion,
    required this.nonce,
    required this.peerId,
    required this.type,
    required this.peerName,
    this.issuedAt = 0,
    this.addresses = const [],
  });

  factory QRCode.fromBytes(Uint8List bytes) {
    final u = Unpacker(bytes);
    final version = u.unpackInt()!;
    switch (version) {
      case 1:
        return QRCode(
          version: version,
          issuedAt: u.unpackInt()!,
          type: OperationType.values[u.unpackInt()!],
          nonce: Nonce(value: Uint8List.fromList(u.unpackBinary())),
          peerId: PeerId(value: Uint8List.fromList(u.unpackBinary())),
          peerName: u.unpackString()!,
          addresses: u
              .unpackList()
              .map<Uint8List>((e) => Uint8List.fromList(e as List<int>))
              .map((e) => InternetAddress.fromRawAddress(e))
              .toList(),
        );
      default:
        throw const FormatException();
    }
  }

  factory QRCode.fromBase64(String value) =>
      QRCode.fromBytes(base64Decode(value));

  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packInt(issuedAt)
      ..packInt(type.index)
      ..packBinary(nonce.value)
      ..packBinary(peerId.value)
      ..packString(peerName)
      ..packListLength(addresses.length);
    for (var e in addresses) {
      p.packBinary(e.rawAddress);
    }
    return p.takeBytes();
  }

  String toBase64url() => base64UrlEncode(toBytes());
}
