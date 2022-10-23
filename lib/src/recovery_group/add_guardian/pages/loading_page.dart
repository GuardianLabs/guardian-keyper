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
            onRejected: _showRejected,
            onFailed: _showErrorFailed,
            onDuplicate: _showErrorDuplicate,
            onAppVersionError: _showErrorAppVersion,
          ),
    );
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
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
                      builder: (_, isWaiting, __) => Visibility(
                        visible: isWaiting,
                        child: const CircularProgressIndicator.adaptive(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: paddingAll20,
                    child: Text(
                      'Awaiting '
                      '${context.read<AddGuardianController>().qrCode!.peerId.nameEmoji}'
                      '’s response',
                      style: textStyleSourceSansPro416,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  void _showRejected([MessageModel? qrCode]) => showModalBottomSheet(
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

  void _showErrorDuplicate(MessageModel qrCode) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (BuildContext context) => BottomSheetWidget(
          titleString: 'You can’t add the same Guardian twice',
          textString:
              'Seems like you’ve already added ${qrCode.peerId.nameEmoji} '
              'to this Vault. Try adding a different Guardian.',
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

  void _showErrorFailed([MessageModel? qrCode]) => showModalBottomSheet(
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

  void _showErrorAppVersion(MessageModel qrCode) => showModalBottomSheet(
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
