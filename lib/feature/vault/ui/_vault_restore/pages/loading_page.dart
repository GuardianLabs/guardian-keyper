import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/utils/utils.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../vault_restore_presenter.dart';
import '../dialogs/on_success_dialog.dart';
import '../dialogs/on_reject_dialog.dart';
import '../dialogs/on_fail_dialog.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    context.read<VaultRestorePresenter>().startRequest().then((message) async {
      if (message.isAccepted) {
        final wantAddAnother = await OnSuccessDialog.show(
          context,
          peerId: message.peerId,
          vault: message.vault,
        );
        if (context.mounted) {
          wantAddAnother ?? false
              ? Navigator.of(context).pushReplacementNamed(
                  routeVaultRestore,
                  arguments: message.vaultId,
                )
              : Navigator.of(context).pop();
          return;
        }
      }

      if (context.mounted) {
        message.isRejected
            ? await OnRejectDialog.show(
                context,
                peerId: message.peerId,
                vaultId: message.vaultId,
              )
            : await OnFailDialog.show(context);
      }

      if (context.mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const HeaderBar(
            caption: 'Restore a Vault',
            closeButton: HeaderBarCloseButton(),
          ),
          // Body
          const Padding(padding: paddingT32),
          Padding(
            padding: paddingH20,
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: paddingT20,
                    child: Selector<VaultRestorePresenter, bool>(
                      selector: (_, presenter) => presenter.isWaiting,
                      builder: (_, isWaiting, __) => Visibility(
                        visible: isWaiting,
                        child: const CircularProgressIndicator.adaptive(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: paddingAll20,
                    child: RichText(
                      text: TextSpan(
                        style: styleSourceSansPro416,
                        children: buildTextWithId(
                          leadingText: 'Awaiting ',
                          name: context
                              .read<VaultRestorePresenter>()
                              .qrCode!
                              .peerId
                              .name,
                          trailingText: '’s response',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
