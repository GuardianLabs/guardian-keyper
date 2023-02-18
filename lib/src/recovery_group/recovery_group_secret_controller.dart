part of 'recovery_group_controller.dart';

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
