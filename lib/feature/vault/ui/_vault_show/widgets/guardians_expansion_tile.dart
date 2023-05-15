import 'package:guardian_keyper/ui/widgets/common.dart';

import '../../widgets/guardian_self_list_tile.dart';
import '../vault_show_presenter.dart';
import 'guardian_with_ping_tile.dart';

class GuardiansExpansionTile extends StatelessWidget {
  const GuardiansExpansionTile({super.key});

  @override
  Widget build(BuildContext context) {
    final vault = context.read<VaultShowPresenter>().vault;
    return ExpansionTile(
      title: Text(
        'Vault’s Guardians',
        style: textStyleSourceSansPro614,
      ),
      subtitle: Text(
        '${vault.size} Guardians',
        style: textStyleSourceSansPro414Purple,
      ),
      childrenPadding: EdgeInsets.zero,
      children: [
        for (final guardian in vault.guardians.keys)
          guardian == vault.ownerId
              ? GuardianSelfListTile(guardian: guardian)
              : GuardianWithPingTile(guardian: guardian),
      ],
    );
  }
}
