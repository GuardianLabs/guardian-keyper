import 'package:flutter/material.dart';
import 'package:guardian_keyper/feature/onboarding/ui/dialogs/on_discard_dialog.dart';

class DiscardButton extends StatelessWidget {
  const DiscardButton({super.key});

  @override
  Widget build(BuildContext context) => OutlinedButton(
        style: ButtonStyle(
          side: MaterialStatePropertyAll(BorderSide(
            color: Theme.of(context).colorScheme.error,
          )),
          backgroundColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.errorContainer),
        ),
        onPressed: () async {
          if (await OnDiscardDialog.show(context) ?? false) {
            if (context.mounted) Navigator.of(context).pop();
          }
        },
        child: const Text('Discard'),
      );
}
