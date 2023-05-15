import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/domain/entity/vault_model.dart';

import 'dialogs/on_change_owner_dialog.dart';

class ShardShowScreen extends StatelessWidget {
  const ShardShowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vault = ModalRoute.of(context)!.settings.arguments as VaultModel;
    return ScaffoldSafe(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          HeaderBar(
            captionSpans: buildTextWithId(id: vault.id),
            backButton: const HeaderBarBackButton(),
          ),
          // Body
          Padding(
            padding: paddingTop32 + paddingH20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: textStyleSourceSansPro414Purple,
                    children: buildTextWithId(id: vault.ownerId),
                  ),
                ),
                Padding(
                  padding: paddingV6,
                  child: RichText(
                    text: TextSpan(
                      style: textStylePoppins616,
                      children: buildTextWithId(id: vault.id),
                    ),
                  ),
                ),
                Text(
                  vault.id.toHexShort(),
                  style: textStyleSourceSansPro414,
                ),
                Padding(
                  padding: paddingTop12,
                  child: PrimaryButton(
                    text: 'Change Vault’s Owner',
                    onPressed: () => OnChangeOwnerDialog.show(
                      context,
                      vault: vault,
                    ),
                  ),
                ),
                Padding(
                  padding: paddingTop32,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Secret Shards',
                        style: textStylePoppins620,
                      ),
                      Text(
                        vault.secrets.length.toString(),
                        style: textStylePoppins620,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Shards List
          Expanded(
            child: ListView(
              padding: paddingH20,
              children: [
                for (final secretShard in vault.secrets.keys)
                  Padding(
                    padding: paddingV6,
                    child: ListTile(
                      title: Text(secretShard.name),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
