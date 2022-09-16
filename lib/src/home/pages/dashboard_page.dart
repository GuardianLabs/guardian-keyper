import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';
import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/recovery_group/restore_group/restore_group_view.dart';

import 'settings_page.dart';
import '../widgets/copy_my_key_to_clipboard_widget.dart';
import '../widgets/dashboard_groups_widget.dart';
import '../widgets/my_qr_code_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final diContainer = context.read<DIContainer>();
    return ListView(
      padding: paddingH20,
      children: [
        const Padding(padding: paddingTop20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<Box<SettingsModel>>(
              valueListenable: diContainer.boxSettings.listenable(),
              builder: (_, boxSettings, __) => Text(
                boxSettings.deviceName,
                style: textStylePoppins620,
              ),
            ),
            Row(
              children: [
                Text(
                  diContainer.myPeerId.toHexShort(),
                  style: textStyleSourceSansPro414Purple,
                ),
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  child: const CopyMyKeyToClipboardWidget(),
                )),
                IconButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          const ScaffoldWidget(child: SettingsPage()))),
                  icon: const Icon(Icons.settings_outlined, color: clWhite),
                )
              ],
            ),
          ],
        ),
        const Padding(
          padding: paddingTop20,
          child: MyQRCodeWidget(),
        ),
        const Padding(
          padding: paddingTop20,
          child: DashboardGroupsWidget(),
        ),
        Padding(
          padding: paddingV20,
          child: OutlinedButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(RestoreGroupView.routeName),
            child: const Text('Restore Group'),
          ),
        ),
      ],
    );
  }
}
