import 'dart:async';

import '/src/core/model/core_model.dart';
import '/src/core/controller/page_controller_base.dart';

typedef Callback = void Function(MessageModel message);

abstract class RecoveryGroupControllerBase extends PageControllerBase {
  late StreamSubscription<MessageModel> networkSubscription;
  Timer? timer;

  RecoveryGroupControllerBase({
    required super.diContainer,
    required super.pages,
    super.currentPage,
  }) {
    networkSubscription = diContainer.networkService.messageStream.listen(null)
      ..pause();
  }

  Globals get globals => diContainer.globals;

  bool get isWaiting => !networkSubscription.isPaused;

  @override
  void dispose() {
    stopListenResponse();
    super.dispose();
  }

  void stopListenResponse() {
    timer?.cancel();
    networkSubscription.pause();
    diContainer.platformService.wakelockDisable();
    notifyListeners();
  }

  void startNetworkRequest(void Function([Timer?]) callback) async {
    await diContainer.networkService.startMdnsDiscovery();
    await diContainer.platformService.wakelockEnable();
    networkSubscription.resume();
    timer = Timer.periodic(
      diContainer.networkService.router.requestTimeout,
      callback,
    );
    callback();
    notifyListeners();
  }

  void assignPeersAddresses(PeerId peerId, PeerAddressList list) {
    for (final address in list.addresses) {
      try {
        diContainer.networkService.addPeer(
          peerId,
          address.address.rawAddress,
        );
      } catch (_) {}
    }
  }

  Future<void> sendToGuardian(MessageModel message) =>
      diContainer.networkService.sendTo(
        withAck: false,
        peerId: message.peerId,
        message: message.copyWith(peerId: diContainer.myPeerId),
      );

  RecoveryGroupModel? getGroupById(GroupId groupId) =>
      diContainer.boxRecoveryGroups.get(groupId.asKey);

  Future<RecoveryGroupModel> createGroup(RecoveryGroupModel group) async {
    await diContainer.boxRecoveryGroups.put(group.aKey, group);
    notifyListeners();
    return group;
  }

  Future<RecoveryGroupModel> addGuardian(
    GroupId groupId,
    PeerId guardian,
  ) async {
    var group = diContainer.boxRecoveryGroups.get(groupId.asKey)!;
    group = group.copyWith(
      guardians: {...group.guardians, guardian: ''},
    );
    await diContainer.boxRecoveryGroups.put(groupId.asKey, group);
    return group;
  }
}

class RecoveryGroupGuardianController extends RecoveryGroupControllerBase {
  MessageModel? _qrCode;

  RecoveryGroupGuardianController({
    required super.diContainer,
    required super.pages,
    super.currentPage,
  });

  MessageModel? get qrCode => _qrCode;

  set qrCode(MessageModel? qrCode) {
    if (_qrCode != qrCode) {
      _qrCode = qrCode;
      if (qrCode != null) {
        assignPeersAddresses(
          qrCode.peerId,
          qrCode.payload as PeerAddressList,
        );
        nextScreen();
      }
    }
  }
}

class RecoveryGroupSecretController extends RecoveryGroupControllerBase {
  SecretId secretId;
  final GroupId groupId;
  late final RecoveryGroupModel group;
  final Set<MessageModel> messages = {};
  final _messagesStreamController = StreamController<MessageModel>.broadcast();

  RecoveryGroupSecretController({
    required super.diContainer,
    required super.pages,
    super.currentPage,
    required this.groupId,
    required this.secretId,
  }) {
    group = getGroupById(groupId)!;
  }

  Set<MessageModel> get messagesWithResponse =>
      messages.where((m) => m.hasResponse).toSet();

  Set<MessageModel> get messagesHasNoResponse =>
      messages.where((m) => m.hasNoResponse).toSet();

  Set<MessageModel> get messagesWithSuccess =>
      messages.where((m) => m.isAccepted).toSet();

  Set<MessageModel> get messagesNotSuccess =>
      messages.where((m) => m.isRejected || m.isFailed).toSet();

  Stream<MessageModel> get messagesStream => _messagesStreamController.stream;

  @override
  void dispose() {
    _messagesStreamController.close();
    super.dispose();
  }

  void updateMessage(MessageModel message) {
    messages.remove(message);
    messages.add(message);
    _messagesStreamController.add(message);
    notifyListeners();
  }

  void requestShards([_]) {
    if (messagesWithResponse.length == group.maxSize) {
      stopListenResponse();
    } else {
      for (final message in messagesHasNoResponse) {
        sendToGuardian(message);
      }
    }
  }
}
