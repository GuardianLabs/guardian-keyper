import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/misc.dart';
import '/src/core/widgets/icon_of.dart';

import '../restore_group_controller.dart';

class ExplainerPage extends StatelessWidget {
  const ExplainerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        const HeaderBar(
          caption: 'Restore Group',
          closeButton: HeaderBarCloseButton(),
        ),
        // Body
        Expanded(
          child: ListView(
            children: [
              // Icon
              const Padding(
                padding: paddingAll20,
                child: IconOf.restoreGroup(radius: 40, size: 40),
              ),
              // Caption
              Padding(
                padding: paddingTop20,
                child: Text(
                  'Ownership Transfer',
                  style: textStylePoppinsBold20,
                  textAlign: TextAlign.center,
                ),
              ),
              // Text
              Padding(
                padding: paddingAll20,
                child: Text(
                  _screenText,
                  textAlign: TextAlign.center,
                  style: textStyleSourceSansProRegular16,
                ),
              ),
              // Numbered List
              Padding(
                padding: paddingAll20,
                child: Container(
                  alignment: Alignment.center,
                  padding: paddingH20V10,
                  decoration: boxDecoration,
                  child: const NumberedListWidget(list: _screenList),
                ),
              ),
            ],
          ),
        ),
        // Footer
        Padding(
          padding: paddingAll20,
          child: PrimaryButtonBig(
            text: 'Show QR Code',
            onPressed: context.read<RestoreGroupController>().nextScreen,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

const _screenText =
    'Lost access to your device used to store your\nsecrets? No problem, you can restore access\nfor each recovery group here.';
const _screenList = [
  'Now ask each of your Guardians within the group to open their Guardian app',
  'They must select your group',
  'Direct them to click "Change Owner"',
  'Show them your QR code',
];
