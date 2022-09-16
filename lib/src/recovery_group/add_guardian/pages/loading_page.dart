import 'dart:async';
import 'package:wakelock/wakelock.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

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
    final controller = context.read<AddGuardianController>();
    if (controller.qrCode == null ||
        controller.qrCode!.createdAt
            .add(controller.globals.qrCodeExpires)
            .isAfter(DateTime.now())) {
      Future.microtask(_showErrorFailed);
      return;
    }
    if (controller.isDuplicate) {
      Future.microtask(_showErrorDuplicate);
      return;
    }
    controller.startRequest(
      onRejected: _showRejected,
      onFailed: _showErrorFailed,
    );
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AddGuardianController>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        const HeaderBar(
          caption: 'Add Guardians',
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
                  'Awaiting ${controller.qrCode?.peerName}’s response',
                  style: textStyleSourceSansPro416,
                ),
              ),
            ],
          )),
        ),
      ],
    );
  }

  void _showRejected([_]) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (BuildContext context) => BottomSheetWidget(
          titleString: 'Guardian rejected',
          textString: 'Guardian has rejected the invitation to your '
              'Recovery Group. You can try again or add another Guardian.',
          icon: const IconOf.shield(isBig: true, bage: BageType.error),
          footer: PrimaryButton(
            text: 'Done',
            onPressed: Navigator.of(context).pop,
          ),
        ),
      ).then(Navigator.of(context).pop);

  void _showErrorDuplicate() => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (BuildContext context) => BottomSheetWidget(
          titleString: 'You can’t add the same Guardian twice',
          textString: 'Seems like this Guardian you’ve already added.'
              ' Try adding a different Guardian. ',
          icon: const IconOf.shield(isBig: true, bage: BageType.error),
          footer: PrimaryButton(
            text: 'Done',
            onPressed: Navigator.of(context).pop,
          ),
        ),
      ).then(Navigator.of(context).pop);

  void _showErrorFailed([_]) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (BuildContext context) => BottomSheetWidget(
          titleString: 'Invalid QR Code',
          textString:
              'Please ask the Guardian to generate a new QR Code via dashboard. ',
          icon: const IconOf.shield(isBig: true, bage: BageType.error),
          footer: PrimaryButton(
            text: 'Done',
            onPressed: Navigator.of(context).pop,
          ),
        ),
      ).then(Navigator.of(context).pop);
}
