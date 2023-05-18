import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'dashboard_presenter.dart';
import 'widgets/share_panel.dart';
import 'widgets/vaults_panel.dart';
import 'widgets/copy_my_key_to_clipboard_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        key: const Key('DashboardPresenter'),
        create: (_) => DashboardPresenter(),
        child: ListView(
          padding: paddingV20,
          children: [
            // Device Name
            Consumer<DashboardPresenter>(
              builder: (_, presenter, __) => RichText(
                text: TextSpan(
                  style: stylePoppins620,
                  children: buildTextWithId(id: presenter.selfId),
                ),
              ),
            ),
            // My Key
            Row(children: [
              Consumer<DashboardPresenter>(
                builder: (_, presenter, __) => Text(
                  presenter.selfId.toHexShort(),
                  style: styleSourceSansPro414Purple,
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
              padding: paddingT20,
              child: SharePanel(),
            ),
            // Vaults panel
            const Padding(
              padding: paddingT20,
              child: VaultsPanel(),
            ),
          ],
        ),
      );
}
