part of 'recovery_group_controller.dart';

abstract class RecoveryGroupControllerBase extends PageControllerBase {
  final authCase = GetIt.I<AuthCase>();
  final platformService = GetIt.I<ServiceRoot>().platformService;
  final networkService = GetIt.I<ServiceRoot>().networkService;
  final analyticsService = GetIt.I<ServiceRoot>().analyticsService;
  final vaultRepository = GetIt.I<RepositoryRoot>().vaultRepository;
  final myPeerId = GetIt.I<GuardianController>().state;

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
      vaultRepository.get(groupId.asKey);

  Future<RecoveryGroupModel> createGroup(final RecoveryGroupModel group) async {
    await vaultRepository.put(group.aKey, group);
    notifyListeners();
    return group;
  }

  Future<RecoveryGroupModel> addGuardian(
    final GroupId groupId,
    final PeerId guardian,
  ) async {
    var group = vaultRepository.get(groupId.asKey)!;
    group = group.copyWith(
      guardians: {...group.guardians, guardian: ''},
    );
    await vaultRepository.put(groupId.asKey, group);
    return group;
  }
}
