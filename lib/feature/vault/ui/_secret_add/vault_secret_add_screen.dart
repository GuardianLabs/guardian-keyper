import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';

import 'vault_secret_add_presenter.dart';
import 'dialogs/on_abort_dialog.dart';
import 'pages/add_name_page.dart';
import 'pages/add_secret_page.dart';
import 'pages/secret_transmitting_page.dart';

class VaultSecretAddScreen extends StatelessWidget {
  static const route = '/vault/secret/add';

  static const _pages = [
    AddNamePage(),
    AddSecretPage(),
    SecretTransmittingPage(),
  ];

  const VaultSecretAddScreen({super.key});

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          if (await OnAbortDialog.show(context) ?? false) {
            if (context.mounted) Navigator.of(context).pop();
          }
        },
        child: ScaffoldSafe(
          child: ChangeNotifierProvider(
            create: (_) => VaultSecretAddPresenter(
              stepsCount: _pages.length,
              vaultId: ModalRoute.of(context)!.settings.arguments! as VaultId,
            ),
            builder: (context, _) => PageView(
              controller: context.read<VaultSecretAddPresenter>(),
              physics: const NeverScrollableScrollPhysics(),
              children: _pages,
            ),
          ),
        ),
      );
}
