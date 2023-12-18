import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'vault_create_presenter.dart';
import 'pages/choose_size_page.dart';
import 'pages/input_name_page.dart';
import 'pages/vault_created_page.dart';

class VaultCreateScreen extends StatelessWidget {
  static const _pages = [
    ChooseSizePage(),
    InputNamePage(),
    VaultCreatedPage(),
  ];

  const VaultCreateScreen({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => VaultCreatePresenter(pageCount: _pages.length),
        child: ScaffoldSafe(
          child: Selector<VaultCreatePresenter, int>(
            selector: (_, presenter) => presenter.currentPage,
            builder: (_, currentPage, __) => AnimatedSwitcher(
              duration: pageChangeDuration,
              child: _pages[currentPage],
            ),
          ),
        ),
      );
}
