import 'package:flutter/material.dart';
import 'package:p2plib/p2plib.dart' show PubKey;
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '../add_guardian_view.dart';
import '../add_guardian_controller.dart';
import '../../add_secret/add_secret_view.dart';
import '../../recovery_group_controller.dart';
import '../../recovery_group_model.dart';
import '../../widgets/guardian_tile_widget.dart';
import '../../widgets/shields_row_widget.dart';

class GuardianAddedPage extends StatelessWidget {
  const GuardianAddedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AddGuardianController>(context);
    final controller = Provider.of<RecoveryGroupController>(context);
    final recoveryGroup = controller.groups[state.groupName]!;
    final guardian = RecoveryGroupGuardianModel(
      name: state.guardianName,
      tag: state.guardianTag,
      pubKey: PubKey(state.guardianQRCode.pubKey),
      signPubKey: PubKey(state.guardianQRCode.signPubKey),
    );
    return Column(
      children: [
        // Header
        HeaderBar(
          title: HeaderBarTitleWithSubtitle(
            title: 'Recovery Group',
            subtitle: state.groupName,
          ),
          closeButton: const HeaderBarCloseButton(),
        ),
        // Body
        Expanded(
            child: ListView(
          primary: true,
          shrinkWrap: true,
          children: [
            const Padding(
              padding: paddingTop20,
              child: IconOf.shield(
                radius: 40,
                size: 40,
                color: clBlue,
                bage: BageType.ok,
              ),
            ),
            Padding(
              padding: paddingTop20,
              child: Text(
                'Guardian added',
                style: textStylePoppinsBold20,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: paddingAll20,
              child: Container(
                  decoration: boxDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GuardianTileWidget(
                        guardian: guardian,
                        isHighlighted: true,
                      ),
                      if (!recoveryGroup.isCompleted)
                        Padding(
                          padding: paddingAll20,
                          child: OutlinedButton(
                            child: const Text('Add Next Guardian'),
                            onPressed: () {
                              final groupName = state.groupName;
                              Navigator.popAndPushNamed(
                                context,
                                AddGuardianView.routeNameShowLastPage,
                                arguments: groupName,
                              );
                            },
                          ),
                        ),
                    ],
                  )),
            ),
            Padding(
              padding: paddingH20,
              child: Container(
                padding: paddingAll20,
                decoration: boxDecoration,
                child: Column(
                  children: [
                    Text('GUARDIANS ADDED',
                        style: textStyleSourceSansProBold12),
                    Padding(
                      padding: paddingAll20,
                      child: ShieldsRow(
                        total: recoveryGroup.maxSize,
                        highlighted: recoveryGroup.guardians.length,
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: textStyleSourceSansProRegular14.copyWith(
                          color: clPurpleLight,
                          height: 1.5,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                            text:
                                'To successfully add your secret, you need to\nadd from ',
                          ),
                          TextSpan(
                            text: '3 to 5',
                            style: textStyleSourceSansProBold14.copyWith(
                                color: clWhite),
                          ),
                          const TextSpan(
                            text: ' guardians to the group.\n',
                          ),
                          TextSpan(
                            text: 'Learn more',
                            style: textStyleSourceSansProBold14Blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20)
          ],
        )),
        // Footer
        if (recoveryGroup.size >= recoveryGroup.minSize)
          Padding(
            padding: paddingFooter,
            child: PrimaryButtonBig(
              text: 'Add Secret',
              onPressed: () {
                final groupName = state.groupName;
                Navigator.popAndPushNamed(
                  context,
                  RecoveryGroupAddSecretView.routeName,
                  arguments: groupName,
                );
              },
            ),
          ),
      ],
    );
  }
}
