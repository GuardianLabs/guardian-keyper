part of 'recovery_group_controller.dart';

abstract class RecoveryGroupControllerBase extends PageControllerBase {
  late StreamSubscription<MessageModel> networkSubscription;
  Timer? timer;

  RecoveryGroupControllerBase({
    required super.diContainer,
    required super.pages,
    super.currentPage,
  }) {
    networkSubscription = diContainer.networkService.messageStream.listen(null);
  }

  Globals get globals => diContainer.globals;

  bool get isWaiting => !networkSubscription.isPaused;

  @override
  void dispose() {
    timer?.cancel();
    networkSubscription.cancel();
    diContainer.platformService.wakelockDisable();
    super.dispose();
  }

  void stopListenResponse() {
    timer?.cancel();
    networkSubscription.pause();
    diContainer.platformService.wakelockDisable();
    notifyListeners();
  }

  void startNetworkRequest(void Function([Timer?]) callback) async {
    await diContainer.platformService.wakelockEnable();
    await diContainer.networkService.start();
    networkSubscription.resume();
    timer = Timer.periodic(
      diContainer.networkService.router.requestTimeout,
      callback,
    );
    callback();
    notifyListeners();
  }

  void assignPeersAddresses(PeerId peerId, PeerAddressList list) {
    for (final e in list.addresses) {
      try {
        diContainer.networkService.addPeer(
          peerId,
          e.address.rawAddress,
          e.port,
        );
      } catch (_) {}
    }
  }

  Future<void> sendToGuardian(MessageModel message) =>
      diContainer.networkService.sendTo(
        isConfirmable: false,
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
