import 'package:guardian_keyper/ui/widgets/common.dart';

import '../vault_create_presenter.dart';
import '../widgets/vault_size_info_panel.dart';
import '../widgets/guardians_control_panel.dart';

class ChooseSizePage extends StatelessWidget {
  const ChooseSizePage({super.key});

  @override
  Widget build(BuildContext context) => Column(children: [
        // Header
        HeaderBar(
          caption: 'Vault Size',
          backButton: HeaderBarBackButton(
            onPressed: context.read<VaultCreatePresenter>().previousPage,
          ),
          closeButton: const HeaderBarCloseButton(),
        ),
        // Body
        Expanded(
          child: ListView(
            padding: paddingAll20,
            children: [
              Padding(
                padding: paddingB20,
                child: Text(
                  'Select Guardians amount',
                  style: stylePoppins620,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: paddingB32,
                child: Text(
                  'Pick amount of Guardians which will be responsible '
                  'for keeping the Shards (parts) of your Secrets.',
                  style: styleSourceSansPro416,
                  textAlign: TextAlign.center,
                ),
              ),
              // Control
              const GuardiansControlPanel(),
              // Info
              const Padding(
                padding: paddingT32,
                child: VaultSizeInfoPanel(),
              ),
              // Footer
              Padding(
                padding: paddingV32,
                child: PrimaryButton(
                  text: 'Continue',
                  onPressed: context.read<VaultCreatePresenter>().nextPage,
                ),
              ),
            ],
          ),
        ),
      ]);
}
