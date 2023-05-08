import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'dashboard_presenter.dart';
import 'widgets/copy_my_key_to_clipboard_button.dart';
import 'widgets/vaults_panel.dart';
import 'widgets/share_panel.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => DashboardPresenter(),
        child: ListView(
          padding: paddingV20,
          children: [
            // Device Name
            Consumer<DashboardPresenter>(
              builder: (
                final BuildContext context,
                final DashboardPresenter presenter,
                final Widget? widget,
              ) =>
                  RichText(
                text: TextSpan(
                  style: textStylePoppins620,
                  children: buildTextWithId(id: presenter.selfId),
                ),
              ),
            ),
            // My Key
            Row(children: [
              Consumer<DashboardPresenter>(
                builder: (
                  final BuildContext context,
                  final DashboardPresenter presenter,
                  final Widget? widget,
                ) =>
                    Text(
                  presenter.selfId.toHexShort(),
                  style: textStyleSourceSansPro414Purple,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: const CopyMyKeyToClipboardButton(),
                ),
              ),
              // Settings
              IconButton(
                onPressed: () => Navigator.of(context).pushNamed(routeSettings),
                icon: const Icon(Icons.settings_outlined, color: clWhite),
              )
            ]),
            // QR Code panel
            const Padding(
              padding: paddingTop20,
              child: SharePanel(),
            ),
            // Vaults panel
            const Padding(
              padding: paddingTop20,
              child: VaultsPanel(),
            ),
          ],
        ),
      );
}
