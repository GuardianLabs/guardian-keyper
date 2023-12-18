import 'package:guardian_keyper/ui/widgets/common.dart';

import '../dialogs/on_abort_dialog.dart';

class AbortHeaderButton extends StatelessWidget {
  const AbortHeaderButton({super.key});

  @override
  Widget build(BuildContext context) => HeaderBarCloseButton(
        onPressed: () async {
          final wantExit = await OnAbortDialog.show(context);
          if ((wantExit ?? false) && context.mounted) {
            Navigator.of(context).pop();
          }
        },
      );
}
