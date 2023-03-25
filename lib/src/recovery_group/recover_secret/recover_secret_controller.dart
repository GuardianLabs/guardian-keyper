import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sss256/sss256.dart';

import '/src/core/data/core_model.dart';
import '/src/core/service/analytics_service.dart';
import '/src/core/ui/widgets/auth/auth.dart';

import '../recovery_group_controller.dart';

export 'package:provider/provider.dart';

class RecoverySecretController extends RecoveryGroupSecretController {
  String secret = '';

  RecoverySecretController({
    required super.pages,
    required super.groupId,
    required super.secretId,
  }) {
    // fill messages with request
    for (final guardian in group.guardians.keys) {
      messages.add(MessageModel(
        peerId: guardian,
        code: MessageCode.getShard,
        status: guardian == group.ownerId
            ? MessageStatus.accepted
            : MessageStatus.created,
        payload: SecretShardModel(
          id: secretId,
          ownerId: myPeerId,
          groupId: groupId,
          groupSize: group.maxSize,
          groupThreshold: group.threshold,
          shard: guardian == group.ownerId ? group.secrets[secretId]! : '',
        ),
      ));
    }
  }

  Future<void> checkPassCode({
    required final BuildContext context,
    required final void Function() onUnlocked,
  }) =>
      showAskPassCode(
        context: context,
        onUnlocked: onUnlocked,
        onVibrate: serviceRoot.platformService.vibrate,
        currentPassCode: repositoryRoot.settingsRepository.passCode,
        localAuthenticate: serviceRoot.platformService.localAuthenticate,
        useBiometrics: repositoryRoot.settingsRepository.hasBiometrics &&
            repositoryRoot.settingsRepository.isBiometricsEnabled,
      );

  void startRequest({required Callback onRejected}) {
    serviceRoot.analyticsService.logEvent(eventStartRestoreSecret);
    networkSubscription.onData(
      (final message) async {
        if (message.code != MessageCode.getShard) return;
        if (message.hasNoResponse) return;
        final stored = messages.lookup(message);
        if (stored == null || stored.hasResponse) return;
        updateMessage(message);
        if (messages.where((m) => m.isAccepted).length >= group.threshold) {
          stopListenResponse();
          serviceRoot.analyticsService.logEvent(eventFinishRestoreSecret);
          secret = await compute<List<String>, String>(
            (List<String> shares) => restoreSecret(shares: shares),
            messages
                .where((e) => e.secretShard.shard.isNotEmpty)
                .map((e) => e.secretShard.shard)
                .toList(),
          );
          nextScreen();
        } else if (messages.where((e) => e.isRejected).length >
            group.redudancy) {
          stopListenResponse();
          onRejected(message);
        } else {
          notifyListeners();
        }
      },
    );
    startNetworkRequest(requestShards);
  }
}
