import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/ui/widgets/guardian_list_tile.dart';

import '../vault_secret_add_presenter.dart';
import '../widgets/abort_header_button.dart';
import '../dialogs/on_success_dialog.dart';
import '../dialogs/on_reject_dialog.dart';
import '../dialogs/on_fail_dialog.dart';

class SecretTransmittingPage extends StatefulWidget {
  const SecretTransmittingPage({super.key});

  @override
  State<SecretTransmittingPage> createState() => _SecretTransmittingPageState();
}

class _SecretTransmittingPageState extends State<SecretTransmittingPage> {
  late final _theme = Theme.of(context);
  @override
  void initState() {
    super.initState();
    context.read<VaultSecretAddPresenter>().startRequest().then(
      (message) async {
        if (!mounted) return;
        if (message.isAccepted) {
          await OnSuccessDialog.show(context);
        } else if (message.isRejected) {
          await OnRejectDialog.show(context, vaultName: message.vaultId.name);
        } else {
          await OnFailDialog.show(context);
        }
        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          // Header
          const HeaderBar(
            caption: 'Adding a Secret',
            closeButton: AbortHeaderButton(),
          ),
          // Body
          Expanded(
            child: ListView(
              padding: paddingH20,
              children: [
                // Title
                const PageTitle(
                  title: 'Awaiting Guardians',
                ),
                // Warning
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0x26F19C38),
                  ),
                  padding: paddingAll20,
                  child: const Text(
                    'Do not exit or minimize the app until the end of the '
                    'process, as you are connected via peer-to-peer (P2P), '
                    'and doing so could disrupt the progress.',
                    style: TextStyle(color: clYellow),
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  child: Padding(
                    padding: paddingT20,
                    child: Consumer<VaultSecretAddPresenter>(
                      builder: (context, presenter, _) => Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: paddingH20,
                            child: Text(
                              'Guardians',
                              style: styleSourceSansPro616,
                            ),
                          ),
                          Padding(
                            padding: paddingH20,
                            child: Text(
                              'Ask Guardians to open the app and accept a '
                              'Secret Shard. Make sure they keep the app open '
                              'until the Shard splitting is complete.',
                              style: _theme.textTheme.bodySmall,
                            ),
                          ),
                          for (final message in presenter.messages)
                            message.peerId == presenter.selfId
                                ? const GuardianListTile.my()
                                : message.isAccepted
                                    ? GuardianListTile(
                                        guardian: message.peerId,
                                      )
                                    : GuardianListTile.pending(
                                        guardian: message.peerId,
                                      ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
