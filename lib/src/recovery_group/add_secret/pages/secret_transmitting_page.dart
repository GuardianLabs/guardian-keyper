import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme_data.dart';
import '../../../core/widgets/common.dart';
// import '../../../core/widgets/icon_of.dart';

import '../../recovery_group_model.dart';
import '../add_secret_controller.dart';
import '../../recovery_group_controller.dart';

class SecretTransmittingPage extends StatelessWidget {
  const SecretTransmittingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<RecoveryGroupController>();
    final state = Provider.of<AddSecretController>(context);
    final recoveryGroup = controller.groups[state.groupName]!;
    return Scaffold(
      body: Column(
        children: [
          // Header
          const HeaderBar(
            caption: 'Distribute Secret',
            // backButton: HeaderBarBackButton(onPressed: state.previousScreen),
            closeButton: HeaderBarCloseButton(),
          ),
          // Body
          const Padding(
            padding: EdgeInsets.only(top: 40, bottom: 10),
            child: Icon(Icons.key_outlined, size: 40),
          ),
          const Text('The secret is being sharded and transmitted ',
              textAlign: TextAlign.center),
          if (state.peers.length != recoveryGroup.guardians.length)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Align(child: CircularProgressIndicator()),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.distributeShards(
                  recoveryGroup.guardians.values
                      .map((e) => e.pubKey)
                      .toSet()
                      .difference(state.peers),
                  recoveryGroup.id,
                  state.secret,
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
          if (state.peers.length == recoveryGroup.guardians.length)
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: FooterButton(
                text: 'Done',
                onPressed: () {
                  context.read<RecoveryGroupController>().addSecret(
                      state.groupName,
                      RecoveryGroupSecretModel(
                        name: 'TheOne',
                        token: state.secret,
                      ));
                  Navigator.of(context).pop();
                },
              ),
            ),
          Container(height: 50),
        ],
      ),
    );
  }
}
