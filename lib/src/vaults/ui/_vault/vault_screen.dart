import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/ui/widgets/emoji.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';

import '../../domain/vault_model.dart';
import 'presenters/vault_presenter.dart';
import 'vault_more_dialog.dart';
import 'pages/vault_page.dart';
import 'pages/new_vault_page.dart';
import 'pages/restricted_vault_page.dart';

class VaultScreen extends StatelessWidget {
  static const routeName = routeVaultEdit;

  static MaterialPageRoute<void> getPageRoute(final RouteSettings settings) =>
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        settings: settings,
        builder: (final BuildContext context) =>
            VaultScreen(vaultId: settings.arguments as VaultId),
      );

  const VaultScreen({super.key, required this.vaultId});

  final VaultId vaultId;

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => VaultPresenter(
          vaultId: vaultId,
        ),
        child: ScaffoldSafe(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              HeaderBar(
                captionSpans: buildTextWithId(id: vaultId),
                backButton: const HeaderBarBackButton(),
                closeButton: HeaderBarMoreButton(
                  onPressed: () => VaultMoreDialog.show(
                    context: context,
                    vaultId: vaultId,
                  ),
                ),
              ),
              // Body
              Expanded(
                child: Consumer<VaultPresenter>(
                  builder: (
                    final BuildContext context,
                    final VaultPresenter presenter,
                    final Widget? widget,
                  ) {
                    if (presenter.vault.isRestricted) {
                      return const RestrictedVaultPage();
                    }
                    if (presenter.vault.isNotFull) {
                      return const NewVaultPage();
                    }
                    return const VaultPage();
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
