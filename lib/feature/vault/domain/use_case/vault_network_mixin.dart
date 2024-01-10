import 'package:guardian_keyper/data/managers/network_manager.dart';
import 'package:guardian_keyper/domain/entity/peer_id.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

mixin class VaultNetworkMixin {
  late final pingPeer = _networkManager.pingPeer;
  late final getPeerStatus = _networkManager.getPeerStatus;

  final _networkManager = GetIt.I<NetworkManager>();

  PeerId get selfId => _networkManager.selfId;

  Stream<MessageModel> get messageStream => _networkManager.messageStream;

  Stream<(PeerId, bool)> get peerStatusChangeStream =>
      _networkManager.peerStatusChanges;

  Future<void> sendToGuardian(MessageModel message) =>
      _networkManager.sendToPeer(
        message.peerId,
        message: message.copyWith(peerId: _networkManager.selfId),
      );
}
