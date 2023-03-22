import '/src/core/consts.dart';
import '/src/core/widgets/common.dart';
import '/src/core/model/core_model.dart';

import 'recover_secret_controller.dart';
import 'pages/discovering_peers_page.dart';
import 'pages/show_secret_page.dart';

class RecoverSecretView extends StatelessWidget {
  static const routeName = routeGroupRecoverSecret;

  static const _pages = [
    DiscoveryPeersPage(),
    ShowSecretPage(),
  ];

  final MapEntry<GroupId, SecretId> groupIdWithSecretId;

  const RecoverSecretView({super.key, required this.groupIdWithSecretId});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => RecoverySecretController(
          pages: _pages,
          groupId: groupIdWithSecretId.key,
          secretId: groupIdWithSecretId.value,
        ),
        child: ScaffoldSafe(
          child: Selector<RecoverySecretController, int>(
            selector: (_, controller) => controller.currentPage,
            builder: (_, currentPage, __) => AnimatedSwitcher(
              duration: pageChangeDuration,
              child: _pages[currentPage],
            ),
          ),
        ),
      );
}
