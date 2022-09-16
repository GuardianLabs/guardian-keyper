import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/model/core_model.dart';

import '../guardian_controller.dart';
import '../pages/show_qr_code_page.dart';

class SecretTileWidget extends StatelessWidget {
  final SecretShardModel secretShard;
  final bool isExpanded;
  final void Function(GroupId? groupId)? setExpanded;

  const SecretTileWidget({
    super.key,
    required this.secretShard,
    this.isExpanded = false,
    this.setExpanded,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(color: clSurface),
        ),
        clipBehavior: Clip.hardEdge,
        foregroundDecoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(color: clSurface, width: 2),
        ),
        child: ExpansionTile(
          key: Key(secretShard.groupId.asHex),
          initiallyExpanded: isExpanded,
          onExpansionChanged: (isExpanded) =>
              setExpanded?.call(isExpanded ? secretShard.groupId : null),
          leading: const IconOf.shield(color: clWhite),
          title: Text(
            secretShard.groupName,
            style: textStylePoppins616,
          ),
          subtitle: RichText(
            textAlign: TextAlign.left,
            overflow: TextOverflow.clip,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Owner: ',
                  style: textStyleSourceSansPro414Purple,
                ),
                TextSpan(
                  text: secretShard.ownerName,
                  style: textStyleSourceSansPro614,
                ),
              ],
            ),
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('OWNER ID', style: textStyleSourceSansPro612Purple),
                Text(
                  secretShard.ownerId.toHexShort(),
                  style: textStyleSourceSansPro414,
                ),
              ],
            ),
            Padding(
              padding: paddingTop20,
              child: PrimaryButton(
                text: 'Change Owner',
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => _ConfirmChangeOwnershipDialogWidget(
                    secretShard: secretShard,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _ConfirmChangeOwnershipDialogWidget extends StatelessWidget {
  final SecretShardModel secretShard;

  const _ConfirmChangeOwnershipDialogWidget({required this.secretShard});

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const IconOf.owner(isBig: true, bage: BageType.warning),
        titleString: 'Change Owner',
        textString: 'Are you sure you want to change owner'
            ' for ${secretShard.groupName} group?'
            ' This action cannot be undone.',
        footer: PrimaryButton(
          text: 'Confirm',
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                fullscreenDialog: true,
                maintainState: false,
                builder: (BuildContext context) => ScaffoldWidget(
                    child: ShowQRCodePage(
                        qrCode: context
                            .read<GuardianController>()
                            .getQrCode(secretShard)))),
          ),
        ),
      );
}
