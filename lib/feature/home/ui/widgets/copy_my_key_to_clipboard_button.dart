import 'dart:async';
import 'package:flutter/services.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

class CopyMyKeyToClipboardButton extends StatefulWidget {
  const CopyMyKeyToClipboardButton({
    required this.id,
    super.key,
  });

  final String id;

  @override
  State<CopyMyKeyToClipboardButton> createState() =>
      _CopyMyKeyToClipboardButtonState();
}

class _CopyMyKeyToClipboardButtonState
    extends State<CopyMyKeyToClipboardButton> {
  bool _isDisabled = false;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.copy, size: 20),
        onPressed: _isDisabled
            ? null
            : () async {
                await Clipboard.setData(ClipboardData(text: widget.id));
                setState(() => _isDisabled = true);
                Timer(
                  snackBarDuration,
                  () => setState(() => _isDisabled = false),
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
