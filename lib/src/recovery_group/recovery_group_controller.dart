import '/src/core/di_container.dart' show SettingsModelExt;
import '/src/core/controller/page_controller.dart';
import '/src/core/model/core_model.dart';

typedef Callback = void Function(MessageModel message);

class RecoveryGroupController extends PageController {
  RecoveryGroupController({
    required super.diContainer,
    required super.pagesCount,
  });

  GlobalsModel get globals => diContainer.globals;

  PeerId get myPeerId =>
      PeerId(value: diContainer.networkService.router.pubKey.data);

  String get myDeviceName => diContainer.boxSettings.deviceName;

  Iterable get storedGroups => diContainer.boxRecoveryGroup.keys;

  Iterable<RecoveryGroupModel> get groups =>
      diContainer.boxRecoveryGroup.values;

  Stream<MessageModel> get networkStream =>
      diContainer.networkService.recoveryGroupStream;

  void addPeer(
    PeerId peerId,
    Uint8List address, {
    bool enableSearch = false,
  }) =>
      diContainer.networkService
          .addPeer(peerId, address, enableSearch: enableSearch);

  Future<void> sendToGuardian(MessageModel message) =>
      diContainer.networkService.sendToGuardian(message);

  RecoveryGroupModel? getGroupById(GroupId groupId) =>
      diContainer.boxRecoveryGroup.get(groupId.asKey);

  Future<RecoveryGroupModel> addGroup(RecoveryGroupModel group) async {
    await diContainer.boxRecoveryGroup.put(group.id.asKey, group);
    notifyListeners();
    return group;
  }

  Future<void> removeGroup(GroupId groupId) async {
    await diContainer.boxRecoveryGroup.delete(groupId.asKey);
    notifyListeners();
  }

  Future<RecoveryGroupModel?> addGuardian(
    GroupId groupId,
    GuardianModel guardian,
  ) async {
    final group = diContainer.boxRecoveryGroup.get(groupId.asKey);
    if (group == null) return null;
    final updatedGroup = group.addGuardian(guardian);
    await diContainer.boxRecoveryGroup.put(updatedGroup.id.asKey, updatedGroup);
    notifyListeners();
    return updatedGroup;
  }
}
