import 'package:guardian_keyper/src/core/app/consts.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';

import 'pages/settings_page.dart';
import 'settings_presenter.dart';

class SettingsRoute extends StatelessWidget {
  static const routeName = routeSettings;

  static MaterialPageRoute<void> getPageRoute(final RouteSettings settings) =>
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        settings: settings,
        builder: (_) => const SettingsRoute(),
      );

  const SettingsRoute({super.key});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => SettingsPresenter(),
        lazy: false,
        child: const SettingsPage(),
      );
}
