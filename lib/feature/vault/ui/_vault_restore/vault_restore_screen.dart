import 'package:guardian_keyper/ui/widgets/common.dart';

import 'vault_restore_presenter.dart';
import 'pages/get_code_page.dart';
import 'pages/loading_page.dart';

class VaultRestoreScreen extends StatelessWidget {
  static const route = '/vault/restore';

  static const _pages = [
    GetCodePage(),
    LoadingPage(),
  ];

  const VaultRestoreScreen({super.key});

  @override
  Widget build(BuildContext context) => ScaffoldSafe(
        child: ChangeNotifierProvider(
          create: (_) => VaultRestorePresenter(stepsCount: _pages.length),
          builder: (context, _) => PageView(
            controller: context.read<VaultRestorePresenter>(),
            physics: const NeverScrollableScrollPhysics(),
            children: _pages,
          ),
        ),
      );
}
