import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

import '/src/core/consts.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/ui/widgets/icon_of.dart';
import '/src/core/data/core_model.dart';

import '../vault_add_guardian_controller.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late final _controller = context.read<VaultAddGuardianController>()
    ..startRequest(
      onSuccess: _onSuccess,
      onRejected: _onRejected,
      onFailed: _onFailed,
      onDuplicate: _onDuplicate,
      onAppVersion: _onAppVersion,
    );

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
                    child: Selector<VaultAddGuardianController, bool>(
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
                          id: _controller.qrCode!.peerId,
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
        builder: (final BuildContext context) => BottomSheetWidget(
          titleString: 'Request has been rejected',
          textString: 'Guardian rejected your request to join Vault.',
          icon: const IconOf.shield(isBig: true, bage: BageType.error),
          footer: PrimaryButton(
            text: 'Close',
            onPressed: Navigator.of(context).pop,
          ),
        ),
      ).then(Navigator.of(context).pop);

  void _onDuplicate(MessageModel qrCode) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (final BuildContext context) => BottomSheetWidget(
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
        (_) => Navigator.of(context).popAndPushNamed(routeGroupAddGuardian),
      );

  void _onFailed([MessageModel? qrCode]) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (final BuildContext context) => BottomSheetWidget(
          titleString: 'Invalid Code',
          textString: 'Seems like the Code you’ve just used is not valid. '
              'Ask Guardian to share a new code.',
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
        builder: (final BuildContext context) => qrCode.version <
                MessageModel.currentVersion
            ? BottomSheetWidget(
                icon: const IconOf.shield(isBig: true, bage: BageType.error),
                titleString: 'Guardian’s app is outdated',
                textString: 'Seems like your Guardian is using the older '
                    'version of the Guardian Keyper. Ask them to update the app.',
                footer: PrimaryButton(
                  text: 'Close',
                  onPressed: Navigator.of(context).pop,
                ),
              )
            : BottomSheetWidget(
                icon: const IconOf.shield(isBig: true, bage: BageType.error),
                titleString: 'Update the app',
                textString: 'Seems like your Guardian is using the latest '
                    'version of the Guardian Keyper. Please update the app.',
                footer: Column(
                  children: [
                    PrimaryButton(
                      text: 'Close',
                      onPressed: Navigator.of(context).pop,
                    ),
                    const Padding(padding: paddingTop20),
                    TertiaryButton(
                      text: 'Update',
                      onPressed: () async => await launchUrl(Uri.parse(
                        Platform.isAndroid
                            ? 'https://play.google.com/store/apps/details?id=com.guardianlabs.keyper'
                            : 'https://apps.apple.com/ua/app/guardian-keyper/id1637977332',
                      )),
                    )
                  ],
                ),
              ),
      ).then(Navigator.of(context).pop);
}
