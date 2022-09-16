import 'dart:async';

import '/src/core/model/core_model.dart';

import '../recovery_group_controller.dart';

export 'package:provider/provider.dart';

enum RestoreGroupResult { success, reject, fail, duplicate }

class RestoreGroupController extends RecoveryGroupController {
  StreamSubscription<MessageModel>? _subscription;
  Timer? _timer;
  QRCode? _qrCode;
  bool _isWaiting = true;

  RestoreGroupController({
    required super.diContainer,
    required super.pagesCount,
  });

  QRCode? get qrCode => _qrCode;

  bool get isWaiting => _isWaiting;

  @override
  void dispose() {
    _subscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  void startRequest({
    void Function(MessageModel message, RecoveryGroupModel group)? onSuccess,
    Callback? onReject,
    Callback? onDuplicate,
    Callback? onFail,
  }) {
    _subscription = networkStream.listen((MessageModel message) {
      if (!isWaiting) return;
      if (!message.hasResponse) return;
      if (message.type != OperationType.takeOwnership) return;
      if (_qrCode == null || message.peerId != _qrCode!.peerId) return;
      _timer?.cancel();
      _subscription?.cancel();
      _isWaiting = false;
      notifyListeners();
      if (message.isFailed) return onFail?.call(message);
      if (message.isRejected) return onReject?.call(message);

      if (message.isAccepted) {
        final guardian = GuardianModel(
          name: _qrCode!.peerName,
          peerId: _qrCode!.peerId,
        );
        final existingGroup = getGroupById(message.secretShard.groupId);
        if (existingGroup == null) {
          addGroup(RecoveryGroupModel(
            id: message.secretShard.groupId,
            name: message.secretShard.groupName,
            type: RecoveryGroupType.devices,
            maxSize: message.secretShard.groupSize,
            guardians: {guardian.peerId: guardian},
            isRestoring: true,
            hasSecret: true,
          )).then((group) => onSuccess?.call(message, group));
        } else if (existingGroup.isNotRestoring) {
          onFail?.call(message);
        } else if (existingGroup.guardians.containsKey(guardian.peerId)) {
          onDuplicate?.call(message);
        } else if (existingGroup.isNotFull) {
          addGuardian(message.secretShard.groupId, guardian)
              .then((group) => onSuccess?.call(message, group!));
        }
      }
    });
    _timer = Timer.periodic(
      globals.retryNetworkTimeout,
      sendTakeOwnershipRequest,
    );
    sendTakeOwnershipRequest();
  }

  void setQRCode(QRCode qrCode) {
    if (_qrCode != null) return;
    if (qrCode.type != OperationType.takeOwnership) return;
    if (qrCode == _qrCode) return;
    _qrCode = qrCode;
    nextScreen();
  }

  Future<void> sendTakeOwnershipRequest([Timer? _]) async {
    try {
      for (var e in qrCode!.addresses) {
        addPeer(qrCode!.peerId, e.rawAddress);
      }
      await sendToGuardian(MessageModel(
        peerId: qrCode!.peerId,
        type: OperationType.takeOwnership,
        nonce: qrCode!.nonce,
        secretShard: SecretShardModel(ownerName: myDeviceName),
      ));
    } catch (_) {}
  }

  void scanAnotherCode() {
    _qrCode = null;
    _isWaiting = true;
    previousScreen();
  }
}
