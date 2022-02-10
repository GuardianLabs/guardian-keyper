import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme_data.dart';
import '../../../widgets/common.dart';
import '../../../widgets/icon_of.dart';

import '../add_guardian_controller.dart';

class AddGuardianPage extends StatelessWidget {
  const AddGuardianPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AddGuardianController>(context, listen: false);
    return Column(
      children: [
        // Header
        const HeaderBar(
          caption: 'Add Guardians',
          closeButton: HeaderBarCloseButton(),
        ),
        // Body
        const Padding(
          // padding: EdgeInsets.only(top: 60),
          padding: EdgeInsets.only(top: 20),
          child: CircleAvatar(
            backgroundColor: clIndigo500,
            radius: 40,
            child: Icon(Icons.qr_code_scanner_rounded),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Invite '),
                TextSpan(text: 'members', style: TextStyle(color: clBlue)),
                TextSpan(text: ' to your\n recovery group'),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 115, right: 115),
          child: FooterButton(text: 'Scan QR', onPressed: state.nextScreen),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Upload QR Code'),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'You can ask your members to open Guardian app, authorize and click "Show QR Code"',
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(child: Container()),
        // Footer
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SimpleCard(
            caption: 'Download the app',
            bgColor: clIndigo800,
            leading: IconOf.app(),
            text: 'Users can download the app\nby scanning the QR Code',
          ),
        ),
        Container(height: 50),
      ],
    );
  }
}
