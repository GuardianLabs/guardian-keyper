import '/src/core/ui/widgets/common.dart';
import '/src/core/ui/widgets/emoji.dart';

import '../home_presenter.dart';
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
  Widget build(final BuildContext context) => Consumer<HomePresenter>(
        builder: (context, presenter, _) => ListView(
          primary: true,
          children: [
            // Header
            const HeaderBar(caption: 'Shards'),
            // Body
            if (presenter.guardedVaults.isEmpty)
              const PageTitle(
                title: 'You don’t have any Shards yet',
                subtitle: _textSubtitle,
              )
            else ...[
              for (final group in presenter.guardedVaults.values)
                Padding(
                  padding: paddingH20 + paddingV6,
                  child: ListTile(
                    title: RichText(
                      text: TextSpan(
                        style: textStyleSourceSansPro614,
                        children: buildTextWithId(id: group.id),
                      ),
                    ),
                    isThreeLine: true,
                    subtitle: RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      strutStyle: const StrutStyle(height: 1.5),
                      text: TextSpan(
                        style: textStyleSourceSansPro414Purple,
                        children: [
                          TextSpan(
                            style: textStyleSourceSansPro414Purple,
                            children: buildTextWithId(id: group.ownerId),
                          ),
                          TextSpan(
                            style: textStyleSourceSansPro414Purple,
                            text: '\n${group.secrets.length} Shard(s)',
                          ),
                        ],
                      ),
                    ),
                    trailing: Container(
                      width: 0,
                      margin: paddingH20,
                      alignment: Alignment.centerRight,
                      child: const Icon(Icons.arrow_forward_ios),
                    ),
                    visualDensity: VisualDensity.standard,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ScaffoldSafe(
                          child: ShardPage(groupId: group.id),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ],
        ),
      );
}
