import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/model/core_model.dart';

import 'add_secret_button.dart';
import 'guardians_expansion_tile.dart';

class AddFirstSecretWidget extends StatelessWidget {
  final RecoveryGroupModel group;

  const AddFirstSecretWidget({super.key, required this.group});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: paddingBottom12,
            child: Text(
              'The Vault is completed, it’s time to add your Secret',
              style: textStylePoppins620,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            'In order to restore your Secret in the future you’d have to get '
            'an approval from at least ${group.threshold} Guardians of this Vault.',
            style: textStyleSourceSansPro416,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: paddingV32,
            child: AddSecretButton(group: group),
          ),
          GuardiansExpansionTile(group: group),
        ],
      );
}
