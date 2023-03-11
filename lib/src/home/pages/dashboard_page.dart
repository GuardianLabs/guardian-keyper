import '/src/core/consts.dart';
import '/src/core/widgets/common.dart';
import '../../settings/settings_controller.dart';

import '../widgets/copy_my_key_to_clipboard_widget.dart';
import '../widgets/vaults_panel.dart';
import '../widgets/qr_code_panel.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(final BuildContext context) => ListView(
        padding: paddingAll20,
        children: [
          // Device Name
          BlocBuilder<SettingsController, SettingsModel>(
            bloc: GetIt.I<SettingsController>(),
            builder: (final context, final state) => RichText(
              text: TextSpan(
                style: textStylePoppins620,
                children: buildTextWithId(id: state.deviceId),
              ),
            ),
          ),
          // My Key
          Row(children: [
            Text(
              GetIt.I<SettingsController>().state.deviceId.toHexShort(),
              style: textStyleSourceSansPro414Purple,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: const CopyMyKeyToClipboardWidget(),
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
            child: QRCodePanel(),
          ),
          // Vaults panel
          const Padding(
            padding: paddingTop20,
            child: VaultsPanel(),
          ),
        ],
      );
}
