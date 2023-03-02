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
          crypto: p2p.Crypto()..operationTimeout = const Duration(seconds: 3),
        );

  Stream<MapEntry<PeerId, bool>> get peerStatusChangeStream =>
      router.lastSeenStream
          .map((e) => MapEntry(PeerId(token: e.key.value), e.value));

  List<PeerAddress> get myAddresses => _myAddresses;

  bool getPeerStatus(final PeerId peerId) =>
      router.getPeerStatus(p2p.PeerId(value: peerId.token));

  Future<bool> pingPeer(final PeerId peerId) =>
      router.pingPeer(p2p.PeerId(value: peerId.token));

  Future<void> sendTo({
    required final PeerId peerId,
    required final MessageModel message,
    required final bool isConfirmable,
  }) async {
    try {
      await router.sendMessage(
        isConfirmable: isConfirmable,
        dstPeerId: p2p.PeerId(value: peerId.token),
        payload: message.toBytes(),
      );
    } catch (_) {
      if (isConfirmable) rethrow;
    }
  }
}
