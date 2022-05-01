import 'package:flutter/material.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';

import 'pages/device_name_page.dart';
import 'widgets/hidden_card_widget.dart';
import 'widgets/set_pincode_widget.dart';

class SettingsView extends StatelessWidget {
  static const routeName = '/settings';
  static const secretsConfig = SetPinCodeWidget.secretsConfig;

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
                const Padding(
                  padding: paddingH20V1,
                  child: SetPinCodeWidget(),
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
