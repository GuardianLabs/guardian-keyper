import '/src/core/di_container.dart';
import '/src/core/widgets/common.dart';
import '/src/core/model/core_model.dart';

import 'recover_secret_controller.dart';
import 'pages/discovering_peers_page.dart';
import 'pages/show_secret_page.dart';

class RecoveryGroupRecoverSecretView extends StatelessWidget {
  static const routeName = '/recovery_group/recover_secret';
  static const _pages = [
    DiscoveryPeersPage(),
    ShowSecretPage(),
  ];

  final MapEntry<GroupId, SecretId> groupIdWithSecretId;

  const RecoveryGroupRecoverSecretView({
    super.key,
    required this.groupIdWithSecretId,
  });

  @override
  Widget build(BuildContext context) {
    final diContainer = context.read<DIContainer>();
    return ChangeNotifierProvider(
      create: (context) => RecoverySecretController(
        diContainer: diContainer,
        pagesCount: _pages.length,
        groupId: groupIdWithSecretId.key,
        secretId: groupIdWithSecretId.value,
      ),
      child: ScaffoldWidget(
        child: Selector<RecoverySecretController, int>(
          selector: (_, controller) => controller.currentPage,
          builder: (_, currentPage, __) => AnimatedSwitcher(
            duration: diContainer.globals.pageChangeDuration,
            child: _pages[currentPage],
          ),
        ),
      ),
    );
  }
}
