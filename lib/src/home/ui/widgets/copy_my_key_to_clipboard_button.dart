import 'dart:async';
import 'package:flutter/services.dart';

import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';

import '../presenters/dashboard_presenter.dart';

class CopyMyKeyToClipboardButton extends StatefulWidget {
  const CopyMyKeyToClipboardButton({super.key});

  @override
  State<CopyMyKeyToClipboardButton> createState() =>
      _CopyMyKeyToClipboardButtonState();
}

class _CopyMyKeyToClipboardButtonState
    extends State<CopyMyKeyToClipboardButton> {
  var isDisabled = false;

  @override
  Widget build(final BuildContext context) => IconButton(
        icon: const Icon(Icons.copy, size: 20),
        onPressed: isDisabled
            ? null
            : () async {
                await Clipboard.setData(ClipboardData(
                  text: context.read<DashboardPresenter>().selfId.asHex,
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
