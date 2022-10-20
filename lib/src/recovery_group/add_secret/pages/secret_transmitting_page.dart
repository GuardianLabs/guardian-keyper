import 'package:wakelock/wakelock.dart';

import '/src/core/di_container.dart';
import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/model/core_model.dart';

import '../add_secret_controller.dart';
import '../widgets/add_secret_close_button.dart';
import '../../widgets/guardian_tile_widget.dart';

class SecretTransmittingPage extends StatefulWidget {
  const SecretTransmittingPage({super.key});

  @override
  State<SecretTransmittingPage> createState() => _SecretTransmittingPageState();
}

class _SecretTransmittingPageState extends State<SecretTransmittingPage> {
  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    context.read<AddSecretController>().startRequest(
          onSuccess: _showSuccess,
          onReject: _showRejected,
          onFailed: _showRejected, // TBD: specify
        );
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AddSecretController>(context);
    return Column(
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
                  for (final guardian in controller.group.guardians.keys)
                    Padding(
                      padding: paddingV6,
                      child: StreamBuilder<MessageModel>(
                        initialData: null,
                        stream: controller.messagesStream.where(
                          (message) => message.peerId == guardian,
                        ),
                        builder: (context, snapshot) => GuardianTileWidget(
                          guardian: guardian,
                          isSuccess: snapshot.data?.isAccepted,
                          isWaiting: snapshot.data == null,
                          checkStatus: true,
                        ),
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

  void _showSuccess(MessageModel message) => showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (context) => BottomSheetWidget(
          icon: const IconOf.splitAndShare(isBig: true, bage: BageType.ok),
          titleString: 'Your Secret has been split',
          textSpan: [
            const TextSpan(text: 'Now you can restore your '),
            TextSpan(
              text: message.groupId.name,
              style: textStyleBold,
            ),
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
        builder: (context) => BottomSheetWidget(
          icon: const IconOf.splitAndShare(isBig: true, bage: BageType.error),
          titleString:
              'Guardian rejected your Secret. The Secret will be removed.',
          textSpan: [
            const TextSpan(text: 'Sharding process for '),
            TextSpan(
              text: message.groupId.name,
              style: textStyleBold,
            ),
            const TextSpan(
              text: ' has been terminated by one of your Guardians.',
            ),
          ],
          footer: Padding(
            padding: paddingV20,
            child: PrimaryButton(
              text: 'Done',
              onPressed: () => context
                  .read<DIContainer>()
                  .boxRecoveryGroups
                  .delete(message.groupId.asKey)
                  .then(
                    (_) => Navigator.of(context).popUntil((r) => r.isFirst),
                  ),
            ),
          ),
        ),
      );
}
