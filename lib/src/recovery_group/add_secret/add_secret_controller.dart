import 'dart:async';
import 'package:sss256/sss256.dart';

import '/src/core/model/core_model.dart';

import '../recovery_group_controller.dart';

export 'package:provider/provider.dart';

class AddSecretController extends RecoveryGroupController {
  final Map<PeerId, SecretShardModel> _shards = {};
  final Map<PeerId, MessageStatus> _responses = {};
  final Map<PeerId, StreamSubscription> _subscriptions = {};
  final Map<PeerId, bool> _statuses = {};
  final GroupId groupId;
  String secret = '';
  Timer? _timer;
  StreamSubscription<MessageModel>? _subscription;

  AddSecretController({
    required super.diContainer,
    required super.pagesCount,
    required this.groupId,
  });

  Map<PeerId, bool> get statuses => _statuses;

  Map<PeerId, MessageStatus> get responses => _responses;

  RecoveryGroupModel get group => getGroupById(groupId)!;

  @override
  void dispose() {
    for (var s in _subscriptions.values) {
      s.cancel();
    }
    _subscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  void startRequest({
    Callback? onSuccess,
    Callback? onReject,
    Callback? onFailed,
  }) {
    _subscription = networkStream.listen((MessageModel message) {
      if (message.type != OperationType.setShard) return;
      if (!message.hasResponse) return;
      _responses[message.peerId] = message.status;
      notifyListeners();
      if (message.isAccepted) {
        removeShard(message.peerId);
        if (_shards.isEmpty) onSuccess?.call(message);
        return;
      }
      if (message.isRejected) {
        _timer?.cancel();
        _subscription?.cancel();
        _shards.clear();
        onReject?.call(message);
        return;
      }
      onFailed?.call(message);
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
    _splitSecret();
    _timer = Timer.periodic(globals.retryNetworkTimeout, distributeShards);
    distributeShards();
  }

  void _splitSecret() {
    final shards = splitSecret(
      treshold: group.threshold,
      shares: group.maxSize,
      secret: secret,
    );
    if (secret != restoreSecret(shares: shards.sublist(0, group.threshold))) {
      throw Exception('Can not restore the secret');
    }
    final shardsIterator = shards.iterator;
    for (var guardian in group.guardians.values) {
      if (shardsIterator.moveNext()) {
        _shards[guardian.peerId] = SecretShardModel(
          value: shardsIterator.current,
          ownerId: PeerId.empty(),
          ownerName: myDeviceName,
          groupId: group.id,
          groupName: group.name,
          groupSize: group.currentSize,
          groupThreshold: group.threshold,
        );
      }
    }
  }

  Future<void> distributeShards([Timer? timer]) async {
    if (_shards.isEmpty) return timer?.cancel();
    await Future.wait([
      for (var shard in _shards.entries)
        sendToGuardian(MessageModel(
          peerId: shard.key,
          type: OperationType.setShard,
          secretShard: shard.value,
        ))
    ]);
  }

  void removeShard(PeerId peerId) async {
    _shards.remove(peerId);
    if (_shards.isEmpty) {
      final updatedGroup = group.completeGroup();
      await diContainer.boxRecoveryGroup
          .put(updatedGroup.id.asKey, updatedGroup);
    }
    notifyListeners();
  }
}
