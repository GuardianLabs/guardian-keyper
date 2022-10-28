import 'package:wakelock/wakelock.dart';

import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/model/core_model.dart';

import '../add_guardian_controller.dart';

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
    Future.microtask(
      () => context.read<AddGuardianController>().startRequest(
            onSuccess: _onSuccess,
            onRejected: _onRejected,
            onFailed: _onFailed,
            onDuplicate: _onDuplicate,
            onAppVersion: _onAppVersion,
          ),
    );
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final peerId = context.read<AddGuardianController>().qrCode!.peerId;
    return Column(
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
                  child: Selector<AddGuardianController, bool>(
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
                      style: textStyleSourceSansPro616,
                      children: buildTextWithId(
                        leadingText: 'Awaiting ',
                        id: peerId,
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

  void _onSuccess(MessageModel message) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      buildSnackBar(
        textSpans: [
          ...buildTextWithId(
            id: message.peerId,
            leadingText: 'You have successfully added ',
          ),
          ...buildTextWithId(
            id: message.groupId,
            leadingText: 'as a Guardian for ',
          ),
        ],
      ),
    );
  }

  void _onRejected([MessageModel? qrCode]) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (BuildContext context) => BottomSheetWidget(
          titleString: 'Guardian rejected',
          textString: 'Guardian has rejected the invitation to your Vault.'
              ' You can try again or add another Guardian.',
          icon: const IconOf.shield(isBig: true, bage: BageType.error),
          footer: PrimaryButton(
            text: 'Done',
            onPressed: Navigator.of(context).pop,
          ),
        ),
      ).then(Navigator.of(context).pop);

  void _onDuplicate(MessageModel qrCode) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (BuildContext context) => BottomSheetWidget(
          titleString: 'You can’t add the same Guardian twice',
          textSpan: [
            const TextSpan(text: 'Seems like you’ve already added '),
            ...buildTextWithId(id: qrCode.peerId, style: textStyleBold),
            const TextSpan(
              text: ' to this Vault. Try adding a different Guardian.',
            ),
          ],
          icon: const IconOf.shield(isBig: true, bage: BageType.error),
          footer: PrimaryButton(
            text: 'Add another Guardian',
            onPressed: Navigator.of(context).pop,
          ),
        ),
      ).then(
        (_) => Navigator.of(context)
            .popAndPushNamed('/recovery_group/add_guardian'),
      );

  void _onFailed([MessageModel? qrCode]) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (BuildContext context) => BottomSheetWidget(
          titleString: 'Invalid QR Code',
          textString:
              'Please ask the Guardian to generate a new QR Code via dashboard.',
          icon: const IconOf.shield(isBig: true, bage: BageType.error),
          footer: PrimaryButton(
            text: 'Done',
            onPressed: Navigator.of(context).pop,
          ),
        ),
      ).then(Navigator.of(context).pop);

  void _onAppVersion(MessageModel qrCode) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (BuildContext context) => BottomSheetWidget(
          titleString: qrCode.version < MessageModel.currentVersion
              ? 'Guardian’s app is outdated'
              : 'Update the app',
          textString: qrCode.version < MessageModel.currentVersion
              ? 'Seems like your Guardian is using the older version'
                  ' of the Guardian Keyper. Ask them to update the app.'
              : 'Seems like your Guardian is using the latest version'
                  ' of the Guardian Keyper. Please update the app.',
          icon: const IconOf.shield(isBig: true, bage: BageType.error),
          footer: PrimaryButton(
            text: 'Got it',
            onPressed: Navigator.of(context).pop,
          ),
        ),
      ).then(Navigator.of(context).pop);
}
