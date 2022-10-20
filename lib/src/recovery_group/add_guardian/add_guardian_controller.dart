import '/src/core/model/core_model.dart';
import '/src/core/service/analytics_service.dart';

import '../recovery_group_controller.dart';

export 'package:provider/provider.dart';

class AddGuardianController extends RecoveryGroupGuardianController {
  final GroupId groupId;

  AddGuardianController({
    required super.diContainer,
    required super.pagesCount,
    required this.groupId,
  });

  bool get isDuplicate =>
      getGroupById(groupId)?.guardians.containsKey(qrCode?.peerId) ?? false;

  void startRequest({
    required Callback onRejected,
    required Callback onFailed,
  }) {
    diContainer.analyticsService.logEvent(eventStartAddGuardian);
    networkSubscription = networkStream.listen((MessageModel message) {
      if (!isWaiting) return;
      if (!message.hasResponse) return;
      if (message.code != MessageCode.createGroup) return;
      if (qrCode == null || message.peerId != qrCode!.peerId) return;
      stopListenResponse();
      switch (message.status) {
        case MessageStatus.accepted:
          diContainer.analyticsService.logEvent(eventFinishAddGuardian);
          nextScreen();
          break;
        case MessageStatus.rejected:
          onRejected(message);
          break;
        case MessageStatus.failed:
          onFailed(message);
          break;
        default:
      }
    });
    startNetworkRequest(
      ([_]) => sendToGuardian(qrCode!.copyWith(payload: getGroupById(groupId))),
    );
  }
}
