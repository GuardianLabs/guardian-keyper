import '/src/core/app/consts.dart';
import '../../../core/domain/core_model.dart';
import '/src/core/ui/widgets/common.dart';

import 'vault_add_secret_presenter.dart';

import 'pages/add_name_page.dart';
import 'pages/add_secret_page.dart';
import 'pages/split_and_share_page.dart';
import 'pages/secret_transmitting_page.dart';

class VaultAddSecretScreen extends StatelessWidget {
  static const routeName = routeVaultAddSecret;

  static const _pages = [
    AddNamePage(),
    AddSecretPage(),
    SplitAndShareSecretPage(),
    SecretTransmittingPage(),
  ];

  static MaterialPageRoute<void> getPageRoute(final RouteSettings settings) =>
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        settings: settings,
        builder: (_) => VaultAddSecretScreen(
          vaultId: settings.arguments as VaultId,
        ),
      );

  final VaultId vaultId;

  const VaultAddSecretScreen({super.key, required this.vaultId});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => VaultAddSecretPresenter(
          pages: _pages,
          vaultId: vaultId,
        ),
        child: ScaffoldSafe(
          child: Selector<VaultAddSecretPresenter, int>(
            selector: (_, controller) => controller.currentPage,
            builder: (_, currentPage, __) => AnimatedSwitcher(
              duration: pageChangeDuration,
              child: _pages[currentPage],
            ),
          ),
        ),
      );
}
