import 'package:guardian_keyper/consts.dart';
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
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => ShardHomePresenter(),
        child: Consumer<ShardHomePresenter>(
          builder: (context, presenter, __) => ListView(
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
                      isThreeLine: true,
                      visualDensity: VisualDensity.standard,
                      title: Text(
                        vault.id.name,
                        style: styleSourceSansPro614,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        'Owner: ${vault.ownerId.name}\n'
                        '${vault.secrets.length} Shard(s)',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: styleSourceSansPro414Purple,
                        strutStyle: const StrutStyle(height: 1.5),
                      ),
                      trailing: Container(
                        width: 0,
                        margin: paddingH20,
                        alignment: Alignment.centerRight,
                        child: const Icon(Icons.arrow_forward_ios),
                      ),
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
