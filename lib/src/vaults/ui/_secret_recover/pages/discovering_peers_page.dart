import 'package:guardian_keyper/src/core/ui/widgets/common.dart';
import 'package:guardian_keyper/src/message/domain/message_model.dart';

import '../presenters/vault_secret_recover_presenter.dart';
import '../../widgets/guardian_self_list_tile.dart';
import '../../widgets/guardian_list_tile.dart';
import '../dialogs/on_reject_dialog.dart';

class DiscoveryPeersPage extends StatefulWidget {
  const DiscoveryPeersPage({super.key});

  @override
  State<DiscoveryPeersPage> createState() => _DiscoveryPeersPageState();
}

class _DiscoveryPeersPageState extends State<DiscoveryPeersPage> {
  late final _presenter = context.read<VaultSecretRecoverPresenter>();

  @override
  void initState() {
    super.initState();
    _presenter.startRequest().then(_handleResponse);
  }

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
                          'You need to get at least ${_presenter.needAtLeast}'
                          ' approvals from Guardians to recover your Secret.',
                          style: textStyleSourceSansPro414Purple,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
                  ),
                ),
                // Guardians
                for (final guardian in _presenter.vault.guardians.keys)
                  Padding(
                    padding: paddingV6,
                    child: guardian == _presenter.vault.ownerId
                        ? GuardianSelfListTile(guardian: guardian)
                        : Consumer<VaultSecretRecoverPresenter>(
                            builder: (_, presenter, __) {
                              final message = presenter.getMessageOf(guardian);
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

  void _handleResponse(final MessageModel message) async {
    if (message.isRejected) {
      await OnRejectDialog.show(context, message);
      if (context.mounted) Navigator.of(context).pop();
    }
  }
}
