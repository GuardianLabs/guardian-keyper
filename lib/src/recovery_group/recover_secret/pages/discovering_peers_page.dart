import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';
import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

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
  void dispose() {
    _controller.stopListenResponse();
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
                        : StreamBuilder<MessageModel>(
                            stream: _controller.messagesStream
                                .where((message) => message.peerId == guardian),
                            builder: (_, snapshot) => GuardianListTile(
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

  void _showTerminated(MessageModel message) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (context) => BottomSheetWidget(
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
