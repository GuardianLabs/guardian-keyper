import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import '../../../domain/entity/vault.dart';

class VaultListTile extends StatelessWidget {
  const VaultListTile({
    super.key,
    required this.vault,
  });

  final Vault vault;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: const IconOf.shield(color: clWhite),
        title: RichText(
          text: TextSpan(
            style: textStyleSourceSansPro614,
            children: buildTextWithId(id: vault.id),
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
    final styleRed = textStyleSourceSansPro414.copyWith(color: clRed);
    if (vault.isRestricted) {
      return vault.isRestricted
          ? Text('Restricted usage', style: styleRed)
          : Text('Complete the Recovery', style: styleRed);
    } else {
      return vault.isFull
          ? Text(
              // TBD: i18n
              '${vault.size} Guardians, ${vault.secrets.length} Secrets',
              style: textStyleSourceSansPro414,
            )
          : Text('Add more Guardians', style: styleRed);
    }
  }
}
