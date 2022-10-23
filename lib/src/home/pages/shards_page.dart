import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';

import 'shard_page.dart';

class ShardsPage extends StatelessWidget {
  static const _textSubtitle =
      'Guardian Keyper app splits seed phrases into a number '
      'of encrypted parts called “Shards”. Shards are stored on devices '
      'of ”Guardians”, trusted persons. They can be used to securely restore '
      'lost or forgotten seed phrases.\n\nWhen someone asks you to become '
      'their Guardian, you can accept an invitation and as a result get their '
      'Shard. All Shards will be displayed on this page.';

  const ShardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final diContainer = context.read<DIContainer>();
    return ValueListenableBuilder<Box<RecoveryGroupModel>>(
      valueListenable: diContainer.boxRecoveryGroups.listenable(),
      builder: (_, boxRecoveryGroups, __) {
        final guardedGroups = boxRecoveryGroups.values
            .where((e) => e.ownerId != diContainer.myPeerId);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header
            const HeaderBar(caption: 'Shards'),
            // Body
            if (guardedGroups.isEmpty) ...const [
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
                  padding: paddingH20,
                  children: [
                    for (final group in guardedGroups)
                      Padding(
                        padding: paddingV6,
                        child: ListTile(
                          title: Text(
                            group.id.nameEmoji,
                            style: textStyleSourceSansPro614,
                          ),
                          subtitle: Text(
                            'Owner: ${group.ownerId.nameEmoji}',
                            style: textStyleSourceSansPro414Purple,
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ScaffoldWidget(
                                child: ShardPage(groupId: group.id),
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
