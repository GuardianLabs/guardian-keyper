import '/src/core/consts.dart';
import '/src/core/widgets/common.dart';

import '../home_controller.dart';
import '../widgets/share_panel.dart';
import '../widgets/vaults_panel.dart';
import '../widgets/copy_my_key_to_clipboard_button.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(final BuildContext context) => ListView(
        padding: paddingAll20,
        children: [
          // Device Name
          Selector<HomeController, PeerId>(
            selector: (_, state) => state.myPeerId,
            builder: (_, final myPeerId, ___) => RichText(
              text: TextSpan(
                style: textStylePoppins620,
                children: buildTextWithId(id: myPeerId),
              ),
            ),
          ),
          // My Key
          Row(children: [
            Text(
              context.read<HomeController>().myPeerId.toHexShort(),
              style: textStyleSourceSansPro414Purple,
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
      );
}
