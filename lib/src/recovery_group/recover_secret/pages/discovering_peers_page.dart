import 'package:wakelock/wakelock.dart';

import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';
import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/widgets/auth.dart';

import '../recover_secret_controller.dart';
import '../../widgets/guardian_tile_widget.dart';

class DiscoveryPeersPage extends StatefulWidget {
  const DiscoveryPeersPage({super.key});

  @override
  State<DiscoveryPeersPage> createState() => _DiscoveryPeersPageState();
}

class _DiscoveryPeersPageState extends State<DiscoveryPeersPage> {
  late final RecoveryGroupModel _group;
  late final RecoverySecretController _controller;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _controller = context.read<RecoverySecretController>();
    _group = _controller.group;
    _controller.startRequest(onRejected: _showTerminated);
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
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
                          'Waiting for Vault’s Guardians ',
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
                              text:
                                  'Ask Guardians to log into the app and approve'
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
                        child: Selector<RecoverySecretController, bool>(
                          selector: (_, controller) => controller.hasMinimal,
                          builder: (_, hasMinimal, __) => PrimaryButton(
                            text: 'Access Secret',
                            onPressed: hasMinimal ? _askPasscode : null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: paddingTop20,
                        child: Text(
                          'You need to get at least ${_group.threshold}'
                          ' approvals from Guardians to recover your Secret.',
                          style: textStyleSourceSansPro414Purple,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
                  ),
                ),
                // Guardians
                for (final guardian in _group.guardians.keys)
                  Padding(
                    padding: paddingV6,
                    child: StreamBuilder<MessageModel>(
                      initialData: null,
                      stream: _controller.messagesStream.where(
                        (message) => message.peerId == guardian,
                      ),
                      builder: (_, snapshot) => GuardianTileWidget(
                        guardian: guardian,
                        isSuccess: snapshot.data?.isAccepted,
                        isWaiting: snapshot.data == null,
                        checkStatus: true,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      );

  void _askPasscode() {
    final passCode = context.read<DIContainer>().boxSettings.passCode;
    screenLock(
      context: context,
      correctString: passCode,
      canCancel: true,
      keyPadConfig: keyPadConfig,
      secretsConfig: secretsConfig,
      config: screenLockConfig,
      customizedButtonChild: BiometricLogonButton(callback: _pass),
      customizedButtonTap: () {}, // Fails if null
      title: Padding(
        padding: paddingV32 + paddingH20,
        child: Text(
          'Please enter your current passcode',
          style: textStylePoppins620,
          textAlign: TextAlign.center,
        ),
      ),
      onUnlocked: _pass,
    );
  }

  void _pass() {
    Navigator.of(context).pop();
    _controller.nextScreen();
  }

  void _showTerminated(MessageModel message) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (context) => BottomSheetWidget(
          icon:
              const IconOf.secretRestoration(isBig: true, bage: BageType.error),
          titleString: 'Guardian rejected the recovery of your Secret',
          textSpan: buildTextWithId(
            leadingText: 'Secret Recovery process for ',
            id: message.groupId,
            trailingText: ' has been terminated by your Guardians.',
          ),
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
