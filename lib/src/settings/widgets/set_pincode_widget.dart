import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/settings/settings_controller.dart';

class SetPinCodeWidget extends StatelessWidget {
  static const secretsConfig = SecretsConfig(
      secretConfig: SecretConfig(
    borderSize: 0,
    borderColor: Colors.transparent,
    disabledColor: Colors.white38,
    enabledColor: Colors.white,
  ));

  const SetPinCodeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.lock_open_rounded),
      title: Text(
        'Passcode',
        style: textStylePoppinsBold16,
      ),
      subtitle: Text(
        'Change authentication passcode',
        style: textStyleSourceSansProRegular14.copyWith(color: clPurpleLight),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      onTap: () => context.read<SettingsController>().pinCode.isEmpty
          ? enterNewPincode(context)
          : enterCurrentPincode(context),
    );
  }

  void enterCurrentPincode(BuildContext context, {bool canCancel = true}) {
    return screenLock(
      context: context,
      correctString: context.read<SettingsController>().pinCode,
      canCancel: canCancel,
      digits: 6,
      secretsConfig: secretsConfig,
      inputButtonConfig: InputButtonConfig(buttonStyle: buttonStylePincode),
      title: PaddingBottom(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Please enter your current',
                style: textStylePoppinsBold20,
              ),
              TextSpan(
                text: ' passcode',
                style: textStylePoppinsBold20Blue,
              ),
            ],
          ),
        ),
      ),
      didUnlocked: () {
        Navigator.of(context).pop();
        if (canCancel) enterNewPincode(context);
      },
    );
  }

  void enterNewPincode(BuildContext context) {
    return screenLock(
        context: context,
        correctString: '',
        canCancel: true,
        confirmation: true,
        digits: 6,
        secretsConfig: secretsConfig,
        inputButtonConfig: InputButtonConfig(buttonStyle: buttonStylePincode),
        title: PaddingBottom(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Please create your new',
                  style: textStylePoppinsBold20,
                ),
                TextSpan(
                  text: ' passcode',
                  style: textStylePoppinsBold20Blue,
                ),
              ],
            ),
          ),
        ),
        confirmTitle: PaddingBottom(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Please repeate your new',
                  style: textStylePoppinsBold20,
                ),
                TextSpan(
                  text: ' passcode',
                  style: textStylePoppinsBold20Blue,
                ),
              ],
            ),
          ),
        ),
        didConfirmed: (value) {
          context.read<SettingsController>().setPinCode(value);
          Navigator.of(context).pop();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => BottomSheetWidget(
              icon: const IconOf.secrets(
                radius: 40,
                size: 40,
                bage: BageType.ok,
              ),
              titleString: 'Passcode changed',
              textString: 'Your login passcode was\nchanged successfully.',
              footer: PrimaryButtonBig(
                text: 'Done',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          );
        });
  }
}
