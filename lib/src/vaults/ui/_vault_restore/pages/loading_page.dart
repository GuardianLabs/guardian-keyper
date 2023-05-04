import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/ui/widgets/emoji.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';

import '../presenters/vault_restore_presenter.dart';
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
    context.read<VaultRestorePresenter>().startRequest().then(_handleResponse);
  }

  @override
  Widget build(final BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const HeaderBar(
            caption: 'Restore a Vault',
            closeButton: HeaderBarCloseButton(),
          ),
          // Body
          const Padding(padding: paddingTop32),
          Padding(
            padding: paddingH20,
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: paddingTop20,
                    child: Selector<VaultRestorePresenter, bool>(
                      selector: (
                        final BuildContext context,
                        final VaultRestorePresenter presenter,
                      ) =>
                          presenter.isWaiting,
                      builder: (
                        final BuildContext context,
                        final bool isWaiting,
                        final Widget? widget,
                      ) =>
                          Visibility(
                        visible: isWaiting,
                        child: const CircularProgressIndicator.adaptive(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: paddingAll20,
                    child: RichText(
                      text: TextSpan(
                        style: textStyleSourceSansPro416,
                        children: buildTextWithId(
                          leadingText: 'Awaiting ',
                          id: context
                              .read<VaultRestorePresenter>()
                              .qrCode!
                              .peerId,
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

  void _handleResponse(final MessageModel message) async {
    if (message.isAccepted) {
      await OnSuccessDialog.show(context, message);
      if (context.mounted) {
        message.vault.isFull
            ? Navigator.of(context).pop()
            : Navigator.of(context).pushReplacementNamed(
                routeVaultRestore,
                arguments: message.vaultId,
              );
      }
    } else if (message.isRejected) {
      await OnRejectDialog.show(context, message);
    } else {
      await OnFailDialog.show(context);
    }
    if (context.mounted) Navigator.of(context).pop();
  }
}
