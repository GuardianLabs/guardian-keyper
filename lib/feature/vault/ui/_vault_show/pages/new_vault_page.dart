import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../../widgets/guardian_self_list_tile.dart';
import '../vault_show_presenter.dart';
import '../widgets/guardian_with_ping_tile.dart';

class NewVaultPage extends StatelessWidget {
  const NewVaultPage({super.key});

  @override
  Widget build(final BuildContext context) {
    final vault = context.watch<VaultShowPresenter>().vault;
    return ListView(
      padding: paddingAll20,
      primary: true,
      shrinkWrap: true,
      children: [
        PageTitle(
          title: 'Add more Guardians',
          subtitleSpans: [
            TextSpan(
              text: 'Add ${vault.maxSize - vault.size} more Guardians ',
              style: textStyleSourceSansPro616Purple.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'to enable your Vault and secure your Secret.',
              style: textStyleSourceSansPro416Purple,
            ),
          ],
        ),
        Padding(
          padding: paddingBottom32,
          child: PrimaryButton(
            text: 'Add a Guardian',
            onPressed: () => Navigator.of(context).pushNamed(
              routeVaultAddGuardian,
              arguments: vault.id,
            ),
          ),
        ),
        for (final guardian in vault.guardians.keys)
          Padding(
            padding: paddingV6,
            child: guardian == vault.ownerId
                ? GuardianSelfListTile(guardian: guardian)
                : GuardianWithPingTile(guardian: guardian),
          ),
      ],
    );
  }
}
