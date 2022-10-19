import 'package:amplitude_flutter/amplitude.dart';
import 'package:wakelock/wakelock.dart';

import '/src/core/theme_data.dart';
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
          caption: 'Restore Group',
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
                  'Awaiting Guardian’s response',
                  style: textStyleSourceSansPro416,
                ),
              ),
            ],
          )),
        ),
      ],
    );
  }

  void _showSuccess(MessageModel message, RecoveryGroupModel group) {
    final controller = context.read<RestoreGroupController>();
    final count = group.maxSize - group.currentSize;
    count == 0 // is last Guardian
        ? showModalBottomSheet(
            context: context,
            isDismissible: false,
            isScrollControlled: true,
            builder: (BuildContext context) => BottomSheetWidget(
              icon: const IconOf.secrets(isBig: true, bage: BageType.ok),
              titleString: 'Ownership Changed',
              textSpan: [
                const TextSpan(text: 'The ownership of the group '),
                TextSpan(
                  text: message.secretShard.groupName,
                  style: textStyleBold,
                ),
                const TextSpan(text: ' has been transferred to your device.'),
              ],
              footer: PrimaryButton(
                text: 'Done',
                onPressed: () {
                  Amplitude.getInstance()
                      .logEvent('RestoreGroup Finish ');
                  Navigator.of(context).pop();
                },
              ),
            ),
          ).then(Navigator.of(context).pop)
        : showModalBottomSheet(
            context: context,
            isDismissible: false,
            isScrollControlled: true,
            useRootNavigator: true,
            builder: (BuildContext context) => BottomSheetWidget(
              icon: const IconOf.secrets(isBig: true, bage: BageType.ok),
              titleString: 'Ownership Transfer Approved',
              textSpan: [
                TextSpan(
                  text: message.secretShard.ownerName,
                  style: textStyleBold,
                ),
                const TextSpan(
                    text: ' approved the transfer of ownership for the group '),
                TextSpan(
                  text: message.secretShard.groupName,
                  style: textStyleBold,
                ),
              ],
              body: Padding(
                padding: paddingV20,
                child: Container(
                  decoration: boxDecoration,
                  padding: paddingAll20,
                  child: RichText(
                    text: TextSpan(
                      style: textStyleSourceSansPro416,
                      children: [
                        TextSpan(text: 'Get $count more approvals from other '),
                        TextSpan(
                          text: message.secretShard.groupName,
                          style: textStyleBold,
                        ),
                        const TextSpan(
                            text: ' Guardians to finish the restoration.'),
                      ],
                    ),
                  ),
                ),
              ),
              footer: PrimaryButton(
                text: 'Scan New QR Code',
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.scanAnotherCode();
                },
              ),
            ),
          );
  }

  void _showRejected(MessageModel message) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (BuildContext context) => BottomSheetWidget(
          icon: const IconOf.secrets(isBig: true, bage: BageType.error),
          titleString: 'Ownership Transfer Rejected',
          textSpan: [
            TextSpan(
              text: message.secretShard.ownerName,
              style: textStyleBold,
            ),
            const TextSpan(
                text: ' rejected the transfer of ownership for the group '),
            TextSpan(
              text: message.secretShard.groupName,
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
                'it is impossible to restore the Group.',
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
        builder: (BuildContext context) => BottomSheetWidget(
          icon: const IconOf.secrets(isBig: true, bage: BageType.error),
          titleString: 'Ownership Transfer Failed',
          textString: 'You are the owner of this Group already!',
          footer: PrimaryButton(
            text: 'Close',
            onPressed: Navigator.of(context).pop,
          ),
        ),
      ).then(Navigator.of(context).pop);

  void _showError(MessageModel message) {
    final controller = context.read<RestoreGroupController>();
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (BuildContext context) => BottomSheetWidget(
        icon: const IconOf.secrets(isBig: true, bage: BageType.error),
        titleString: 'Ownership Transfer Failed',
        textString:
            'We couldn’t finish scanning the QR Code.\nPlease try again.',
        footer: PrimaryButton(
          text: 'Scan QR Code Again',
          onPressed: () {
            Navigator.of(context).pop();
            controller.scanAnotherCode();
          },
        ),
      ),
    );
  }
}
