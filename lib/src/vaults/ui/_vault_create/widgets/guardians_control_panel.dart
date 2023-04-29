import 'package:guardian_keyper/src/core/ui/widgets/common.dart';

import '../presenters/vault_create_presenter.dart';
import 'guardian_count_radio.dart';

class GuardiansControlPanel extends StatelessWidget {
  const GuardiansControlPanel({super.key});

  @override
  Widget build(final BuildContext context) {
    final presenter = Provider.of<VaultCreatePresenter>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: clIndigo800,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: GuardianCountRadio(
                    vaultSize: 3,
                    vaultThreshold: 2,
                    isChecked: presenter.vaultSize == 3,
                  ),
                ),
                Expanded(
                  child: GuardianCountRadio(
                    vaultSize: 5,
                    vaultThreshold: 3,
                    isChecked: presenter.vaultSize == 5,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    'Keep one Shard (encrypted part of a Secret) on my device '
                    'every time I create a new Secret.',
                    softWrap: true,
                    style: textStyleSourceSansPro412.copyWith(
                      color: clPurpleLight,
                    ),
                  ),
                ),
                Switch.adaptive(
                  value: presenter.isVaultMember,
                  onChanged: presenter.setVaultMembership,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
