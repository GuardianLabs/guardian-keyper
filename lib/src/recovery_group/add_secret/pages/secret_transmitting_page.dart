import 'package:wakelock/wakelock.dart';
import 'package:amplitude_flutter/amplitude.dart';

import '/src/core/di_container.dart';
import '/src/core/theme_data.dart';
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
                          'Guardian icon will go '),
                  TextSpan(
                    text: 'green.',
                    style: TextStyle(color: clGreen),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var guardian in controller.group.guardians.values)
                    Padding(
                      padding: paddingV6,
                      child: GuardianTileWidget(
                        guardian: guardian,
                        isSuccess: controller.responses[guardian.peerId] == null
                            ? null
                            : controller.responses[guardian.peerId] ==
                                MessageStatus.accepted,
                        isWaiting:
                            !controller.responses.containsKey(guardian.peerId),
                        isOnline: controller.statuses[guardian.peerId] ?? false,
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
              text: message.secretShard.groupName,
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
              'Guardian rejected your Secret. The group will be removed.',
          textSpan: [
            const TextSpan(text: 'Sharding process for '),
            TextSpan(text: message.secretShard.groupName, style: textStyleBold),
            const TextSpan(
                text: ' has been terminated by one of you Guardians.'),
          ],
          footer: Padding(
            padding: paddingV20,
            child: PrimaryButton(
              text: 'Done',
              onPressed: () async {
                await context
                    .read<DIContainer>()
                    .boxRecoveryGroup
                    .delete(message.secretShard.groupId.asKey);
                await Amplitude.getInstance().logEvent('Finish CreateGroup');
                if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
              },
            ),
          ),
        ),
      );
}
