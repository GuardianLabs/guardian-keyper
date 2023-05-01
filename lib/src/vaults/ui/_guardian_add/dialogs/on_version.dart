import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/src/core/ui/widgets/common.dart';
import 'package:guardian_keyper/src/core/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

import '../../../domain/vault_interactor.dart';

class OnVersionDialog extends StatelessWidget {
  static Future<void> show(
    final BuildContext context,
    final MessageModel message,
  ) =>
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (final BuildContext context) =>
            OnVersionDialog(message: message),
      );

  const OnVersionDialog({super.key, required this.message});

  final MessageModel message;

  @override
  Widget build(final BuildContext context) =>
      message.version < MessageModel.currentVersion
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
                    onPressed: GetIt.I<VaultInteractor>().openMarket,
                  )
                ],
              ),
            );
}
