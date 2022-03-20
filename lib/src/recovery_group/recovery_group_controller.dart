import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/widgets.dart' hide Router;
import 'package:ntcdcrypto/ntcdcrypto.dart';
import 'package:p2plib/p2plib.dart';

import '../core/service/event_bus.dart';
import '../core/model/p2p_model.dart';
import 'recovery_group_model.dart';
import 'recovery_group_service.dart';

class RecoveryGroupController extends TopicHandler with ChangeNotifier {
  static const _topicOfThis = 100;
  static const _topicSubscribeTo = 101;

  final p2pNetwork = StreamController<P2PPacket>.broadcast();
  final RecoveryGroupService _recoveryGroupService;
  Map<String, RecoveryGroupModel> _groups = {};

  RecoveryGroupController({
    required RecoveryGroupService recoveryGroupService,
    required EventBus eventBus,
    required Router router,
  })  : _recoveryGroupService = recoveryGroupService,
        super(router) {
    eventBus.on<RecoveryGroupClearCommand>().listen((event) => clear());
  }

  Map<String, RecoveryGroupModel> get groups => _groups;

  @override
  Uint64List topics() => Uint64List.fromList([_topicSubscribeTo]);

  @override
  void onMessage(Uint8List data, Peer peer) {
    final header = Header.deserialize(data.sublist(0, Header.length));
    if (header.dstKey != router.pubKey) return;
    router.addPeer(header.srcKey, peer);
    p2pNetwork.add(P2PPacket.fromCbor(
        P2PCrypto.decrypt(
          header.srcKey,
          router.keyPair.secretKey,
          data.sublist(Header.length),
        ),
        header.srcKey));
  }

  Future<void> sendAuthRequest(QRCode guardianQRCode) async {
    final peerPubKey = PubKey(guardianQRCode.pubKey);
    await router
        .sendTo(
          _topicOfThis,
          peerPubKey,
          P2PPacket(
            type: MessageType.authPeer,
            body: guardianQRCode.authToken,
          ).toCbor(),
          true,
        )
        .onError(p2pNetwork.addError);
  }

  void distributeShards(
    Map<PubKey, String> shards,
    String groupName,
    String secret,
  ) {
    for (var shard in shards.entries) {
      router
          .sendTo(
            _topicOfThis,
            shard.key,
            P2PPacket(
              type: MessageType.setShard,
              body: SetShardPacket(
                groupName: groupName,
                groupId: _groups[groupName]!.id.data,
                secretShard: Uint8List.fromList(shard.value.codeUnits),
              ).toCbor(),
            ).toCbor(),
            true,
          )
          .onError(p2pNetwork.addError);
    }
  }

  void requestShards(Set<PubKey> peers, GroupID groupId) {
    for (var peer in peers) {
      router
          .sendTo(
            _topicOfThis,
            peer,
            P2PPacket(type: MessageType.getShard, body: groupId.data).toCbor(),
            true,
          )
          .onError(p2pNetwork.addError);
    }
  }

  Map<PubKey, String> splitSecret(String secret, RecoveryGroupModel group) {
    final shards =
        SSS().create(group.threshold, group.guardians.length, secret, true);
    final guardians = group.guardians.values.toList();
    return {
      for (var i = 0; i < shards.length; i++) guardians[i].pubKey: shards[i]
    };
  }

  String restoreSecret(List<String> shards) => SSS().combine(shards, true);

  Future<void> load() async {
    _groups = await _recoveryGroupService.getGroups();
  }

  Future<void> _save() async {
    await _recoveryGroupService.setGroups(_groups);
    notifyListeners();
  }

  Future<void> clear() async {
    await _recoveryGroupService.clearGroups();
    _groups.clear();
    notifyListeners();
  }

  Future<void> addGroup(RecoveryGroupModel group) async {
    if (_groups.containsKey(group.name)) {
      throw RecoveryGroupAlreadyExists();
    }
    _groups[group.name] = group;
    await _save();
  }

  Future<void> addGuardian(
    String groupName,
    RecoveryGroupGuardianModel guardian,
  ) async {
    if (!_groups.containsKey(groupName)) {
      throw RecoveryGroupDoesNotExist();
    }
    final group = _groups[groupName]!;
    _groups[groupName] = group.addGuardian(guardian);
    await _save();
  }

  Future<void> addSecret(
    String groupName,
    RecoveryGroupSecretModel secret,
  ) async {
    // TBD: do all checks
    // if (_groups.containsKey(groupName)) {
    //   throw RecoveryGroupAlreadyExists();
    // }
    final group = _groups[groupName]!;
    final updatedGroup = group.addSecret(secret);
    _groups[groupName] = updatedGroup;
    await _save();
  }
}

class RecoveryGroupAlreadyExists implements Exception {
  static const description = 'Group with given name already exists!';
}

class RecoveryGroupDoesNotExist implements Exception {
  static const description = 'Group with given name does not exist!';
}
