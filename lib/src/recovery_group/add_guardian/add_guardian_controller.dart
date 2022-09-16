import 'dart:async';

import '/src/core/model/core_model.dart';

import '../recovery_group_controller.dart';

export 'package:provider/provider.dart';

class AddGuardianController extends RecoveryGroupController {
  final GroupId groupId;
  String _tag = '';
  QRCode? _qrCode;
  Timer? _timer;
  StreamSubscription<MessageModel>? _subscription;

  AddGuardianController({
    required super.diContainer,
    required super.pagesCount,
    required this.groupId,
  });

  String get guardianTag => _tag;

  QRCode? get qrCode => _qrCode;

  RecoveryGroupModel? get group => getGroupById(groupId);

  bool get isDuplicate => group?.guardians.containsKey(qrCode?.peerId) ?? false;

  bool get isWaiting => _subscription != null && !_subscription!.isPaused;

  set guardianTag(String value) {
    if (value == _tag) return;
    _tag = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  void startRequest({
    Callback? onRejected,
    Callback? onFailed,
  }) {
    _subscription = networkStream.listen((MessageModel message) {
      if (!isWaiting) return;
      if (!message.hasResponse) return;
      if (message.type != OperationType.authPeer) return;
      if (_qrCode == null || message.peerId != _qrCode!.peerId) return;
      _timer?.cancel();
      _subscription?.pause();
      if (message.isAccepted) return nextScreen();
      if (message.isRejected) return onRejected?.call(message);
      if (message.isFailed) return onFailed?.call(message);
    });
    _timer = Timer.periodic(globals.retryNetworkTimeout, sendAuthRequest);
    sendAuthRequest();
  }

  void setQRCode(QRCode qrCode) {
    if (_qrCode != null) return;
    if (qrCode.type != OperationType.authPeer) return;
    if (qrCode == _qrCode) return;
    _qrCode = qrCode;
    nextScreen();
  }

  Future<RecoveryGroupModel?> addGuardianToGroup() => addGuardian(
      groupId,
      GuardianModel(
        peerId: _qrCode!.peerId,
        name: _qrCode!.peerName,
        tag: _tag,
      ));

  Future<void> sendAuthRequest([Timer? timer]) {
    for (var e in qrCode!.addresses) {
      addPeer(qrCode!.peerId, e.rawAddress);
    }
    return sendToGuardian(MessageModel(
      peerId: qrCode!.peerId,
      type: OperationType.authPeer,
      nonce: qrCode!.nonce,
      secretShard: SecretShardModel(
        ownerName: myDeviceName,
        groupId: group!.id,
        groupName: group!.name,
      ),
    ));
  }
}
