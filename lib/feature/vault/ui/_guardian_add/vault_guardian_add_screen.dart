import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/domain/entity/_id/vault_id.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'vault_guardian_add_presenter.dart';
import 'pages/get_code_page.dart';
import 'pages/loading_page.dart';

class VaultGuardianAddScreen extends StatelessWidget {
  static const _pages = [
    GetCodePage(),
    LoadingPage(),
  ];

  const VaultGuardianAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vaultId = ModalRoute.of(context)!.settings.arguments as VaultId;
    return ChangeNotifierProvider(
      create: (_) => VaultGuardianAddPresenter(pages: _pages, vaultId: vaultId),
      child: ScaffoldSafe(
        child: Selector<VaultGuardianAddPresenter, int>(
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
