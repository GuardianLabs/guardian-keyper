import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';

import 'presenters/vault_create_presenter.dart';
import 'pages/choose_size_page.dart';
import 'pages/choose_type_page.dart';
import 'pages/input_name_page.dart';

class VaultCreateScreen extends StatelessWidget {
  static const routeName = routeVaultCreate;

  static const _pages = [
    ChooseTypePage(),
    ChooseSizePage(),
    InputNamePage(),
  ];

  static MaterialPageRoute<void> getPageRoute(final RouteSettings settings) =>
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        settings: settings,
        builder: (final BuildContext context) => const VaultCreateScreen(),
      );

  const VaultCreateScreen({super.key});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => VaultCreatePresenter(
          pages: _pages,
        ),
        child: ScaffoldSafe(
          child: Selector<VaultCreatePresenter, int>(
            selector: (
              final BuildContext context,
              final VaultCreatePresenter presenter,
            ) =>
                presenter.currentPage,
            builder: (
              final BuildContext context,
              final int currentPage,
              final Widget? widget,
            ) =>
                AnimatedSwitcher(
              duration: pageChangeDuration,
              child: _pages[currentPage],
            ),
          ),
        ),
      );
}
