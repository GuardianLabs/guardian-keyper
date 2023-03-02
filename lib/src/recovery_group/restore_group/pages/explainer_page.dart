import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';

import '../restore_group_controller.dart';

class ExplainerPage extends StatelessWidget {
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
                Container(
                  alignment: Alignment.center,
                  padding: paddingAll20,
                  decoration: boxDecoration,
                  child: const PageTitle(
                    title: 'Restore your Vault with the help of Guardians',
                    subtitle:
                        'Ask a Guardian to find your Vault in the app, click '
                        '“Change Vault’s Owner” and share QR code or Text code.',
                  ),
                ),
                // Footer
                Padding(
                  padding: paddingV32,
                  child: PrimaryButton(
                    text: 'Scan QR Code',
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
