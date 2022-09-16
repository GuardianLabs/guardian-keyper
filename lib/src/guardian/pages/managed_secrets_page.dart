import 'package:guardian_keyper/src/core/model/core_model.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '../guardian_controller.dart';
import '../widgets/secret_list_tile_widget.dart';

class ManagedSecretsPage extends StatefulWidget {
  const ManagedSecretsPage({super.key});

  @override
  State<ManagedSecretsPage> createState() => _ManagedSecretsPageState();
}

class _ManagedSecretsPageState extends State<ManagedSecretsPage> {
  GroupId? expanedShardId;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GuardianController>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Header
        const HeaderBar(caption: 'Shards'),
        // Body
        if (controller.secretShards.isEmpty) ...const [
          Padding(
            padding: paddingTop32,
            child: IconOf.shield(isBig: true),
          ),
          Padding(
            padding: paddingAll20,
            child: PageTitle(
              title: 'You don’t have any Shards yet',
              subtitle: _textSubtitle,
            ),
          ),
        ] else
          Expanded(
            child: ListView(
              key: Key(expanedShardId?.asHex ?? 'emptyOne'),
              padding: paddingH20,
              children: [
                for (final shard in controller.secretShards)
                  Padding(
                    padding: paddingV6,
                    child: SecretTileWidget(
                      secretShard: shard,
                      isExpanded: shard.groupId == expanedShardId,
                      setExpanded: (groupId) =>
                          setState(() => expanedShardId = groupId),
                    ),
                  )
              ],
            ),
          ),
      ],
    );
  }
}

const _textSubtitle = 'Guardian Keyper app splits seed phrases into a number '
    'of encrypted parts called “Shards”. Shards are stored on devices '
    'of ”Guardians”, trusted persons. They can be used to securely restore '
    'lost or forgotten seed phrases.\n\nWhen someone asks you to become '
    'their Guardian, you can accept an invitation and as a result get their '
    'Shard. All Shards will be displayed on this page.';
