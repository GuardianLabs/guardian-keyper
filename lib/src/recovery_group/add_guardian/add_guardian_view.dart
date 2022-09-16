import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';
import '/src/core/widgets/common.dart';

import 'add_guardian_controller.dart';
import 'pages/scan_qrcode_page.dart';
import 'pages/loading_page.dart';
import 'pages/add_tag_page.dart';

class AddGuardianView extends StatelessWidget {
  static const routeName = '/recovery_group/add_guardian';
  static const _pages = [
    ScanQRCodePage(),
    LoadingPage(),
    AddTagPage(),
  ];

  final GroupId groupId;

  const AddGuardianView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final diContainer = context.read<DIContainer>();
    return ChangeNotifierProvider(
      create: (_) => AddGuardianController(
        diContainer: diContainer,
        pagesCount: _pages.length,
        groupId: groupId,
      ),
      lazy: false,
      child: ScaffoldWidget(
        child: Selector<AddGuardianController, int>(
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
