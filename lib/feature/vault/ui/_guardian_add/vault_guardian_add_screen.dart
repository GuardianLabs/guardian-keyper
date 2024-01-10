import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';

import 'vault_guardian_add_presenter.dart';
import 'pages/get_code_page.dart';
import 'pages/loading_page.dart';

class VaultGuardianAddScreen extends StatelessWidget {
  static const route = '/vault/guardian/add';

  static const _pages = [
    GetCodePage(),
    LoadingPage(),
  ];

  const VaultGuardianAddScreen({super.key});

  @override
  Widget build(BuildContext context) => ScaffoldSafe(
        child: ChangeNotifierProvider(
          create: (_) => VaultGuardianAddPresenter(
            stepsCount: _pages.length,
            vaultId: ModalRoute.of(context)!.settings.arguments! as VaultId,
          ),
          builder: (context, _) => PageView(
            controller: context.read<VaultGuardianAddPresenter>(),
            physics: const NeverScrollableScrollPhysics(),
            children: _pages,
          ),
        ),
      );
}
