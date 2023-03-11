part of 'recovery_group_controller.dart';

abstract class RecoveryGroupControllerBase extends PageControllerBase {
  final platformService = GetIt.I<PlatformService>();
  final networkService = GetIt.I<P2PNetworkService>();
  final analyticsService = GetIt.I<AnalyticsService>();
  final boxRecoveryGroups = GetIt.I<Box<RecoveryGroupModel>>();
  final myPeerId = GetIt.I<SettingsController>().state.deviceId;

  late final networkSubscription = networkService.messageStream.listen(null);

  Timer? timer;

  RecoveryGroupControllerBase({required super.pages, super.currentPage});

  bool get isWaiting => timer?.isActive == true;

  @override
  void dispose() {
    timer?.cancel();
    networkSubscription.cancel();
    platformService.wakelockDisable();
    super.dispose();
  }

  void stopListenResponse() {
    timer?.cancel();
    platformService.wakelockDisable();
    notifyListeners();
  }

  void startNetworkRequest(void Function([Timer?]) callback) async {
    await platformService.wakelockEnable();
    timer = Timer.periodic(
      networkService.router.messageTTL,
      callback,
    );
    callback();
    notifyListeners();
  }

  Future<void> sendToGuardian(final MessageModel message) =>
      networkService.sendTo(
        isConfirmable: false,
        peerId: message.peerId,
        message: message.copyWith(peerId: myPeerId),
      );

  RecoveryGroupModel? getGroupById(final GroupId groupId) =>
      boxRecoveryGroups.get(groupId.asKey);

  Future<RecoveryGroupModel> createGroup(final RecoveryGroupModel group) async {
    await boxRecoveryGroups.put(group.aKey, group);
    notifyListeners();
    return group;
  }

  Future<RecoveryGroupModel> addGuardian(
    final GroupId groupId,
    final PeerId guardian,
  ) async {
    var group = boxRecoveryGroups.get(groupId.asKey)!;
    group = group.copyWith(
      guardians: {...group.guardians, guardian: ''},
    );
    await boxRecoveryGroups.put(groupId.asKey, group);
    return group;
  }
}
