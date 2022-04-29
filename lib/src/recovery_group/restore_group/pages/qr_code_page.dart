import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';

import '../restore_group_controller.dart';
import '../../recovery_group_controller.dart';

class QRCodePage extends StatelessWidget {
  const QRCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RecoveryGroupController>(context);
    final state = Provider.of<RestoreGroupController>(context);
    final size = MediaQuery.of(context).size.width - 20;
    final recoveryGroup = controller.groups[state.groupName];

    return Column(
      children: [
        // Header
        const HeaderBar(
          caption: 'My QR Code',
          closeButton: HeaderBarCloseButton(),
        ),
        // Body
        Container(
          alignment: Alignment.center,
          margin: paddingAll20,
          padding: const EdgeInsets.all(10),
          height: size,
          width: size,
          child: QrImage(
            data: controller.getQRCode().toString(),
            foregroundColor: Colors.white,
          ),
        ),
        ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.all(40),
              child: Text('Please show this QR code to\nyour Guardians',
                  textAlign: TextAlign.center),
            ),
            if (state.groupName != null)
              Padding(
                padding: paddingAll20,
                child: Center(child: Text(state.groupName!)),
              ),
            if (recoveryGroup != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < recoveryGroup.size; i++)
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: CircleAvatar(
                        foregroundColor: clWhite,
                        backgroundColor: recoveryGroup.guardians.length > i
                            ? clGreen
                            : clIndigo500,
                        child: const Icon(Icons.health_and_safety_outlined),
                      ),
                    ),
                ],
              ),
            if (state.error != null)
              Column(
                children: [
                  Text('Error: ${state.error}'),
                  Text('Stack Trace: ${state.stackTrace}'),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
