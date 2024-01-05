import 'package:guardian_keyper/consts.dart';
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
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => VaultRestorePresenter(pageCount: _pages.length),
        child: ScaffoldSafe(
          child: Selector<VaultRestorePresenter, int>(
            selector: (_, presenter) => presenter.currentPage,
            builder: (_, currentPage, __) => AnimatedSwitcher(
              duration: pageChangeDuration,
              child: _pages[currentPage],
            ),
          ),
        ),
      );
}
