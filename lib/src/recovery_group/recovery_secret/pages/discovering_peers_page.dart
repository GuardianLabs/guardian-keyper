import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme_data.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/icon_of.dart';

import '../../recovery_group_model.dart';
import '../recovery_secret_controller.dart';
import '../../recovery_group_controller.dart';

class DiscoveryPeersPage extends StatefulWidget {
  const DiscoveryPeersPage({Key? key}) : super(key: key);

  @override
  State<DiscoveryPeersPage> createState() => _DiscoveryPeersPageState();
}

class _DiscoveryPeersPageState extends State<DiscoveryPeersPage> {
  late final RecoveryGroupModel _recoveryGroup;

  @override
  void initState() {
    super.initState();
    final state = context.read<RecoverySecretController>();
    _recoveryGroup =
        context.read<RecoveryGroupController>().groups[state.groupName]!;
    state.recoverySecret(_recoveryGroup.guardians);
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<RecoverySecretController>(context);
    final guardiansLeft = _recoveryGroup.threshold - state.guardians.length + 1;
    final isQuorum = state.guardians.length >= _recoveryGroup.threshold;
    final isFullHouse =
        state.guardians.length == _recoveryGroup.guardians.length;
    return Scaffold(
        body: Column(
      children: [
        // Header
        const HeaderBar(
          caption: 'Discovery peers',
          closeButton: HeaderBarCloseButton(),
        ),
        // Body
        const Padding(
          padding: EdgeInsets.only(top: 40, bottom: 10),
          child: IconOf.app(),
        ),
        state.secret.isEmpty
            ? Text('$guardiansLeft Guardian left to recover the secret',
                textAlign: TextAlign.center)
            : const Text('Your secret has been recovered and ready to be used.',
                textAlign: TextAlign.center),
        if (!isFullHouse)
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Align(child: CircularProgressIndicator()),
          ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              for (var guardian in _recoveryGroup.guardians.values)
                GuardianListTileWidget(
                  name: guardian.name,
                  code: guardian.pubKey.toString(),
                  tag: guardian.tag,
                  // nameColor: guardian.code.isEmpty ? clRed : clWhite,
                  iconColor: state.guardians.containsKey(guardian.name)
                      ? clGreen
                      : clIndigo500,
                  status: state.guardians.containsKey(guardian.name)
                      ? null
                      : clYellow,
                ),
            ],
          ),
        ),
        // Footer
        if (isQuorum)
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: FooterButton(
              text: 'Access Secret',
              onPressed: state.nextScreen,
            ),
          ),
        Container(height: 50),
      ],
    ));
  }
}
