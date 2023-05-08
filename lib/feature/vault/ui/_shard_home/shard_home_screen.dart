import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'shard_home_presenter.dart';

class ShardHomeScreen extends StatelessWidget {
  static const _textSubtitle =
      'Guardian Keyper app splits seed phrases into a number '
      'of encrypted parts called “Shards”. Shards are stored on devices '
      'of ”Guardians”, trusted persons. They can be used to securely restore '
      'lost or forgotten seed phrases.\n\nWhen someone asks you to become '
      'their Guardian, you can accept an invitation and as a result get their '
      'Shard. All Shards will be displayed on this page.';

  const ShardHomeScreen({super.key});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => ShardHomePresenter(),
        child: Consumer<ShardHomePresenter>(
          builder: (
            final BuildContext context,
            final ShardHomePresenter presenter,
            final Widget? widget,
          ) =>
              ListView(
            primary: true,
            children: [
              // Header
              const HeaderBar(caption: 'Shards'),
              // Body
              if (presenter.shards.isEmpty)
                const PageTitle(
                  title: 'You don’t have any Shards yet',
                  subtitle: _textSubtitle,
                )
              else ...[
                for (final vault in presenter.shards.values)
                  Padding(
                    padding: paddingV6,
                    child: ListTile(
                      title: RichText(
                        text: TextSpan(
                          style: textStyleSourceSansPro614,
                          children: buildTextWithId(id: vault.id),
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
                              children: buildTextWithId(id: vault.ownerId),
                            ),
                            TextSpan(
                              style: textStyleSourceSansPro414Purple,
                              text: '\n${vault.secrets.length} Shard(s)',
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
                      onTap: () => Navigator.of(context).pushNamed(
                        routeShardShow,
                        arguments: vault,
                      ),
                    ),
                  )
              ],
            ],
          ),
        ),
      );
}
