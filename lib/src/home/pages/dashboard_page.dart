import '/src/core/model/core_model.dart';
import '/src/core/di_container.dart';
import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';

import '../widgets/copy_my_key_to_clipboard_widget.dart';
import '../widgets/vaults_panel.dart';
import '../widgets/qr_code_panel.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final diContainer = context.read<DIContainer>();
    return ListView(
      padding: paddingAll20,
      children: [
        // Device Name
        ValueListenableBuilder<Box<SettingsModel>>(
          valueListenable: diContainer.boxSettings.listenable(),
          builder: (context, settings, __) => RichText(
            text: TextSpan(
              style: textStylePoppins620,
              children: buildTextWithId(
                id: context.read<DIContainer>().myPeerId,
              ),
            ),
          ),
        ),
        // My Key
        Row(children: [
          Text(
            diContainer.myPeerId.toHexShort(),
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
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
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
}
