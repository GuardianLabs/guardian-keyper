part of 'recovery_group_controller.dart';

abstract class RecoveryGroupControllerBase extends PageControllerBase {
  late final StreamSubscription<MessageModel> networkSubscription =
      diContainer.networkService.messageStream.listen(null);
  Timer? timer;

  RecoveryGroupControllerBase({
    required super.diContainer,
    required super.pages,
    super.currentPage,
  });

  Globals get globals => diContainer.globals;

  bool get isWaiting => timer?.isActive == true;

  @override
  void dispose() {
    timer?.cancel();
    networkSubscription.cancel();
    diContainer.platformService.wakelockDisable();
    super.dispose();
  }

  void stopListenResponse() {
    timer?.cancel();
    diContainer.platformService.wakelockDisable();
    notifyListeners();
  }

  void startNetworkRequest(void Function([Timer?]) callback) async {
    await diContainer.platformService.wakelockEnable();
    timer = Timer.periodic(
      diContainer.networkService.router.requestTimeout,
      callback,
    );
    callback();
    notifyListeners();
  }

  Future<void> sendToGuardian(final MessageModel message) =>
      diContainer.networkService.sendTo(
        isConfirmable: false,
        peerId: message.peerId,
        message: message.copyWith(peerId: diContainer.myPeerId),
      );

  RecoveryGroupModel? getGroupById(final GroupId groupId) =>
      diContainer.boxRecoveryGroups.get(groupId.asKey);

  Future<RecoveryGroupModel> createGroup(final RecoveryGroupModel group) async {
    await diContainer.boxRecoveryGroups.put(group.aKey, group);
    notifyListeners();
    return group;
  }

  Future<RecoveryGroupModel> addGuardian(
    final GroupId groupId,
    final PeerId guardian,
  ) async {
    var group = diContainer.boxRecoveryGroups.get(groupId.asKey)!;
    group = group.copyWith(
      guardians: {...group.guardians, guardian: ''},
    );
    await diContainer.boxRecoveryGroups.put(groupId.asKey, group);
    return group;
  }
}
