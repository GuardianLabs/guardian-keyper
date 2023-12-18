import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/utils/utils.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import '../../../domain/entity/vault.dart';

class VaultListTile extends StatelessWidget {
  const VaultListTile({
    required this.vault,
    super.key,
  });

  final Vault vault;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: const IconOf.shield(color: clWhite),
        title: RichText(
          text: TextSpan(
            style: styleSourceSansPro614,
            children: buildTextWithId(name: vault.id.name),
          ),
        ),
        subtitle: _buildSubtitle(vault),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: clWhite),
        onTap: () => Navigator.pushNamed(
          context,
          routeVaultShow,
          arguments: vault.id,
        ),
      );

  Text _buildSubtitle(Vault vault) {
    final styleRed = styleSourceSansPro414.copyWith(color: clRed);
    if (vault.isRestricted) {
      return vault.isRestricted
          ? Text('Restricted usage', style: styleRed)
          : Text('Complete the Recovery', style: styleRed);
    } else {
      return vault.isFull
          ? Text(
              // TBD: i18n
              '${vault.size} Guardians, ${vault.secrets.length} Secrets',
              style: styleSourceSansPro414,
            )
          : Text('Add more Guardians', style: styleRed);
    }
  }
}
