import 'dart:async';
import 'package:flutter/services.dart';

import '/src/core/consts.dart';
import '/src/core/widgets/common.dart';
import '/src/guardian/guardian_controller.dart';

class CopyMyKeyToClipboardWidget extends StatefulWidget {
  const CopyMyKeyToClipboardWidget({super.key});

  @override
  State<CopyMyKeyToClipboardWidget> createState() =>
      _CopyMyKeyToClipboardWidgetState();
}

class _CopyMyKeyToClipboardWidgetState
    extends State<CopyMyKeyToClipboardWidget> {
  var isDisabled = false;

  @override
  Widget build(final BuildContext context) => IconButton(
        icon: const Icon(Icons.copy, size: 20),
        onPressed: isDisabled
            ? null
            : () async {
                await Clipboard.setData(ClipboardData(
                  text: GetIt.I<GuardianController>().state.asHex,
                ));
                setState(() => isDisabled = true);
                Timer(
                  snackBarDuration,
                  () => setState(() => isDisabled = false),
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    buildSnackBar(
                      text: 'Public Key has been copied to clipboard.',
                    ),
                  );
                }
              },
      );
}
