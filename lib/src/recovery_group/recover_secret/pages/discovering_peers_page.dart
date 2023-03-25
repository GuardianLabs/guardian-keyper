import '/src/core/data/core_model.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/ui/widgets/icon_of.dart';

import '../recover_secret_controller.dart';
import '../../widgets/guardian_list_tile.dart';
import '../../widgets/guardian_self_list_tile.dart';

class DiscoveryPeersPage extends StatefulWidget {
  const DiscoveryPeersPage({super.key});

  @override
  State<DiscoveryPeersPage> createState() => _DiscoveryPeersPageState();
}

class _DiscoveryPeersPageState extends State<DiscoveryPeersPage> {
  late final _controller = context.read<RecoverySecretController>()
    ..startRequest(onRejected: _showTerminated);

  @override
  Widget build(final BuildContext context) => Column(
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
                        child: Text(
                          'You need to get at least '
                          '${_controller.group.threshold - (_controller.group.isSelfGuarded ? 1 : 0)}'
                          ' approvals from Guardians to recover your Secret.',
                          style: textStyleSourceSansPro414Purple,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
                  ),
                ),
                // Guardians
                for (final guardian in _controller.group.guardians.keys)
                  Padding(
                    padding: paddingV6,
                    child: guardian == _controller.group.ownerId
                        ? GuardianSelfListTile(guardian: guardian)
                        : Consumer<RecoverySecretController>(
                            builder: (_, controller, __) {
                              final message = controller.messages.firstWhere(
                                (message) => message.peerId == guardian,
                              );
                              return GuardianListTile(
                                guardian: guardian,
                                isSuccess: message.isAccepted
                                    ? true
                                    : message.hasResponse
                                        ? false
                                        : null,
                                isWaiting: message.hasNoResponse,
                                checkStatus: true,
                              );
                            },
                          ),
                  )
              ],
            ),
          ),
        ],
      );

  void _showTerminated(final MessageModel message) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (final BuildContext context) => BottomSheetWidget(
          icon: const IconOf.secretRestoration(
            isBig: true,
            bage: BageType.error,
          ),
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
