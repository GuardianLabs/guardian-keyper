import 'package:get_it/get_it.dart';
import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/ui/widgets/emoji.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';
import 'package:guardian_keyper/src/core/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/src/vaults/domain/vault_model.dart';
import 'package:guardian_keyper/src/message/domain/messages_interactor.dart';

class ShardScreen extends StatelessWidget {
  static const routeName = routeShardShow;

  static MaterialPageRoute<void> getPageRoute(final RouteSettings settings) =>
      MaterialPageRoute<VaultModel>(
        settings: settings,
        fullscreenDialog: true,
        builder: (final BuildContext context) =>
            ShardScreen(vault: settings.arguments as VaultModel),
      );

  const ShardScreen({super.key, required this.vault});

  final VaultModel vault;

  @override
  Widget build(final BuildContext context) => ScaffoldSafe(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            HeaderBar(
              captionSpans: buildTextWithId(id: vault.id),
              backButton: const HeaderBarBackButton(),
            ),
            // Body
            Padding(
              padding: paddingTop32 + paddingH20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: textStyleSourceSansPro414Purple,
                      children: buildTextWithId(id: vault.ownerId),
                    ),
                  ),
                  Padding(
                    padding: paddingV6,
                    child: RichText(
                      text: TextSpan(
                        style: textStylePoppins616,
                        children: buildTextWithId(id: vault.id),
                      ),
                    ),
                  ),
                  Text(
                    vault.id.toHexShort(),
                    style: textStyleSourceSansPro414,
                  ),
                  Padding(
                    padding: paddingTop12,
                    child: PrimaryButton(
                      text: 'Change Vault’s Owner',
                      onPressed: () => _showConfirmationDialog(context),
                    ),
                  ),
                  Padding(
                    padding: paddingTop32,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Secret Shards',
                          style: textStylePoppins620,
                        ),
                        Text(
                          vault.secrets.length.toString(),
                          style: textStylePoppins620,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Shards List
            Expanded(
              child: ListView(
                padding: paddingH20,
                children: [
                  for (final secretShard in vault.secrets.keys)
                    Padding(
                      padding: paddingV6,
                      child: ListTile(
                        title: Text(secretShard.name),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      );

  void _showConfirmationDialog(final BuildContext context) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (final BuildContext context) => BottomSheetWidget(
          icon: const IconOf.owner(
            isBig: true,
            bage: BageType.warning,
          ),
          titleString: 'Change Owner',
          textSpan: buildTextWithId(
            leadingText: 'Are you sure you want to change owner for vault ',
            id: vault.id,
            trailingText: '? This action cannot be undone.',
          ),
          footer: Column(
            children: [
              PrimaryButton(
                text: 'Confirm',
                onPressed: () async {
                  Navigator.of(context).pop();
                  final message = await GetIt.I<MessagesInteractor>()
                      .createTakeVaultCode(vault.id);
                  if (context.mounted) {
                    Navigator.of(context).pushNamed(
                      routeShowQrCode,
                      arguments: message,
                    );
                  }
                },
              ),
              const Padding(padding: paddingTop20),
              SizedBox(
                width: double.infinity,
                child: TertiaryButton(
                  text: 'Keep current Owner',
                  onPressed: Navigator.of(context).pop,
                ),
              ),
            ],
          ),
        ),
      );
}
