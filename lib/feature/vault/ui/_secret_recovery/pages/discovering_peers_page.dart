import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/ui/widgets/guardian_list_tile.dart';

import '../vault_secret_recovery_presenter.dart';
import '../dialogs/on_reject_dialog.dart';

class DiscoveringPeersPage extends StatefulWidget {
  const DiscoveringPeersPage({super.key});

  @override
  State<DiscoveringPeersPage> createState() => _DiscoveringPeersPageState();
}

class _DiscoveringPeersPageState extends State<DiscoveringPeersPage> {
  late final _theme = Theme.of(context);
  late final _presenter = context.read<VaultSecretRecoveryPresenter>();

  @override
  void initState() {
    super.initState();
    _presenter.startRequest().then((message) async {
      if (message.isRejected) {
        await OnRejectDialog.show(context, vaultName: message.vaultId.name);
        if (context.mounted) Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          // Header
          const HeaderBar(
            caption: 'Secret Recovery',
            rightButton: HeaderBarButton.close(),
          ),
          // Body
          Expanded(
            child: ListView(
              padding: paddingH20,
              children: [
                // Title
                const PageTitle(
                  title: 'Awaiting Guardians',
                  subtitle: 'Ask your Guardians to open the app and approve '
                      'a secret recovery. Once you get enough approvals, '
                      'the button will become active.',
                ),
                // Guardians
                Card(
                  child: Padding(
                    padding: paddingT20,
                    child: Consumer<VaultSecretRecoveryPresenter>(
                      builder: (context, presenter, _) => Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: paddingH20,
                            child: Text(
                              'Approvals',
                              style: _theme.textTheme.bodyMedium,
                            ),
                          ),
                          Padding(
                            padding: paddingH20,
                            child: Text(
                              'Get at least ${_presenter.needAtLeast}'
                              ' approvals to access your Secret.',
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
