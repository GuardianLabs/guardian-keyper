import '/src/core/di_container.dart';
import '/src/core/widgets/common.dart';

import 'create_group_controller.dart';
import 'pages/choose_size_page.dart';
import 'pages/choose_type_page.dart';
import 'pages/input_name_page.dart';

class CreateGroupView extends StatelessWidget {
  static const routeName = '/recovery_group_create';

  static const _pages = [
    ChooseTypePage(),
    ChooseSizePage(),
    InputNamePage(),
  ];

  const CreateGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    final diContainer = context.read<DIContainer>();
    return ChangeNotifierProvider(
      create: (_) => CreateGroupController(
        diContainer: diContainer,
        pagesCount: _pages.length,
      ),
      child: ScaffoldWidget(
        child: Selector<CreateGroupController, int>(
          selector: (_, controller) => controller.currentPage,
          builder: (context, currentPage, __) => AnimatedSwitcher(
            duration: diContainer.globals.pageChangeDuration,
            child: _pages[currentPage],
          ),
        ),
      ),
    );
  }
}
