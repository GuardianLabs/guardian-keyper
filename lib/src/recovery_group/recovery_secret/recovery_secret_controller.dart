import 'dart:async';
import 'package:sss256/sss256.dart';

import '/src/core/model/core_model.dart';

import '../recovery_group_controller.dart';

class RecoverySecretController extends RecoveryGroupController {
  final Map<PeerId, MessageStatus> _responses = {};
  final Map<PeerId, StreamSubscription> _subscriptions = {};
  final Map<PeerId, bool> _statuses = {};
  final Set<String> _shards = {};
  final GroupId groupId;
  Timer? _timer;
  StreamSubscription<MessageModel>? _subscription;

  late final RecoveryGroupModel _group;

  RecoverySecretController({
    required super.diContainer,
    required super.pagesCount,
    required this.groupId,
  }) {
    _group = getGroupById(groupId)!;
  }

  Set<String> get shards => _shards;

  Map<PeerId, bool> get statuses => _statuses;

  Map<PeerId, MessageStatus> get responses => _responses;

  RecoveryGroupModel get group => _group;

  String get secret => restoreSecret(shares: shards.toList());

  @override
  void dispose() {
    for (var s in _subscriptions.values) {
      s.cancel();
    }
    _subscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  void startRequest({Callback? onRejected}) {
    _subscription = networkStream.listen((MessageModel message) {
      if (!message.hasResponse) return;
      if (message.type != OperationType.getShard) return;
      _responses[message.peerId] = message.status;
      if (_responses.length == _group.maxSize) {
        _timer?.cancel();
        _subscription?.cancel();
      }
      if (message.isAccepted && message.secretShard.value.isNotEmpty) {
        _shards.add(message.secretShard.value);
      }
      if (_responses.values.where((e) => e != MessageStatus.accepted).length >
          _group.maxSize - _group.threshold) {
        onRejected?.call(message);
      }
      notifyListeners();
    });
    for (var peerId in group.guardians.keys) {
      _subscriptions[peerId] = diContainer.networkService.onPeerStatusChanged(
        (bool isOnline) {
          if (isOnline == _statuses[peerId]) return;
          _statuses[peerId] = isOnline;
          notifyListeners();
        },
        peerId,
      );
    }
    _timer = Timer.periodic(globals.retryNetworkTimeout, requestShards);
    requestShards();
  }

  Future<void> requestShards([Timer? timer]) async {
    if (_shards.length == _group.currentSize) return timer?.cancel();
    final peers =
        _group.guardians.keys.toSet().difference(_responses.keys.toSet());
    await Future.wait([
      for (var peer in peers)
        sendToGuardian(MessageModel(
          peerId: peer,
          type: OperationType.getShard,
          secretShard: SecretShardModel(
            ownerName: myDeviceName,
            groupId: _group.id,
          ),
        ))
    ]);
  }
}
