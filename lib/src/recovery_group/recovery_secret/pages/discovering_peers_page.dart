import 'package:amplitude_flutter/amplitude.dart';
import 'package:wakelock/wakelock.dart';

import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';
import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/widgets/auth.dart';

import '../recovery_secret_controller.dart';
import '../../widgets/guardian_tile_widget.dart';

class DiscoveryPeersPage extends StatefulWidget {
  const DiscoveryPeersPage({super.key});

  @override
  State<DiscoveryPeersPage> createState() => _DiscoveryPeersPageState();
}

class _DiscoveryPeersPageState extends State<DiscoveryPeersPage> {
  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    context
        .read<RecoverySecretController>()
        .startRequest(onRejected: _showTerminated);
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RecoverySecretController>(context);
    final responses = controller.responses;
    final group = controller.group;
    return Column(
      children: [
        // Header
        const HeaderBar(
          caption: 'Secret Recovery',
          closeButton: HeaderBarCloseButton(),
        ),
        // Body
        Expanded(
            child: ListView(
          padding: paddingH20,
          children: [
            // Card
            Padding(
              padding: paddingV32,
              child: Container(
                decoration: boxDecoration,
                padding: paddingAll20,
                child: Column(children: [
                  Padding(
                    padding: paddingBottom12,
                    child: Text(
                      'Waiting for Guardians',
                      style: textStylePoppins620,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: textStyleSourceSansPro414Purple,
                      children: const [
                        TextSpan(
                          text: 'Ask Guardians to log into the app and approve'
                              ' a Secret Recovery. Once they approve,'
                              ' their icon will go ',
                        ),
                        TextSpan(
                          text: 'green.',
                          style: TextStyle(color: clGreen),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: paddingTop20,
                    child: PrimaryButton(
                      text: 'Access my Secret',
                      onPressed: controller.shards.length >= group.threshold
                          ? _askPasscode
                          : null,
                    ),
                  ),
                  Padding(
                    padding: paddingTop20,
                    child: Text(
                      'You need to get at least ${group.threshold}'
                      ' approvals from Guardians to recover your Secret.',
                      style: textStyleSourceSansPro414Purple,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
              ),
            ),
            // Guardians
            for (var guardian in group.guardians.values)
              Padding(
                padding: paddingV6,
                child: GuardianTileWidget(
                  guardian: guardian,
                  isSuccess: responses[guardian.peerId] == null
                      ? null
                      : responses[guardian.peerId] == MessageStatus.accepted,
                  isWaiting: !responses.containsKey(guardian.peerId),
                  isOnline: controller.statuses[guardian.peerId] ?? false,
                ),
              )
          ],
        )),
      ],
    );
  }

  void _askPasscode() {
    final passCode = context.read<DIContainer>().boxSettings.passCode;
    screenLock(
      context: context,
      correctString: passCode,
      canCancel: true,
      digits: passCode.length,
      keyPadConfig: keyPadConfig,
      secretsConfig: secretsConfig,
      screenLockConfig: screenLockConfig,
      customizedButtonChild: BiometricLogonButton(callback: _pass),
      customizedButtonTap: () {}, // Fails if null
      title: Padding(
          padding: paddingV32H20,
          child: Text(
            'Please enter your current passcode',
            style: textStylePoppins620,
            textAlign: TextAlign.center,
          )),
      didUnlocked: _pass,
    );
  }

  void _pass() {
    Amplitude.getInstance().logEvent('RecoverSecret Finish');
    Navigator.of(context).pop();
    context.read<RecoverySecretController>().nextScreen();
  }

  void _showTerminated(MessageModel message) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (context) => BottomSheetWidget(
          icon:
              const IconOf.secretRestoration(isBig: true, bage: BageType.error),
          titleString: 'Guardian rejected the recovery of your Secret',
          textString:
              'Secret Recovery process for ${message.secretShard.groupName}'
              ' has been terminated by your Guardians.',
          footer: Padding(
            padding: paddingV20,
            child: PrimaryButton(
              text: 'Done',
              onPressed: Navigator.of(context).pop,
            ),
          ),
        ),
      ).then(Navigator.of(context).pop);
}
