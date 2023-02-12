part of '../p2p_network_service.dart';

abstract class P2PNetworkServiceBase {
  final p2p.RouterL2 router;
  final bindPort = p2p.TransportUdp.defaultPort;

  final _myAddresses = <PeerAddress>[];

  P2PNetworkServiceBase({
    Duration keepalivePeriod = const Duration(seconds: 10),
  }) : router = p2p.RouterL2(
          logger: kDebugMode ? print : null,
          keepalivePeriod: keepalivePeriod,
        );

  Stream<MapEntry<PeerId, bool>> get peerStatusChangeStream =>
      router.lastSeenStream
          .map((e) => MapEntry(PeerId(token: e.key.value), e.value));

  List<PeerAddress> get myAddresses => _myAddresses;

  bool getPeerStatus(PeerId peerId) =>
      router.getPeerStatus(p2p.PeerId(value: peerId.token));

  Future<bool> pingPeer(PeerId peerId) =>
      router.pingPeer(p2p.PeerId(value: peerId.token));

  void addPeer(
    PeerId peerId,
    Uint8List address,
    int port, [
    bool isLocal = true,
    bool isStatic = false,
    bool canForward = false,
  ]) {
    final ip = InternetAddress.fromRawAddress(address);
    if (ip == InternetAddress.loopbackIPv4 ||
        ip == InternetAddress.loopbackIPv6) return;
    router.addPeerAddress(
      peerId: p2p.PeerId(value: peerId.token),
      canForward: canForward,
      address: p2p.FullAddress(
        address: ip,
        port: port,
        isLocal: isLocal,
        isStatic: isStatic,
      ),
    );
  }

  Future<void> sendTo({
    required PeerId peerId,
    required MessageModel message,
    required bool isConfirmable,
  }) async {
    try {
      await router.sendMessage(
        isConfirmable: isConfirmable,
        dstPeerId: p2p.PeerId(value: peerId.token),
        payload: message.toBytes(),
      );
    } on TimeoutException {
      // No need to handle
    }
  }
}
