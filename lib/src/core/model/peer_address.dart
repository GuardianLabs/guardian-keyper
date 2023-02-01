part of 'core_model.dart';

class PeerAddress extends Serializable {
  static const currentVersion = 1;

  final InternetAddress address;
  final int port;

  const PeerAddress({required this.address, required this.port});

  @override
  List<Object> get props => [address, port];

  @override
  bool get isEmpty => address.address.isEmpty;

  @override
  bool get isNotEmpty => address.address.isNotEmpty;

  InternetAddressType get type => address.type;

  bool get isIPv4 => address.type == InternetAddressType.IPv4;

  bool get isIPv6 => address.type == InternetAddressType.IPv6;

  @override
  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packBinary(address.rawAddress)
      ..packInt(port);
    return p.takeBytes();
  }

  factory PeerAddress.fromBytes(List<int> value) {
    final u = Unpacker(value is Uint8List ? value : Uint8List.fromList(value));
    final version = u.unpackInt()!;
    if (version != currentVersion) throw const FormatException();
    return PeerAddress(
      address: InternetAddress.fromRawAddress(
        Uint8List.fromList(u.unpackBinary()),
      ),
      port: u.unpackInt()!,
    );
  }
}

class PeerAddressList extends Serializable {
  static const currentVersion = 1;
  static const typeId = 3;

  final List<PeerAddress> addresses;

  const PeerAddressList({required this.addresses});

  @override
  List<Object> get props => [addresses];

  @override
  bool get isEmpty => addresses.isEmpty;

  @override
  bool get isNotEmpty => addresses.isNotEmpty;

  @override
  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packListLength(addresses.length);
    for (final address in addresses) {
      p.packBinary(address.toBytes());
    }
    return p.takeBytes();
  }

  factory PeerAddressList.fromBytes(List<int> value) {
    final u = Unpacker(value is Uint8List ? value : Uint8List.fromList(value));
    final version = u.unpackInt()!;
    if (version != currentVersion) throw const FormatException();
    return PeerAddressList(
      addresses: u
          .unpackList()
          .map<PeerAddress>((e) => PeerAddress.fromBytes(e as List<int>))
          .toList(),
    );
  }
}
