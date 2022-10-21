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

  void startRequest({
    required Callback onRejected,
    required Callback onFailed,
    required Callback onDuplicate,
    required Callback onAppVersionError,
  }) {
    diContainer.analyticsService.logEvent(eventStartAddGuardian);

    if (qrCode == null ||
        qrCode!.timestamp
            .subtract(globals.qrCodeExpires)
            .isAfter(DateTime.now())) {
      return onFailed(qrCode!);
    }
    if (qrCode!.version != MessageModel.currentVersion) {
      return onAppVersionError(qrCode!);
    }
    if (getGroupById(groupId)?.guardians.containsKey(qrCode?.peerId) ?? false) {
      return onDuplicate(qrCode!);
    }

    networkSubscription = networkStream.listen(
      (message) {
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
      },
    );

    startNetworkRequest(
      ([_]) => sendToGuardian(qrCode!.copyWith(payload: getGroupById(groupId))),
    );
  }
}
