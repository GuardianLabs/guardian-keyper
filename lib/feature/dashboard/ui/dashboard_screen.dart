import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/utils/utils.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'dashboard_presenter.dart';
import 'dialogs/on_show_id_dialog.dart';
import 'widgets/copy_my_key_to_clipboard_button.dart';
import 'widgets/vaults_panel.dart';
import 'widgets/share_panel.dart';

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
              builder: (_, presenter, __) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: stylePoppins620,
                      children: buildTextWithId(name: presenter.selfId.name),
                    ),
                  ),
                  Row(children: [
                    // My Key
                    Text(
                      presenter.selfId.toHexShort(),
                      style: styleSourceSansPro414Purple,
                    ),
                    // Copy to Clipboard
                    CopyMyKeyToClipboardButton(id: presenter.selfId.asHex),
                    // Show full ID
                    IconButton(
                      icon: const Icon(Icons.visibility_outlined),
                      onPressed: () => OnShowIdDialog.show(
                        context,
                        id: presenter.selfId.asHex,
                      ),
                    ),
                    const Spacer(),
                    // Settings
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () =>
                          Navigator.of(context).pushNamed(routeSettings),
                    )
                  ]),
                ],
              ),
            ),
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
