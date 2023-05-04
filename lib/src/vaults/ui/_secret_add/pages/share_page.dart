import 'package:guardian_keyper/src/core/ui/widgets/common.dart';

import '../presenters/vault_secret_add_presenter.dart';
import '../../widgets/guardian_self_list_tile.dart';
import '../../widgets/guardian_list_tile.dart';
import '../widgets/abort_header_button.dart';

class ShareSecretPage extends StatelessWidget {
  const ShareSecretPage({super.key});

  @override
  Widget build(final BuildContext context) {
    final presenter = context.read<VaultSecretAddPresenter>();
    return Column(
      children: [
        // Header
        HeaderBar(
          caption: 'Split Secret',
          backButton: HeaderBarBackButton(onPressed: presenter.previousPage),
          closeButton: const AbortHeaderButton(),
        ),
        // Body
        Expanded(
          child: ListView(
            padding: paddingH20,
            shrinkWrap: true,
            children: [
              PageTitle(
                title: 'Split and share Secret with Guardians below',
                subtitleSpans: [
                  const TextSpan(
                    text: 'You are about to split your Secret in ',
                  ),
                  TextSpan(
                    text: '${presenter.vault.maxSize} encrypted Shards.',
                  ),
                  const TextSpan(
                    text: ' Each Guardian will receieve their own'
                        ' Shard which can be used to restore your Secret.',
                  ),
                ],
              ),
              Column(children: [
                for (final guardian in presenter.vault.guardians.keys)
                  Padding(
                    padding: paddingV6,
                    child: guardian == presenter.vault.ownerId
                        ? GuardianSelfListTile(guardian: guardian)
                        : GuardianListTile(guardian: guardian),
                  )
              ]),
              // Footer
              Padding(
                padding: paddingV32,
                child: PrimaryButton(
                  text: 'Continue',
                  onPressed: presenter.nextPage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
