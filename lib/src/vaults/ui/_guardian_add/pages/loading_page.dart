import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/ui/widgets/emoji.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';
import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

import '../presenters/vault_guardian_add_presenter.dart';
import '../dialogs/on_duplicate_dialog.dart';
import '../dialogs/on_fail_dialog.dart';
import '../dialogs/on_version.dart';
import '../dialogs/on_reject.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late final _presenter = context.read<VaultGuardianAddPresenter>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _presenter.startRequest(
          onSuccess: (MessageModel message) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              buildSnackBar(
                textSpans: [
                  ...buildTextWithId(
                    id: message.peerId,
                    leadingText: 'You have successfully added ',
                  ),
                  ...buildTextWithId(
                    id: message.vaultId,
                    leadingText: 'as a Guardian for ',
                  ),
                ],
              ),
            );
          },
          onDuplicate: (final message) async {
            await OnDuplicateDialog.show(context, message);
            if (context.mounted) {
              Navigator.of(context).popAndPushNamed(
                routeVaultAddGuardian,
                arguments: _presenter.vaultId,
              );
            }
          },
          onFail: (final message) async {
            await OnFailDialog.show(context);
            if (context.mounted) Navigator.of(context).pop();
          },
          onReject: (final message) async {
            await OnRejectDialog.show(context);
            if (context.mounted) Navigator.of(context).pop();
          },
          onAppVersion: (final message) async {
            await OnVersionDialog.show(context, message);
            if (context.mounted) Navigator.of(context).pop();
          },
        ));
  }

  @override
  Widget build(final BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const HeaderBar(
            caption: 'Adding a Guardian',
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
                    child: Selector<VaultGuardianAddPresenter, bool>(
                      selector: (
                        final BuildContext context,
                        final VaultGuardianAddPresenter presenter,
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
                        style: textStyleSourceSansPro616,
                        children: buildTextWithId(
                          leadingText: 'Awaiting ',
                          id: _presenter.qrCode!.peerId,
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
