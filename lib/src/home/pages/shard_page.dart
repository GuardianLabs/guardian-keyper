import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';

import 'qr_code_page.dart';

class ShardPage extends StatelessWidget {
  final GroupId groupId;

  const ShardPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<Box<RecoveryGroupModel>>(
        valueListenable: context
            .read<DIContainer>()
            .boxRecoveryGroups
            .listenable(keys: [groupId.asKey]),
        builder: (context, boxRecoveryGroups, __) {
          final recoveryGroup = boxRecoveryGroups.get(groupId.asKey)!;
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
                        children: buildTextWithId(id: recoveryGroup.ownerId),
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
                          Text('Secret Shards', style: textStylePoppins620),
                          Text(
                            recoveryGroup.secrets.length.toString(),
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
                    for (final secretShard in recoveryGroup.secrets.keys)
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
        },
      );

  void _showConfirmationDialog(final BuildContext context) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (final BuildContext context) => BottomSheetWidget(
          icon: const IconOf.owner(isBig: true, bage: BageType.warning),
          titleString: 'Change Owner',
          textSpan: buildTextWithId(
            leadingText: 'Are you sure you want to change owner for vault ',
            id: groupId,
            trailingText: '? This action cannot be undone.',
          ),
          footer: PrimaryButton(
            text: 'Confirm',
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                fullscreenDialog: true,
                maintainState: false,
                builder: (_) => QRCodePage(groupId: groupId),
              ),
            ),
          ),
        ),
      );
}
