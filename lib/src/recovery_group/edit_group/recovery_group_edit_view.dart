import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/widgets/common.dart';
import '/src/recovery_group/widgets/guardian_tile_widget.dart';

import '../add_guardian/add_guardian_view.dart';
import '../add_secret/add_secret_view.dart';
import '../recovery_secret/recovery_secret_view.dart';

import '../recovery_group_controller.dart';

class RecoveryGroupEditView extends StatelessWidget {
  static const routeName = '/recovery_group_edit';

  final String recoveryGroupName;

  const RecoveryGroupEditView({
    Key? key,
    required this.recoveryGroupName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<RecoveryGroupController>(context);
    final recoveryGroup = state.groups[recoveryGroupName]!;
    final groupSize =
        recoveryGroup.isCompleted ? recoveryGroup.size : recoveryGroup.maxSize;
    return Scaffold(
        primary: true,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              HeaderBar(
                caption: recoveryGroupName,
                backButton: const HeaderBarBackButton(),
                closeButton: HeaderBarMoreButton(
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => BottomSheetWidget(
                      footer: ListTile(
                        title:
                            Text('Remove Group', style: textStylePoppinsBold16),
                        trailing: const IconOf.trash(radius: 20, size: 20),
                        onTap: () {
                          Navigator.of(context).pop();
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => _RemoveGroupConfirmWidget(
                                  recoveryGroupName: recoveryGroupName));
                        },
                      ),
                      haveCloseButton: true,
                    ),
                  ),
                ),
              ),
              // Body
              Expanded(
                  child: ListView(
                primary: true,
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: paddingAll20,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('GUARDIANS',
                              style: textStyleSourceSansProBold12),
                          Text(
                            '${recoveryGroup.guardians.length} / $groupSize',
                            style: textStyleSourceSansProBold12,
                          ),
                        ]),
                  ),
                  Padding(
                    padding: paddingH20,
                    child: Card(
                      child: Column(
                        children: [
                          for (var guardian in recoveryGroup.guardians.values)
                            GuardianTileWidget(
                              guardian: guardian,
                              isHighlighted: true,
                            ),
                          if (!recoveryGroup.isCompleted)
                            ListTile(
                              title: OutlinedButton(
                                child: const Text('Add Guardian'),
                                onPressed: () => Navigator.of(context)
                                    .pushNamed(AddGuardianView.routeName,
                                        arguments: recoveryGroupName),
                              ),
                            ),
                          if (!recoveryGroup.isCompleted)
                            Padding(
                              padding: paddingAll20,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style:
                                      textStyleSourceSansProRegular14.copyWith(
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
                                      style: textStyleSourceSansProBold14
                                          .copyWith(color: clWhite),
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
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: paddingAll20,
                    child: Card(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('Test Guardians',
                                textAlign: TextAlign.center,
                                style: textStylePoppinsBold14.copyWith(
                                    color: Colors.white38)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: borderRadius,
                              color: clIndigo600,
                            ),
                            margin: paddingAll8,
                            padding: paddingAll8,
                            child: Text('Soon', style: textStylePoppinsBold10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (recoveryGroup.size == recoveryGroup.maxSize)
                    const Padding(
                      padding: paddingAll20,
                      child: InfoPanel.info(
                          text:
                              'You have reached the maximum number of Guardians in a group.'),
                    ),
                ],
              )),
              // Footer
              if (recoveryGroup.hasMinimal)
                Padding(
                  padding: paddingFooter,
                  child: recoveryGroup.secrets.isEmpty
                      ? PrimaryButtonBig(
                          text: 'Add Secret',
                          onPressed: () => Navigator.of(context).pushNamed(
                              RecoveryGroupAddSecretView.routeName,
                              arguments: recoveryGroupName))
                      : PrimaryButtonBig(
                          text: 'Secret Recovery',
                          onPressed: () => Navigator.of(context).pushNamed(
                              RecoveryGroupRecoverySecretView.routeName,
                              arguments: recoveryGroupName)),
                ),
            ],
          ),
        ));
  }
}

class _RemoveGroupConfirmWidget extends StatelessWidget {
  final String recoveryGroupName;

  const _RemoveGroupConfirmWidget({
    Key? key,
    required this.recoveryGroupName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      icon: const IconOf.removeGroup(
          radius: 40, size: 40, bage: BageType.warning),
      titleString: 'Remove group',
      textSpan: <TextSpan>[
        TextSpan(
          text: 'Are you sure that you want to remove\n',
          style: textStyleSourceSansProRegular16,
        ),
        TextSpan(
          text: recoveryGroupName,
          style: textStyleSourceSansProBold16,
        ),
        TextSpan(
          text: ' group?',
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
              await context
                  .read<RecoveryGroupController>()
                  .removeGroup(recoveryGroupName);
              Navigator.of(context).popUntil(ModalRoute.withName('/'));
            },
          ))
        ],
      ),
      haveCloseButton: true,
    );
  }
}
