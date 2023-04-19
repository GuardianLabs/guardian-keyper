import '/src/core/app/consts.dart';
import '../../../../core/domain/entity/core_model.dart';
import '/src/core/ui/widgets/emoji.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/ui/widgets/icon_of.dart';

import '../vault_restore_presenter.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late final _controller = context.read<VaultRestorePresenter>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _controller.startRequest(
          onDuplicate: _showDuplicated,
          onSuccess: _showSuccess,
          onReject: _showRejected,
          onFail: _showError,
        ));
  }

  @override
  void dispose() {
    _controller.stopListenResponse();
    super.dispose();
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
                      selector: (_, controller) => controller.isWaiting,
                      builder: (_, isWaiting, indicator) => Visibility(
                        visible: isWaiting,
                        child: indicator!,
                      ),
                      child: const CircularProgressIndicator.adaptive(),
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

  void _showSuccess(final MessageModel message) =>
      message.recoveryGroup.missed == 0
          ? showModalBottomSheet(
              context: context,
              isDismissible: false,
              isScrollControlled: true,
              builder: (final BuildContext context) => BottomSheetWidget(
                icon: const IconOf.secrets(isBig: true, bage: BageType.ok),
                titleString: 'Ownership Changed',
                textSpan: buildTextWithId(
                  leadingText: 'The ownership of the Vault ',
                  id: message.groupId,
                  trailingText: ' has been transferred to your device.',
                ),
                footer: PrimaryButton(
                  text: 'Done',
                  onPressed: Navigator.of(context).pop,
                ),
              ),
            ).then(Navigator.of(context).pop)
          : showModalBottomSheet(
              context: context,
              isDismissible: false,
              isScrollControlled: true,
              useRootNavigator: true,
              builder: (final BuildContext context) => BottomSheetWidget(
                icon: const IconOf.secrets(isBig: true, bage: BageType.ok),
                titleString: 'Ownership Transfer Approved',
                textSpan: [
                  ...buildTextWithId(
                    id: message.peerId,
                    trailingText:
                        ' approved the transfer of ownership for the Vault ',
                  ),
                  ...buildTextWithId(id: message.groupId),
                ],
                footer: PrimaryButton(
                  text: 'Add another Guardian',
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed(
                      routeVaultRestore,
                      arguments: message.groupId,
                    );
                  },
                ),
              ),
            );

  void _showRejected(final MessageModel message) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (final BuildContext context) => BottomSheetWidget(
          icon: const IconOf.secrets(isBig: true, bage: BageType.error),
          titleString: 'Ownership Transfer Rejected',
          textSpan: [
            ...buildTextWithId(
              id: message.peerId,
              trailingText:
                  ' rejected the transfer of ownership for the Vault ',
            ),
            ...buildTextWithId(id: message.groupId),
          ],
          body: Padding(
            padding: paddingV20,
            child: Container(
              decoration: boxDecoration,
              padding: paddingAll20,
              child: Text(
                'Since Guardian rejected ownership transfer, '
                'it is impossible to restore the Vault.',
                style: textStyleSourceSansPro416Purple,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          footer: PrimaryButton(
            text: 'Close',
            onPressed: Navigator.of(context).pop,
          ),
        ),
      ).then(Navigator.of(context).pop);

  void _showDuplicated(final MessageModel message) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (final BuildContext context) => BottomSheetWidget(
          icon: const IconOf.owner(isBig: true),
          titleString: 'The Vault is yours',
          textString: 'Seems like you are the owner of the Vault already. '
              'No recovery required here.',
          footer: PrimaryButton(
            text: 'Close',
            onPressed: Navigator.of(context).pop,
          ),
        ),
      ).then(Navigator.of(context).pop);

  void _showError(final MessageModel message) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (final BuildContext context) => BottomSheetWidget(
          icon: const IconOf.secrets(isBig: true, bage: BageType.error),
          titleString: 'Ownership Transfer Failed',
          textString:
              'We couldn’t finish scanning the QR Code.\nPlease try again.',
          footer: PrimaryButton(
            text: 'Close',
            onPressed: Navigator.of(context).pop,
          ),
        ),
      ).then(Navigator.of(context).pop);
}
