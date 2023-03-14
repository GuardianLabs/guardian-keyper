import '/src/core/consts.dart';
import '/src/core/widgets/common.dart';
import '/src/guardian/guardian_controller.dart';

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
          BlocBuilder<GuardianController, PeerId>(
            bloc: GetIt.I<GuardianController>(),
            builder: (final context, final state) => RichText(
              text: TextSpan(
                style: textStylePoppins620,
                children: buildTextWithId(id: state),
              ),
            ),
          ),
          // My Key
          Row(children: [
            Text(
              GetIt.I<GuardianController>().state.toHexShort(),
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
