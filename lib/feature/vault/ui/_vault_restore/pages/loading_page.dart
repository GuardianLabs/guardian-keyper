import 'package:guardian_keyper/app/routes.dart';
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
    context.read<VaultRestorePresenter>().startRequest().then(
      (message) async {
        if (!mounted) return;
        if (message.isAccepted) {
          final wantAddAnother = await OnSuccessDialog.show(
            context,
            peerName: message.peerId.name,
            vaultId: message.vault.id,
            hasQuorum: message.vault.hasQuorum,
            isFull: message.vault.isFull,
          );
          if (mounted) {
            return wantAddAnother ?? false
                ? Navigator.of(context).pushReplacementNamed(
                    routeVaultRestore,
                    arguments: message.vaultId,
                  )
                : Navigator.of(context).pop();
          }
        } else if (message.isRejected) {
          await OnRejectDialog.show(
            context,
            peerId: message.peerId.name,
          );
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
          title: const Text('Restoring your Safe'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Body
            const Padding(padding: paddingT12),
            Padding(
              padding: paddingAllDefault,
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: paddingTDefault,
                      child: Selector<VaultRestorePresenter, bool>(
                        selector: (_, presenter) => presenter.isWaiting,
                        builder: (_, isWaiting, __) => Visibility(
                          visible: isWaiting,
                          child: const CircularProgressIndicator.adaptive(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: paddingAllDefault,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(text: 'Awaiting '),
                            TextSpan(
                              text: context
                                  .read<VaultRestorePresenter>()
                                  .qrCode!
                                  .peerId
                                  .name,
                              style: styleW600,
                            ),
                            const TextSpan(text: '’s response'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
