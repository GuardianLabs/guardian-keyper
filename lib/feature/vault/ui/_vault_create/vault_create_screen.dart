import 'package:guardian_keyper/ui/widgets/common.dart';

import 'vault_create_presenter.dart';
import 'pages/choose_size_page.dart';
import 'pages/input_name_page.dart';
import 'pages/vault_created_page.dart';

class VaultCreateScreen extends StatelessWidget {
  static const route = '/vault/create';

  static const _pages = [
    ChooseSizePage(),
    InputNamePage(),
    VaultCreatedPage(),
  ];

  const VaultCreateScreen({super.key});

  @override
  Widget build(BuildContext context) => ScaffoldSafe(
        child: ChangeNotifierProvider(
          create: (_) => VaultCreatePresenter(stepsCount: _pages.length),
          builder: (context, _) => PageView(
            controller: context.read<VaultCreatePresenter>(),
            physics: const NeverScrollableScrollPhysics(),
            children: _pages,
          ),
        ),
      );
}
