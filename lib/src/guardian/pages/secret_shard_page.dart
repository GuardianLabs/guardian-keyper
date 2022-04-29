import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/core/utils.dart';
import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '../guardian_model.dart';
import '../guardian_controller.dart';
import 'scan_qr_code_page.dart';

class SecretShardPage extends StatelessWidget {
  final SecretShard secretShard;

  const SecretShardPage({
    Key? key,
    required this.secretShard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            HeaderBar(
              caption: secretShard.groupName,
              backButton: const HeaderBarBackButton(),
              closeButton: HeaderBarMoreButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => BottomSheetWidget(
                    haveCloseButton: true,
                    footer: ListTile(
                      title: Text(
                        'Remove Secret Shard',
                        style: textStylePoppinsBold16,
                      ),
                      trailing: const IconOf.trash(radius: 20, size: 20),
                      onTap: () {
                        Navigator.of(context).pop();
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => _RemoveSecretShardConfirmWidget(
                            secretShard: secretShard,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            // Body
            Expanded(
                child: ListView(
              padding: paddingH20,
              primary: true,
              shrinkWrap: true,
              children: [
                Text(
                  'OWNER',
                  style: textStyleSourceSansProBold12,
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: paddingTop10,
                  child: ListTile(
                    leading: IconOf.shardOwner(
                      radius: 18,
                      size: 22,
                      bgColor: theme.colorScheme.secondary,
                    ),
                    title: Row(
                      children: [
                        Text(
                          secretShard.ownerName,
                          maxLines: 1,
                          style: textStyleSourceSansProBold16,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: borderRadius,
                              color: theme.colorScheme.secondary,
                            ),
                            child: Text(
                              '   Owner   ',
                              style: textStyleSourceSansProRegular12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      toHexShort(secretShard.owner),
                      style: textStyleSourceSansProBold12.copyWith(
                          color: clPurpleLight),
                    ),
                  ),
                ),
                Padding(
                  padding: paddingTop20,
                  child: Text(
                    'RECOVERY GROUP',
                    style: textStyleSourceSansProBold12,
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: paddingTop10,
                  child: Card(
                    child: Padding(
                      padding: paddingAll20,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'GROUP NAME',
                                style: textStyleSourceSansProBold12.copyWith(
                                  color: clPurpleLight,
                                  fontSize: 10,
                                ),
                              ),
                              Text(secretShard.groupName),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'GROUP ID',
                                style: textStyleSourceSansProBold12.copyWith(
                                  color: clPurpleLight,
                                  fontSize: 10,
                                ),
                              ),
                              Text(toHexShort(secretShard.groupId)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'DESCRIPTION',
                                style: textStyleSourceSansProBold12.copyWith(
                                  color: clPurpleLight,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                  '${secretShard.groupThreshold} / ${secretShard.groupSize}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
            // Footer
            Padding(
              padding: paddingFooter,
              child: PrimaryButtonBig(
                text: 'Change Owner',
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => BottomSheetWidget(
                    haveCloseButton: true,
                    icon: const IconOf.owner(
                      radius: 40,
                      size: 40,
                      bage: BageType.warning,
                    ),
                    titleString: 'Change Owner',
                    textString:
                        'Are you sure you want to change owner for ${secretShard.groupName} group? This action cannot be undone.',
                    footer: PrimaryButtonBig(
                      text: 'Confirm',
                      onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          maintainState: false,
                          builder: (_) =>
                              ScanQRCodePage(secretShard: secretShard),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RemoveSecretShardConfirmWidget extends StatelessWidget {
  final SecretShard secretShard;

  const _RemoveSecretShardConfirmWidget({
    Key? key,
    required this.secretShard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      icon: const IconOf.removeGroup(
          radius: 40, size: 40, bage: BageType.warning),
      titleString: 'Remove secret shard',
      textSpan: <TextSpan>[
        TextSpan(
          text: 'Are you sure that you want to remove\n',
          style: textStyleSourceSansProRegular16,
        ),
        TextSpan(
          text: secretShard.groupName,
          style: textStyleSourceSansProBold16,
        ),
        TextSpan(
          text: ' secret shard?',
          style: textStyleSourceSansProRegular16,
        ),
      ],
      footer: Row(
        children: [
          Expanded(
              child: ElevatedButton(
            child: const Text('Remove'),
            style: buttonStyleDestructive,
            onPressed: () async {
              await context.read<GuardianController>().removeShard(secretShard);
              Navigator.of(context).popUntil(ModalRoute.withName('/'));
            },
          ))
        ],
      ),
      haveCloseButton: true,
    );
  }
}
