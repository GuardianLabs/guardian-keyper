import '/src/core/consts.dart';
import '/src/core/ui/widgets/common.dart';

import 'create_group_controller.dart';
import 'pages/choose_size_page.dart';
import 'pages/choose_type_page.dart';
import 'pages/input_name_page.dart';

class CreateGroupView extends StatelessWidget {
  static const routeName = routeGroupCreate;

  static const _pages = [
    ChooseTypePage(),
    ChooseSizePage(),
    InputNamePage(),
  ];

  const CreateGroupView({super.key});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => CreateGroupController(
          pages: _pages,
        ),
        child: ScaffoldSafe(
          child: Selector<CreateGroupController, int>(
            selector: (context, controller) => controller.currentPage,
            builder: (context, currentPage, __) => AnimatedSwitcher(
              duration: pageChangeDuration,
              child: _pages[currentPage],
            ),
          ),
        ),
      );
}
