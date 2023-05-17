import 'package:guardian_keyper/ui/widgets/common.dart';

import '../vault_secret_add_presenter.dart';
import '../../widgets/guardian_self_list_tile.dart';
import '../../widgets/guardian_list_tile.dart';
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
  late final _presenter = context.read<VaultSecretAddPresenter>();

  @override
  void initState() {
    super.initState();
    _presenter.startRequest().then((message) async {
      if (message.isAccepted) {
        await OnSuccessDialog.show(context, vaultId: message.vaultId);
      } else if (message.isRejected) {
        await OnRejectDialog.show(context, vaultId: message.vaultId);
      } else {
        await OnFailDialog.show(context, vaultId: message.vaultId);
      }
      if (context.mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          // Header
          const HeaderBar(
            caption: 'Split Secret',
            closeButton: AbortHeaderButton(),
          ),
          // Body
          Expanded(
            child: ListView(
              padding: paddingH20,
              children: [
                const PageTitle(
                  title: 'Waiting for Guardians',
                  subtitleSpans: [
                    TextSpan(
                      text: 'Ask each Guardian to log into the app '
                          'to receive a Secret Shard. Once Shard is received '
                          'Guardian icon will go ',
                    ),
                    TextSpan(
                      text: 'green.',
                      style: TextStyle(color: clGreen),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final guardian
                        in _presenter.messages.map((e) => e.peerId))
                      Padding(
                        padding: paddingV6,
                        child: _presenter.isMyself(guardian)
                            ? GuardianSelfListTile(guardian: guardian)
                            : Consumer<VaultSecretAddPresenter>(
                                builder: (_, presenter, __) {
                                  final message =
                                      presenter.getMessageOf(guardian);
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
              ],
            ),
          ),
        ],
      );
}
