import '/src/core/consts.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/data/core_model.dart';

import 'vault_add_secret_controller.dart';

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
          groupId: settings.arguments as VaultId,
        ),
      );

  final VaultId groupId;

  const VaultAddSecretScreen({super.key, required this.groupId});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => VaultAddSecretController(
          pages: _pages,
          groupId: groupId,
        ),
        child: ScaffoldSafe(
          child: Selector<VaultAddSecretController, int>(
            selector: (_, controller) => controller.currentPage,
            builder: (_, currentPage, __) => AnimatedSwitcher(
              duration: pageChangeDuration,
              child: _pages[currentPage],
            ),
          ),
        ),
      );
}
