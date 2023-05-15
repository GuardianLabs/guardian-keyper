import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/domain/entity/_id/vault_id.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'vault_secret_add_presenter.dart';

import 'pages/add_name_page.dart';
import 'pages/add_secret_page.dart';
import 'pages/share_page.dart';
import 'pages/secret_transmitting_page.dart';

class VaultSecretAddScreen extends StatelessWidget {
  static const _pages = [
    AddNamePage(),
    AddSecretPage(),
    ShareSecretPage(),
    SecretTransmittingPage(),
  ];

  const VaultSecretAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vaultId = ModalRoute.of(context)!.settings.arguments as VaultId;
    return ChangeNotifierProvider(
      create: (_) => VaultSecretAddPresenter(pages: _pages, vaultId: vaultId),
      child: ScaffoldSafe(
        child: Selector<VaultSecretAddPresenter, int>(
          selector: (_, presenter) => presenter.currentPage,
          builder: (_, currentPage, __) => AnimatedSwitcher(
            duration: pageChangeDuration,
            child: _pages[currentPage],
          ),
        ),
      ),
    );
  }
}
