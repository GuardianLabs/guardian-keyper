import 'package:amplitude_flutter/amplitude.dart';

import '/src/core/di_container.dart';
import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/model/core_model.dart';

import '../widgets/guardian_tile_widget.dart';
import '../add_guardian/add_guardian_view.dart';
import '../add_secret/add_secret_view.dart';
import '../recovery_secret/recovery_secret_view.dart';

class RecoveryGroupEditView extends StatelessWidget {
  static const routeName = '/recovery_group/edit';

  final GroupId groupId;

  const RecoveryGroupEditView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<Box<RecoveryGroupModel>>(
          valueListenable:
              context.read<DIContainer>().boxRecoveryGroup.listenable(),
          builder: (_, boxRecoveryGroup, __) {
            final group = boxRecoveryGroup.get(groupId.asKey);
            if (group == null) return const Scaffold();
            return ScaffoldWidget(
                child: Column(
              children: [
                // Header
                HeaderBar(
                  caption: group.name,
                  backButton: const HeaderBarBackButton(),
                  closeButton: HeaderBarMoreButton(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => BottomSheetWidget(
                        footer: ElevatedButton(
                          child: const SizedBox(
                              width: double.infinity,
                              child: Text(
                                'Remove Group',
                                textAlign: TextAlign.center,
                              )),
                          onPressed: () => showModalBottomSheet<Object?>(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) =>
                                _RemoveGroupConfirmWidget(group: group),
                          ).then(Navigator.of(context).pop),
                        ),
                      ),
                    ),
                  ),
                ),
                // Body
                Expanded(
                  child: ListView(
                    padding: paddingAll20,
                    children: [
                      // Group is not full
                      if (group.canAddGuardian)
                        Container(
                          decoration: boxDecoration,
                          padding: paddingAll20,
                          margin: paddingV20,
                          child: Column(
                            children: [
                              Padding(
                                padding: paddingBottom12,
                                child: Text(
                                  'Complete the Recovery Group',
                                  style: textStylePoppins620,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: [
                                  TextSpan(
                                    text:
                                        'Add ${group.neededMore} more Guardian',
                                    style: textStyleBold,
                                  ),
                                  TextSpan(
                                    text: ' to the group via QR Code to split '
                                        'and securely share parts of your Secret.',
                                    style: textStyleSourceSansPro416,
                                  ),
                                ]),
                              ),
                              Padding(
                                padding: paddingTop20,
                                child: PrimaryButton(
                                  text: 'Add via QR Code',
                                  onPressed: () => Amplitude.getInstance()
                                      .logEvent('AddGuardian Start')
                                      .then(
                                        (_) => Navigator.of(context).pushNamed(
                                          AddGuardianView.routeName,
                                          arguments: groupId,
                                        ),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      // Group is full
                      if (group.canAddSecret)
                        Container(
                          decoration: boxDecoration,
                          padding: paddingAll20,
                          margin: paddingV20,
                          child: Column(
                            children: [
                              Padding(
                                padding: paddingBottom12,
                                child: Text(
                                  'Group is ready, let’s add your Secret',
                                  style: textStylePoppins620,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(
                                'Remember: in order to restore your Secret'
                                ' in the future you’d have to get an approval'
                                ' from at least ${group.threshold} Guardians.',
                                style: textStyleSourceSansPro416,
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: paddingTop20,
                                child: PrimaryButton(
                                  text: 'Add Secret',
                                  onPressed: () => Amplitude.getInstance()
                                      .logEvent('AddSecret Start')
                                      .then(
                                        (_) => Navigator.of(context).pushNamed(
                                          RecoveryGroupAddSecretView.routeName,
                                          arguments: groupId,
                                        ),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (group.canRecoverSecret)
                        Padding(
                          padding: paddingV20,
                          child: Text(
                            'Guardians',
                            style: textStylePoppins620,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      // List of Guardians
                      for (var guardian in group.guardians.values)
                        Padding(
                          padding: paddingV6,
                          child: _GuardianTileWidget(guardian: guardian),
                        ),
                      // Group have Secret
                      if (group.canRecoverSecret)
                        Padding(
                          padding: paddingV32,
                          child: PrimaryButton(
                            text: 'Recover my Secret',
                            onPressed: () => Amplitude.getInstance()
                                .logEvent('RecoverSecret Start')
                                .then(
                                  (_) => Navigator.of(context).pushNamed(
                                    RecoveryGroupRecoverySecretView.routeName,
                                    arguments: groupId,
                                  ),
                                ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ));
          });
}

class _GuardianTileWidget extends StatefulWidget {
  const _GuardianTileWidget({required this.guardian});

  final GuardianModel guardian;

  @override
  State<_GuardianTileWidget> createState() => _GuardianTileWidgetState();
}

class _GuardianTileWidgetState extends State<_GuardianTileWidget> {
  bool? _isWaiting;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onLongPress: () async {
          if (_isWaiting != null) return; // Not yet ready for new ping
          final diContainer = context.read<DIContainer>();
          setState(() => _isWaiting = true);
          final startedAt = DateTime.now();
          final hasPong = await diContainer.networkService.pingPeer(
            peerId: widget.guardian.peerId,
            staticCheck: false,
          );
          if (!mounted) return;
          final msElapsed = DateTime.now().difference(startedAt).inMilliseconds;
          setState(() => _isWaiting = false);
          ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
            isError: !hasPong,
            textSpans: hasPong
                ? [
                    TextSpan(text: widget.guardian.name, style: textStyleBold),
                    TextSpan(text: ' is online.\nPing $msElapsed ms.'),
                  ]
                : [
                    const TextSpan(text: 'Couldn’t reach out to '),
                    TextSpan(text: widget.guardian.name, style: textStyleBold),
                    const TextSpan(text: '. Connection timeout.'),
                  ],
            duration: diContainer.globals.snackBarDuration,
          ));
          Future.delayed(
            diContainer.globals.snackBarDuration,
            () => mounted ? setState(() => _isWaiting = null) : null,
          );
        },
        child: GuardianTileWidget(
          guardian: widget.guardian,
          isWaiting: _isWaiting ?? false,
        ),
      );
}

class _RemoveGroupConfirmWidget extends StatelessWidget {
  final RecoveryGroupModel group;

  const _RemoveGroupConfirmWidget({required this.group});

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const IconOf.removeGroup(isBig: true, bage: BageType.warning),
        titleString: 'Remove Group',
        textSpan: <TextSpan>[
          const TextSpan(text: 'Are you sure that you want to remove '),
          TextSpan(text: group.name, style: textStyleBold),
          const TextSpan(text: ' group?'),
        ],
        footer: SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: 'Yes, remove Group',
            onPressed: () => context
                .read<DIContainer>()
                .boxRecoveryGroup
                .delete(group.id.asKey)
                .then((_) => Navigator.of(context).popUntil(
                    ModalRoute.withName(RecoveryGroupEditView.routeName))),
          ),
        ),
      );
}
