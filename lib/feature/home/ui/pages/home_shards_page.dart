import 'package:flutter_svg/flutter_svg.dart';

import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/utils/screen_size.dart';

import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

class HomeShardsPage extends StatelessWidget {
  static const _textSubtitle =
      'Shards you are guarding will be displayed here. Each Shard is a secure '
      'component of someone else`s Secret, essential for collective recovery, '
      'yet individually reveals no information.';

  const HomeShardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vaultInteractor = GetIt.I<VaultInteractor>();
    final isTitleVisible =
        MediaQuery.of(context).size.height >= ScreenMedium.height;
    return StreamBuilder<Object>(
      stream: vaultInteractor.watch(),
      builder: (context, snapshot) {
        return Column(
          children: [
            // Header
            if (isTitleVisible) const HeaderBar(caption: 'Shards'),
            // Body
            Expanded(
              child: vaultInteractor.shards.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/home_shards.svg',
                          height: 64,
                          width: 64,
                        ),
                        const PageTitle(
                          title: 'Shards will appear here',
                          subtitle: _textSubtitle,
                        ),
                      ],
                    )
                  : ListView(
                      children: [
                        for (final vault in vaultInteractor.shards)
                          Padding(
                            padding: paddingV6,
                            child: ListTile(
                              isThreeLine: true,
                              visualDensity: VisualDensity.standard,
                              title: Text(vault.id.name),
                              subtitle: Text(
                                'Owner: ${vault.ownerId.name}\n'
                                '${vault.secrets.length} Shard(s)',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                          ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}
