import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/network_manager.dart';
import 'package:guardian_keyper/domain/entity/peer_id.dart';
import 'package:guardian_keyper/feature/settings/data/settings_manager.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

mixin class VaultNetworkMixin {
  late final pingPeer = _networkManager.pingPeer;
  late final getPeerStatus = _networkManager.getPeerStatus;

  PeerId get selfId => _settingsManager.selfId;

  Stream<MessageModel> get messageStream => _networkManager.messageStream;

  Stream<(PeerId, bool)> get peerStatusChangeStream =>
      _networkManager.peerStatusChangeStream;

  Future<void> sendToGuardian(MessageModel message) =>
      _networkManager.sendToPeer(
        message.peerId,
        isConfirmable: false,
        message: message.copyWith(peerId: _settingsManager.selfId),
      );

  final _networkManager = GetIt.I<NetworkManager>();
  final _settingsManager = GetIt.I<SettingsManager>();
}
