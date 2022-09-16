import 'dart:async';
import 'package:flutter/services.dart';

import '/src/core/di_container.dart';
import '/src/core/widgets/common.dart';

class CopyMyKeyToClipboardWidget extends StatefulWidget {
  const CopyMyKeyToClipboardWidget({super.key});

  @override
  State<CopyMyKeyToClipboardWidget> createState() =>
      _CopyMyKeyToClipboardWidgetState();
}

class _CopyMyKeyToClipboardWidgetState
    extends State<CopyMyKeyToClipboardWidget> {
  Timer? timer;
  var isDisabled = false;

  @override
  Widget build(BuildContext context) {
    final diContainer = context.read<DIContainer>();
    return IconButton(
      icon: const Icon(Icons.copy, size: 20),
      onPressed: isDisabled
          ? null
          : () async {
              await Clipboard.setData(
                  ClipboardData(text: diContainer.myPeerId.asHex));
              setState(() => isDisabled = true);
              timer = Timer(
                diContainer.globals.snackBarDuration,
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
}
