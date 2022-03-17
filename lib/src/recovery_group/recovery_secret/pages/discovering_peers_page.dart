import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme_data.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/icon_of.dart';

import '../recovery_secret_controller.dart';
import '../../recovery_group_controller.dart';

class DiscoveryPeersPage extends StatelessWidget {
  const DiscoveryPeersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<RecoverySecretController>(context);
    final controller = context.read<RecoveryGroupController>();
    final recoveryGroup = controller.groups[state.groupName]!;

    final guardiansLeft = recoveryGroup.threshold - state.peers.length + 1;
    final isQuorum = state.peers.length >= recoveryGroup.threshold;
    final isFullHouse = state.peers.length == recoveryGroup.guardians.length;

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
              : const Text(
                  'Your secret has been recovered and ready to be used.',
                  textAlign: TextAlign.center),
          if (!isFullHouse)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Align(child: CircularProgressIndicator()),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                state.error = null;
                state.stackTrace = null;
                await controller.requestShards(
                  recoveryGroup.guardians.values
                      .map((e) => e.pubKey)
                      .toSet()
                      .difference(state.peers),
                  recoveryGroup.id,
                );
              },
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  for (var guardian in recoveryGroup.guardians.values)
                    GuardianListTileWidget(
                      name: guardian.name,
                      code: guardian.pubKey.toString(),
                      tag: guardian.tag,
                      // nameColor: guardian.code.isEmpty ? clRed : clWhite,
                      iconColor: state.peers.contains(guardian.pubKey)
                          ? clGreen
                          : clIndigo500,
                      status: state.peers.contains(guardian.pubKey)
                          ? null
                          : clYellow,
                    ),
                  if (state.error != null) Text('Error: ${state.error}'),
                  if (state.stackTrace != null)
                    Text('Stack Trace: ${state.stackTrace}'),
                ],
              ),
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
      ),
    );
  }
}
