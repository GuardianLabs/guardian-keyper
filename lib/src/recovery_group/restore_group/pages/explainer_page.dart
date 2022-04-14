import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme_data.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/icon_of.dart';

import '../restore_group_controller.dart';

class ExplainerPage extends StatelessWidget {
  static const _padding = EdgeInsets.only(top: 20);

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
                padding: _padding,
                child: IconOf.group(radius: 40),
              ),
              // Caption
              Padding(
                padding: _padding,
                child: Text(
                  'Ownership Transfer',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Text
              Padding(
                padding: _padding,
                child: Text(
                  _screenText,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Numbered List
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: clIndigo700,
                  ),
                  child: const NumberedListWidget(list: _screenList),
                ),
              ),
            ],
          ),
        ),
        // Footer
        Padding(
          padding:
              const EdgeInsets.only(right: 20, left: 20, bottom: 40, top: 20),
          child: PrimaryTextButton(
            text: 'Scan QR Code',
            onPressed: context.read<RestoreGroupController>().nextScreen,
          ),
        ),
      ],
    );
  }
}

const _screenText =
    'Lost access to your device used to store your secrets? No problem, you can restore access for each recovery group here.';
const _screenList = [
  'Now ask each of your Guardians within the group to open their Guardian app',
  'They must select your group',
  'Direct them to click "Change Owner"',
  'Show them your QR code',
];
