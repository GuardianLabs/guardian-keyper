import '/src/core/app/consts.dart';
import '../../../../core/domain/core_model.dart';
import '/src/core/ui/widgets/emoji.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/ui/widgets/icon_of.dart';

import '../vault_add_secret_presenter.dart';
import '../widgets/add_secret_close_button.dart';
import '../../widgets/guardian_self_list_tile.dart';
import '../../widgets/guardian_list_tile.dart';

class SecretTransmittingPage extends StatefulWidget {
  const SecretTransmittingPage({super.key});

  @override
  State<SecretTransmittingPage> createState() => _SecretTransmittingPageState();
}

class _SecretTransmittingPageState extends State<SecretTransmittingPage> {
  late final _controller = context.read<VaultAddSecretPresenter>()
    ..startRequest(
      onSuccess: _showSuccess,
      onReject: _showRejected,
      onFailed: _showFailed,
    );

  @override
  Widget build(final BuildContext context) => Column(
        children: [
          // Header
          const HeaderBar(
            caption: 'Split Secret',
            closeButton: AddSecretCloseButton(),
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
                        in _controller.messages.map((e) => e.peerId))
                      Padding(
                        padding: paddingV6,
                        child: guardian == _controller.myPeerId
                            ? GuardianSelfListTile(guardian: guardian)
                            : Consumer<VaultAddSecretPresenter>(
                                builder: (_, controller, __) {
                                  final message =
                                      controller.messages.firstWhere(
                                    (message) => message.peerId == guardian,
                                  );
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

  void _showSuccess(MessageModel message) => showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (final BuildContext context) => BottomSheetWidget(
          icon: const IconOf.splitAndShare(isBig: true, bage: BageType.ok),
          titleString: 'Your Secret has been split',
          textSpan: [
            const TextSpan(text: 'Now you can restore your '),
            ...buildTextWithId(id: message.groupId, style: textStyleBold),
            const TextSpan(text: ' Secret with the help of Guardians.'),
          ],
          footer: Padding(
            padding: paddingV20,
            child: PrimaryButton(
              text: 'Done',
              onPressed: Navigator.of(context).pop,
            ),
          ),
        ),
      ).then(Navigator.of(context).pop);

  void _showRejected(MessageModel message) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (final BuildContext context) => BottomSheetWidget(
          icon: const IconOf.splitAndShare(isBig: true, bage: BageType.error),
          titleString:
              'Guardian rejected your Secret. The Secret will be removed.',
          textSpan: [
            const TextSpan(text: 'Sharding process for '),
            ...buildTextWithId(id: message.groupId, style: textStyleBold),
            const TextSpan(
              text: ' has been terminated by one of your Guardians.',
            ),
          ],
          footer: Padding(
            padding: paddingV20,
            child: PrimaryButton(
              text: 'Done',
              onPressed: () => Navigator.of(context)
                  .popUntil(ModalRoute.withName(routeVaultEdit)),
            ),
          ),
        ),
      );

  void _showFailed(MessageModel message) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (final BuildContext context) => BottomSheetWidget(
          icon: const IconOf.splitAndShare(isBig: true, bage: BageType.error),
          titleString: 'Something went wrong!',
          textSpan: [
            const TextSpan(text: 'Sharding process for '),
            ...buildTextWithId(id: message.groupId, style: textStyleBold),
            const TextSpan(text: ' has been terminated.'),
          ],
          footer: Padding(
            padding: paddingV20,
            child: PrimaryButton(
              text: 'Close',
              onPressed: () => Navigator.of(context)
                  .popUntil(ModalRoute.withName(routeVaultEdit)),
            ),
          ),
        ),
      );
}
