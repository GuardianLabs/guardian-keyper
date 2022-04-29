import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/widgets/selectable_card.dart';

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
        Expanded(
            child: ListView(
          primary: true,
          shrinkWrap: true,
          children: [
            const Padding(
              padding: paddingTop20,
              child: IconOf.scanQR(radius: 40, size: 32),
            ),
            Padding(
              padding: paddingAll20,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: textStylePoppinsBold20,
                  children: const <TextSpan>[
                    TextSpan(text: 'Invite '),
                    TextSpan(
                        text: 'Guardians', style: TextStyle(color: clBlue)),
                    TextSpan(text: ' to your\n recovery group'),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 115),
              child: PrimaryButtonBig(
                  text: 'Scan QR', onPressed: state.nextScreen),
            ),
            Padding(
              padding: paddingAll20,
              child: Text(
                'Upload QR Code',
                style: textStylePoppinsBold20Blue,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: paddingAll20,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          'You can ask your members to open Guardian\napp, authorize and click ',
                      style: textStyleSourceSansProRegular14.copyWith(
                          color: clPurpleLight),
                    ),
                    TextSpan(
                        text: 'Show QR Code',
                        style: textStyleSourceSansProBold14),
                  ],
                ),
              ),
            ),
            if (MediaQuery.of(context).size.height > heightSmall)
              const SizedBox(height: 40),
            Padding(
              padding: paddingFooter,
              child: SelectableCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Download App',
                                textAlign: TextAlign.left,
                                style: textStylePoppinsBold16,
                              ),
                              const SizedBox(height: 16),
                              RichText(
                                textAlign: TextAlign.left,
                                softWrap: true,
                                overflow: TextOverflow.clip,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          'Users can download the app\nby scanning the',
                                      style: textStyleSourceSansProRegular14,
                                    ),
                                    TextSpan(
                                      text: ' QR Code.',
                                      style: textStyleSourceSansProBold14,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '',
                                style: textStyleSourceSansProBold14,
                              ),
                            ]),
                        SizedBox(
                          height: 80,
                          width: 80,
                          child:
                              QrImage(foregroundColor: Colors.white, data: ''),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      child: const Text('Share App'),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ],
    );
  }
}
