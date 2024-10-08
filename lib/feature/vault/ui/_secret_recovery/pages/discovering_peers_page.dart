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
        if (mounted) {
          await OnRejectDialog.show(context, vaultName: message.vaultId.name);
        }
        if (mounted) Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) => ScaffoldSafe(
        appBar: AppBar(
          title: const Text('Secret recovery'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        child: Column(
          children: [
            // Body
            Expanded(
              child: ListView(
                padding: paddingHDefault,
                children: [
                  // Title
                  const PageTitle(
                    subtitle: 'Ask your Guardians to open the app and approve '
                        'a secret recovery. Once you get enough approvals, '
                        'the button will become active.',
                  ),
                  // Guardians
                  Card(
                    child: Padding(
                      padding: paddingTDefault,
                      child: Consumer<VaultSecretRecoveryPresenter>(
                        builder: (context, presenter, _) => Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: paddingHDefault,
                              child: Text(
                                'Approvals',
                                style: _theme.textTheme.bodyMedium,
                              ),
                            ),
                            Padding(
                              padding: paddingHDefault,
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
        ),
      );
}
