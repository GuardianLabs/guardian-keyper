import 'package:guardian_keyper/app/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'vault_restore_presenter.dart';
import 'pages/get_code_page.dart';
import 'pages/loading_page.dart';

class VaultRestoreScreen extends StatelessWidget {
  static const _pages = [
    GetCodePage(),
    LoadingPage(),
  ];

  const VaultRestoreScreen({super.key});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (_) => VaultRestorePresenter(pages: _pages),
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
