import '/src/core/consts.dart';
import '/src/core/widgets/common.dart';
import '/src/core/repository/repository_root.dart';

import 'pages/vault_page.dart';
import 'pages/new_vault_page.dart';
import 'pages/restricted_vault_page.dart';
import 'widgets/remove_vault_bottom_sheet.dart';

class EditVaultScreen extends StatelessWidget {
  static const routeName = routeGroupEdit;

  static MaterialPageRoute<void> getPageRoute(final RouteSettings settings) =>
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        maintainState: false,
        settings: settings,
        builder: (_) => EditVaultScreen(groupId: settings.arguments as GroupId),
      );

  final GroupId groupId;

  const EditVaultScreen({super.key, required this.groupId});

  @override
  Widget build(final BuildContext context) =>
      ValueListenableBuilder<Box<RecoveryGroupModel>>(
        valueListenable: GetIt.I<RepositoryRoot>().vaultRepository.listenable(),
        builder: (context, boxRecoveryGroup, __) {
          final group = boxRecoveryGroup.get(groupId.asKey);
          // For correct animation on group delete
          if (group == null) return Scaffold(body: Container());
          late final Widget body;
          if (group.isRestoring) {
            body = RestrictedVaultPage(group: group);
          } else if (group.isEmpty) {
            body = NewVaultPage(group: group);
          } else {
            body = VaultPage(group: group);
          }
          return ScaffoldSafe(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                HeaderBar(
                  captionSpans: buildTextWithId(id: group.id),
                  backButton: const HeaderBarBackButton(),
                  closeButton: HeaderBarMoreButton(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => RemoveVaultBottomSheet(
                        group: group,
                      ),
                    ),
                  ),
                ),
                // Body
                Expanded(child: body),
              ],
            ),
          );
        },
      );
}
