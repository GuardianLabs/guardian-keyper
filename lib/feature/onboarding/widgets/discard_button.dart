import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';
import 'package:guardian_keyper/feature/onboarding/ui/dialogs/on_discard_dialog.dart';

class DiscardButton extends StatelessWidget {
  const DiscardButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return OutlinedButton(
      style: ButtonStyle(
        side: MaterialStatePropertyAll(BorderSide(
          color: colorScheme.error,
        )),
        backgroundColor: MaterialStatePropertyAll(colorScheme.errorContainer),
      ),
      onPressed: () async {
        if (await OnDiscardDialog.show(context) ?? false) {
          final authManager = GetIt.I<AuthManager>();
          await authManager.setPassCode('');
          await authManager.setIsBiometricsEnabled(true);
          await GetIt.I<NetworkManager>().setDeviceName('');
          if (context.mounted) Navigator.of(context).pop();
        }
      },
      child: const Text('Discard'),
    );
  }
}
