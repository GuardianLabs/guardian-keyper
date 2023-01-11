import '/src/core/model/core_model.dart';
import '/src/core/service/analytics_service.dart';

import '../recovery_group_controller.dart';

export 'package:provider/provider.dart';

class RestoreGroupController extends RecoveryGroupGuardianController {
  RestoreGroupController({
    required super.diContainer,
    required super.pages,
    super.currentPage,
  });

  void startRequest({
    required Callback onSuccess,
    required Callback onReject,
    required Callback onDuplicate,
    required Callback onFail,
  }) {
    diContainer.analyticsService.logEvent(eventStartRestoreVault);
    networkSubscription.onData(
      (message) {
        if (!isWaiting) return;
        if (!message.hasResponse) return;
        if (message.code != MessageCode.takeGroup) return;
        if (qrCode == null || message.peerId != qrCode!.peerId) return;
        stopListenResponse();
        notifyListeners();
        if (message.isFailed) return onFail(message);
        if (message.isRejected) return onReject(message);

        if (message.isAccepted) {
          final guardian = qrCode!.peerId;
          final existingGroup = getGroupById(message.groupId);
          if (existingGroup == null) {
            diContainer.analyticsService.logEvent(eventFinishRestoreVault);
            createGroup(message.recoveryGroup.copyWith(
              ownerId: diContainer.myPeerId,
              guardians: {guardian: ''},
            )).then(
              (group) => onSuccess(message.copyWith(payload: group)),
            );
          } else if (existingGroup.isNotRestoring) {
            onFail(message);
          } else if (existingGroup.guardians.containsKey(guardian)) {
            onDuplicate(message);
          } else if (existingGroup.isNotFull) {
            diContainer.analyticsService.logEvent(eventFinishRestoreVault);
            addGuardian(message.groupId, guardian).then(
              (group) => onSuccess(message.copyWith(payload: group)),
            );
          }
        }
      },
    );
    startNetworkRequest(([_]) {
      sendToGuardian(qrCode!.copyWith(payload: null));
    });
  }
}
