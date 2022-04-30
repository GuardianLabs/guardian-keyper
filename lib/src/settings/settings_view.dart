import 'package:flutter/material.dart';
import 'package:guardian_network/src/core/widgets/icon_of.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/settings/settings_controller.dart';

import 'pages/device_name_page.dart';
// import 'pages/pincode_page.dart';
import 'widgets/hidden_card_widget.dart';

class SettingsView extends StatelessWidget {
  static const routeName = '/settings';
  static const secretsConfig = SecretsConfig(
      secretConfig: SecretConfig(
    borderSize: 0,
    borderColor: Colors.transparent,
    disabledColor: Colors.white38,
    enabledColor: Colors.white,
  ));

  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const HeaderBar(caption: 'Settings'),
            // Body
            ListView(
              primary: true,
              shrinkWrap: true,
              children: [
                Padding(
                  padding: paddingH20V5,
                  child: ListTile(
                    leading: const Icon(Icons.account_circle_outlined),
                    title: Text(
                      'Your Device Name',
                      style: textStylePoppinsBold16,
                    ),
                    subtitle: Text(
                      'Change your device name',
                      style: textStyleSourceSansProRegular14.copyWith(
                          color: clPurpleLight),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const DeviceNamePage())),
                  ),
                ),
                Padding(
                  padding: paddingH20V1,
                  child: ListTile(
                    leading: const Icon(Icons.lock_open_rounded),
                    title: Text(
                      'Passcode',
                      style: textStylePoppinsBold16,
                    ),
                    subtitle: Text(
                      'Change authentication passcode',
                      style: textStyleSourceSansProRegular14.copyWith(
                          color: clPurpleLight),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () => screenLock(
                      context: context,
                      correctString: context.read<SettingsController>().pinCode,
                      canCancel: true,
                      digits: 6,
                      secretsConfig: secretsConfig,
                      inputButtonConfig:
                          InputButtonConfig(buttonStyle: buttonStylePincode),
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
                        screenLock(
                            context: context,
                            correctString: '',
                            canCancel: true,
                            confirmation: true,
                            digits: 6,
                            secretsConfig: secretsConfig,
                            inputButtonConfig: InputButtonConfig(
                                buttonStyle: buttonStylePincode),
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
                              context
                                  .read<SettingsController>()
                                  .setPinCode(value);
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
                                  textString:
                                      'Your login passcode was\nchanged successfully.',
                                  footer: PrimaryButtonBig(
                                    text: 'Done',
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  ),
                ),
                const Padding(
                  padding: paddingAll20,
                  child: HiddenCardWidget(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
