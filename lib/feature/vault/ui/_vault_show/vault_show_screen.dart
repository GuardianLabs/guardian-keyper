import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/domain/entity/_id/vault_id.dart';

import 'vault_show_presenter.dart';
import 'dialogs/on_vault_more_dialog.dart';
import 'pages/vault_page.dart';
import 'pages/new_vault_page.dart';
import 'pages/restricted_vault_page.dart';

class VaultShowScreen extends StatelessWidget {
  const VaultShowScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    final vaultId = ModalRoute.of(context)!.settings.arguments as VaultId;
    return ChangeNotifierProvider(
      create: (_) => VaultShowPresenter(vaultId: vaultId),
      child: ScaffoldSafe(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            HeaderBar(
              captionSpans: buildTextWithId(id: vaultId),
              backButton: const HeaderBarBackButton(),
              closeButton: HeaderBarMoreButton(
                onPressed: () => OnVaultMoreDialog.show(
                  context,
                  vaultId: vaultId,
                ),
              ),
            ),
            // Body
            Expanded(
              child: Consumer<VaultShowPresenter>(
                builder: (_, presenter, __) {
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
}
