import '/src/core/consts.dart';
import '/src/core/di_container.dart';
import '/src/core/widgets/common.dart';
import '/src/core/model/core_model.dart';

import 'add_secret_controller.dart';

import 'pages/add_name_page.dart';
import 'pages/add_secret_page.dart';
import 'pages/split_and_share_page.dart';
import 'pages/secret_transmitting_page.dart';

class AddSecretView extends StatelessWidget {
  static const routeName = routeGroupAddSecret;

  static const _pages = [
    AddNamePage(),
    AddSecretPage(),
    SplitAndShareSecretPage(),
    SecretTransmittingPage(),
  ];

  final GroupId groupId;

  const AddSecretView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final diContainer = context.read<DIContainer>();
    return ChangeNotifierProvider(
      create: (context) => AddSecretController(
        diContainer: diContainer,
        pages: _pages,
        groupId: groupId,
      ),
      child: ScaffoldWidget(
        child: Selector<AddSecretController, int>(
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
