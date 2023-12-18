import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../../domain/entity/vault.dart';
import 'dialogs/on_change_owner_dialog.dart';

class ShardShowScreen extends StatelessWidget {
  const ShardShowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vault = ModalRoute.of(context)!.settings.arguments! as Vault;
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
            padding: paddingT32 + paddingH20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: styleSourceSansPro414Purple,
                    children: buildTextWithId(id: vault.ownerId),
                  ),
                ),
                Padding(
                  padding: paddingV6,
                  child: RichText(
                    text: TextSpan(
                      style: stylePoppins616,
                      children: buildTextWithId(id: vault.id),
                    ),
                  ),
                ),
                Text(
                  vault.id.toHexShort(),
                  style: styleSourceSansPro414,
                ),
                Padding(
                  padding: paddingT12,
                  child: PrimaryButton(
                    text: 'Change Vault’s Owner',
                    onPressed: () => OnChangeOwnerDialog.show(
                      context,
                      vaultId: vault.id,
                    ),
                  ),
                ),
                Padding(
                  padding: paddingT32,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Secret Shards',
                        style: stylePoppins620,
                      ),
                      Text(
                        vault.secrets.length.toString(),
                        style: stylePoppins620,
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
