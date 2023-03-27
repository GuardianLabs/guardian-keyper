import '/src/core/consts.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/ui/widgets/icon_of.dart';

import '../home_presenter.dart';

class ShardPage extends StatelessWidget {
  final VaultId groupId;

  const ShardPage({super.key, required this.groupId});

  @override
  Widget build(final BuildContext context) {
    final vault = context.watch<HomePresenter>().guardedVaults[groupId]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        HeaderBar(
          captionSpans: buildTextWithId(id: groupId),
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
                    children: buildTextWithId(id: groupId),
                  ),
                ),
              ),
              Text(
                groupId.toHexShort(),
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
                    title: RichText(
                      text: TextSpan(
                        children: buildTextWithId(id: secretShard),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

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
            id: groupId,
            trailingText: '? This action cannot be undone.',
          ),
          footer: Column(
            children: [
              PrimaryButton(
                text: 'Confirm',
                onPressed: () async {
                  Navigator.of(context).pop();
                  final message = await context
                      .read<HomePresenter>()
                      .createTakeVaultCode(groupId);
                  if (context.mounted) {
                    Navigator.of(context).pushNamed(
                      routeQrCode,
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
