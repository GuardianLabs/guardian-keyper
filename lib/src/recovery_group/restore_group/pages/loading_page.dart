import 'package:wakelock/wakelock.dart';

import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/model/core_model.dart';

import '../restore_group_controller.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    context.read<RestoreGroupController>().startRequest(
          onSuccess: _showSuccess,
          onReject: _showRejected,
          onDuplicate: _showDuplicated,
          onFail: _showError,
        );
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RestoreGroupController>(context);
    return Column(
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
                  child: Visibility(
                    visible: controller.isWaiting,
                    child: const CircularProgressIndicator.adaptive(),
                  ),
                ),
                Padding(
                  padding: paddingAll20,
                  child: Text(
                    'Awaiting ${controller.qrCode!.peerId.name}’s response',
                    style: textStyleSourceSansPro416,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showSuccess(MessageModel message) {
    final count = message.recoveryGroup.maxSize - message.recoveryGroup.size;
    count == 0
        ? showModalBottomSheet(
            context: context,
            isDismissible: false,
            isScrollControlled: true,
            builder: (context) => BottomSheetWidget(
              icon: const IconOf.secrets(isBig: true, bage: BageType.ok),
              titleString: 'Ownership Changed',
              textSpan: [
                const TextSpan(text: 'The ownership of the Vault '),
                TextSpan(
                  text: message.groupId.name,
                  style: textStyleBold,
                ),
                const TextSpan(text: ' has been transferred to your device.'),
              ],
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
            builder: (context) => BottomSheetWidget(
              icon: const IconOf.secrets(isBig: true, bage: BageType.ok),
              titleString: 'Ownership Transfer Approved',
              textSpan: [
                TextSpan(
                  text: message.peerId.name,
                  style: textStyleBold,
                ),
                const TextSpan(
                  text: ' approved the transfer of ownership for the Vault ',
                ),
                TextSpan(
                  text: message.groupId.name,
                  style: textStyleBold,
                ),
              ],
              body: Padding(
                padding: paddingV20,
                child: Container(
                  decoration: boxDecoration,
                  padding: paddingAll20,
                  child: Text(
                    'Get $count more approvals from other Guardians '
                    'of the Vault to finish the restoration.',
                    style: textStyleSourceSansPro416,
                  ),
                ),
              ),
              footer: PrimaryButton(
                text: 'Scan New QR Code',
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed(
                    '/recovery_group/restore',
                    arguments: true,
                  );
                },
              ),
            ),
          );
  }

  void _showRejected(MessageModel message) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (context) => BottomSheetWidget(
          icon: const IconOf.secrets(isBig: true, bage: BageType.error),
          titleString: 'Ownership Transfer Rejected',
          textSpan: [
            TextSpan(
              text: message.peerId.name,
              style: textStyleBold,
            ),
            const TextSpan(
              text: ' rejected the transfer of ownership for the Vault ',
            ),
            TextSpan(
              text: message.groupId.name,
              style: textStyleBold,
            ),
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

  void _showDuplicated(MessageModel message) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (context) => BottomSheetWidget(
          icon: const IconOf.secrets(isBig: true, bage: BageType.error),
          titleString: 'Ownership Transfer Failed',
          textString: 'You are the owner of this Vault already!',
          footer: PrimaryButton(
            text: 'Close',
            onPressed: Navigator.of(context).pop,
          ),
        ),
      ).then(Navigator.of(context).pop);

  void _showError(MessageModel message) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (context) => BottomSheetWidget(
          icon: const IconOf.secrets(isBig: true, bage: BageType.error),
          titleString: 'Ownership Transfer Failed',
          textString:
              'We couldn’t finish scanning the QR Code.\nPlease try again.',
          footer: PrimaryButton(
            text: 'Scan QR Code Again',
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(
                '/recovery_group/restore',
                arguments: true,
              );
            },
          ),
        ),
      );
}
