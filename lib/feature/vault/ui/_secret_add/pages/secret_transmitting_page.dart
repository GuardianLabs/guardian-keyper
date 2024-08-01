import 'package:guardian_keyper/feature/vault/ui/_secret_add/dialogs/on_abort_dialog.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/theme/brand_colors.dart';

import 'package:guardian_keyper/feature/vault/ui/widgets/guardian_list_tile.dart';

import '../vault_secret_add_presenter.dart';
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
  late final _brandColor = _theme.extension<BrandColors>()!;

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
        if (mounted) Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) => ScaffoldSafe(
    appBar: AppBar(
      title: const Text('Awaiting Guardians'),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () async {
                    final wantExit = await OnAbortDialog.show(context);
                    if ((wantExit ?? false) && context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
      ),
    ),
    child: Column(
          children: [
            // Body
            Expanded(
              child: ListView(
                padding: paddingH20,
                children: [
                  // Warning
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: _brandColor.warningColor.withOpacity(.2),
                    ),
                    padding: paddingAll20,
                    child: Text(
                      'Keep the app open and active throughout the process, '
                      'as closing or minimizing it will disrupt the peer-to-peer (P2P) '
                      'connection and reset progress.',
                      style: TextStyle(color: _theme.colorScheme.onError),
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
                                style: _theme.textTheme.bodyMedium,
                              ),
                            ),
                            Padding(
                              padding: paddingH20,
                              child: Text(
                                'Ask your Guardians to open the app and accept a '
                                'Secret shard. Make sure they keep the app open '
                                'until the shard splitting is complete.',
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
