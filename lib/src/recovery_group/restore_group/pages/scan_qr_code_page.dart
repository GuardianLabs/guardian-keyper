import 'package:flutter/material.dart';

import '/src/core/model/core_model.dart';

import '../restore_group_controller.dart';
import '../../widgets/get_qrcode_widget.dart';

class ScanQRCodePage extends StatelessWidget {
  const ScanQRCodePage({super.key});

  @override
  Widget build(final BuildContext context) => GetQRCodeWidget(
        resultCallback: (qrCode) {
          if (qrCode.code == MessageCode.takeGroup) {
            context.read<RestoreGroupController>().qrCode = qrCode;
          }
        },
      );
}
