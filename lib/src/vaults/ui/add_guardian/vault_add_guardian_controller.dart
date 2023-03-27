import '/src/core/consts.dart';
import '/src/core/data/core_model.dart';
import '/src/core/service/analytics_service.dart';

import '../../vault_controller.dart';

export 'package:provider/provider.dart';

class VaultAddGuardianController extends VaultGuardianController {
  final VaultId groupId;

  VaultAddGuardianController({required super.pages, required this.groupId});

  Future<void> startRequest({
    required Callback onSuccess,
    required Callback onRejected,
    required Callback onFailed,
    required Callback onDuplicate,
    required Callback onAppVersion,
  }) async {
    await serviceRoot.analyticsService.logEvent(eventStartAddGuardian);

    if (qrCode == null ||
        qrCode!.timestamp.subtract(qrCodeExpires).isAfter(DateTime.now())) {
      return onFailed(qrCode!);
    }
    if (qrCode!.version != MessageModel.currentVersion) {
      return onAppVersion(qrCode!);
    }
    if (getGroupById(groupId)?.guardians.containsKey(qrCode?.peerId) ?? false) {
      return onDuplicate(qrCode!);
    }

    networkSubscription.onData(
      (message) {
        if (!isWaiting) return;
        if (qrCode == null) return;
        if (message.hasNoResponse) return;
        if (message.code != MessageCode.createGroup) return;
        if (message.peerId != qrCode!.peerId) return;
        if (message.groupId != groupId) return;
        stopListenResponse();
        switch (message.status) {
          case MessageStatus.accepted:
            serviceRoot.analyticsService.logEvent(eventFinishAddGuardian);
            addGuardian(groupId, message.peerId);
            onSuccess(message);
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

    startNetworkRequest(([_]) {
      sendToGuardian(qrCode!.copyWith(payload: getGroupById(groupId)));
    });
  }
}
