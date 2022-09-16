import '/src/core/di_container.dart';
import '/src/core/widgets/common.dart';
import '/src/core/model/core_model.dart';

import 'recovery_secret_controller.dart';
import 'pages/discovering_peers_page.dart';
import 'pages/show_secret_page.dart';

class RecoveryGroupRecoverySecretView extends StatelessWidget {
  static const routeName = '/recovery_group/recovery_secret';
  static const _pages = [
    DiscoveryPeersPage(),
    ShowSecretPage(),
  ];

  final GroupId groupId;

  const RecoveryGroupRecoverySecretView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final diContainer = context.read<DIContainer>();
    return ChangeNotifierProvider(
      create: (_) => RecoverySecretController(
        diContainer: diContainer,
        pagesCount: _pages.length,
        groupId: groupId,
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
