import '/src/core/data/core_model.dart';
import '/src/core/service/analytics_service.dart';

import '../../vault_controller.dart';

export 'package:provider/provider.dart';

class VaultRestoreGroupController extends VaultGuardianController {
  VaultRestoreGroupController({required super.pages, super.currentPage});

  void startRequest({
    required Callback onSuccess,
    required Callback onReject,
    required Callback onDuplicate,
    required Callback onFail,
  }) {
    serviceRoot.analyticsService.logEvent(eventStartRestoreVault);
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
            serviceRoot.analyticsService.logEvent(eventFinishRestoreVault);
            createGroup(message.recoveryGroup.copyWith(
              ownerId: myPeerId,
              guardians: {guardian: ''},
            )).then(
              (group) => onSuccess(message.copyWith(payload: group)),
            );
          } else if (existingGroup.isNotRestoring) {
            onFail(message);
          } else if (existingGroup.guardians.containsKey(guardian)) {
            onDuplicate(message);
          } else if (existingGroup.isNotFull) {
            serviceRoot.analyticsService.logEvent(eventFinishRestoreVault);
            addGuardian(message.groupId, guardian).then(
              (group) => onSuccess(message.copyWith(payload: group)),
            );
          }
        }
      },
    );
    startNetworkRequest(([_]) => sendToGuardian(qrCode!));
  }
}
