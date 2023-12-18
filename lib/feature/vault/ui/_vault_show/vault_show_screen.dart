import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../../domain/entity/vault_id.dart';
import 'vault_show_presenter.dart';
import 'pages/vault_page.dart';
import 'pages/new_vault_page.dart';
import 'pages/restricted_vault_page.dart';
import 'dialogs/on_vault_more_dialog.dart';

class VaultShowScreen extends StatelessWidget {
  const VaultShowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vaultId = ModalRoute.of(context)!.settings.arguments! as VaultId;
    return ChangeNotifierProvider(
      create: (_) => VaultShowPresenter(vaultId: vaultId),
      child: Consumer<VaultShowPresenter>(
        builder: (_, presenter, __) => ScaffoldSafe(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              HeaderBar(
                captionSpans: buildTextWithId(id: vaultId),
                backButton: const HeaderBarBackButton(),
                closeButton: HeaderBarMoreButton(
                  onPressed: () => OnVaultMoreDialog.show(context, presenter),
                ),
              ),
              // Body
              Expanded(
                child: presenter.vault.isRestricted
                    ? const RestrictedVaultPage()
                    : presenter.vault.isNotFull
                        ? const NewVaultPage()
                        : const VaultPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
