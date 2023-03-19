part of 'recovery_group_controller.dart';

abstract class RecoveryGroupControllerBase extends PageControllerBase {
  final serviceRoot = GetIt.I<ServiceRoot>();
  final repositoryRoot = GetIt.I<RepositoryRoot>();
  final myPeerId = GetIt.I<GuardianController>().state;

  late final networkSubscription =
      serviceRoot.networkService.messageStream.listen(null);

  Timer? timer;

  RecoveryGroupControllerBase({required super.pages, super.currentPage});

  bool get isWaiting => timer?.isActive == true;

  @override
  void dispose() {
    timer?.cancel();
    networkSubscription.cancel();
    serviceRoot.platformService.wakelockDisable();
    super.dispose();
  }

  void stopListenResponse() {
    timer?.cancel();
    serviceRoot.platformService.wakelockDisable();
    notifyListeners();
  }

  void startNetworkRequest(void Function([Timer?]) callback) async {
    await serviceRoot.platformService.wakelockEnable();
    timer = Timer.periodic(
      serviceRoot.networkService.router.messageTTL,
      callback,
    );
    callback();
    notifyListeners();
  }

  Future<void> sendToGuardian(final MessageModel message) =>
      serviceRoot.networkService.sendTo(
        isConfirmable: false,
        peerId: message.peerId,
        message: message.copyWith(peerId: myPeerId),
      );

  RecoveryGroupModel? getGroupById(final GroupId groupId) =>
      repositoryRoot.vaultRepository.get(groupId.asKey);

  Future<RecoveryGroupModel> createGroup(final RecoveryGroupModel group) async {
    await repositoryRoot.vaultRepository.put(group.aKey, group);
    notifyListeners();
    return group;
  }

  Future<RecoveryGroupModel> addGuardian(
    final GroupId groupId,
    final PeerId guardian,
  ) async {
    var group = repositoryRoot.vaultRepository.get(groupId.asKey)!;
    group = group.copyWith(
      guardians: {...group.guardians, guardian: ''},
    );
    await repositoryRoot.vaultRepository.put(groupId.asKey, group);
    return group;
  }
}
