import 'package:guardian_keyper/src/core/ui/widgets/common.dart';

import '../../widgets/guardian_self_list_tile.dart';
import '../presenters/vault_presenter.dart';
import 'guardian_with_ping_tile.dart';

class GuardiansExpansionTile extends StatelessWidget {
  const GuardiansExpansionTile({super.key});

  @override
  Widget build(final BuildContext context) {
    final vault = context.read<VaultPresenter>().vault;
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
