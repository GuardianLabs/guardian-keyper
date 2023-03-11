part of 'recovery_group_controller.dart';

class RecoveryGroupSecretController extends RecoveryGroupControllerBase {
  SecretId secretId;
  final GroupId groupId;
  late final RecoveryGroupModel group;
  final Set<MessageModel> messages = {};

  RecoveryGroupSecretController({
    required super.pages,
    super.currentPage,
    required this.groupId,
    required this.secretId,
  }) {
    group = getGroupById(groupId)!;
  }

  void updateMessage(MessageModel message) {
    messages.remove(message);
    messages.add(message);
    notifyListeners();
  }

  void requestShards([_]) {
    if (messages.where((m) => m.hasResponse).length == group.maxSize) {
      stopListenResponse();
    } else {
      for (final message in messages.where((m) => m.hasNoResponse)) {
        sendToGuardian(message);
      }
    }
  }
}
