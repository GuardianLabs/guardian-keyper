import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/misc.dart';

import '../restore_group_controller.dart';

class ExplainerPage extends StatelessWidget {
  const ExplainerPage({super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          // Header
          const HeaderBar(
            caption: 'Restore your Group',
            closeButton: HeaderBarCloseButton(),
          ),
          // Body
          Expanded(
              child: ListView(
            padding: paddingH20,
            children: [
              const PageTitle(
                  title: 'Ownership Transfer', subtitle: _screenText),
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
                  text: 'Scan QR Code',
                  onPressed: context.read<RestoreGroupController>().nextScreen,
                ),
              ),
            ],
          )),
        ],
      );
}

const _screenText = 'You can restore your Recovery Group with the help of your'
    ' Guardians. Even in case you’ve lost access to your device.';
const _screenList = [
  'Ask a Guardian within your recovery group to open their Guardian Keyper app',
  'After that,  the Guardian should navigate to “Shards” tab and open your group',
  'Direct them to click “Change Owner”',
  'Scan their QR code',
  'Repeat steps above for each Guardian in your recovery group'
];
