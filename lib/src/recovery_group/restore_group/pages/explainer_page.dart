import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/misc.dart';

import '../restore_group_controller.dart';

class ExplainerPage extends StatelessWidget {
  static const _screenText =
      'You can restore your Vault with the help of your Guardians. '
      'Even in case you’ve lost access to your device.';
  static const _screenList = [
    'Ask a Guardian within your Vault to open their Guardian Keyper app',
    'After that, the Guardian should navigate to “Shards” tab and find your Vault',
    'Direct them to click “Change Vault’s Owner” and share QR Code with you',
    'Scan the QR code',
    'Repeat steps above for each Guardian of your Vault'
  ];
  const ExplainerPage({super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          // Header
          const HeaderBar(
            caption: 'Restore a Vault',
            closeButton: HeaderBarCloseButton(),
          ),
          // Body
          Expanded(
            child: ListView(
              padding: paddingH20,
              children: [
                const PageTitle(
                  title: 'Ownership Transfer',
                  subtitle: _screenText,
                ),
                // Numbered List
                Container(
                  alignment: Alignment.center,
                  padding: paddingAll20,
                  decoration: boxDecoration,
                  child: const NumberedListWidget(list: _screenList),
                ),
                // Footer
                Padding(
                  padding: paddingV32,
                  child: PrimaryButton(
                    text: 'Scan the QR Code',
                    onPressed:
                        context.read<RestoreGroupController>().nextScreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
