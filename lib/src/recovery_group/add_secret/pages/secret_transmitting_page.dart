import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/model/p2p_model.dart';
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
    return StreamBuilder<P2PPacket>(
        // initialData: P2PPacket.emptyBody(requestStatus: RequestStatus.idle),
        initialData: P2PPacket.emptyBody(),
        stream: controller.networkStream.stream,
        builder: (context, snapshot) {
          final state = context.read<AddSecretController>();
          final recoveryGroup = controller.groups[state.groupName]!;
          if (snapshot.hasData) {
            if (snapshot.data?.status == MessageStatus.success) {
              state.addGuardian(recoveryGroup.guardians.values
                  .firstWhere((e) => e.pubKey == snapshot.data?.peerPubKey));
            }
          }
          return const Scaffold(body: SecretTransmittingBody());
        });
  }
}

class SecretTransmittingBody extends StatelessWidget {
  const SecretTransmittingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<RecoveryGroupController>();
    final state = Provider.of<AddSecretController>(context);
    final recoveryGroup = controller.groups[state.groupName]!;
    return Column(
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
        if (state.guardians.length != recoveryGroup.guardians.length)
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Align(child: CircularProgressIndicator()),
          ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              for (var guardian in recoveryGroup.guardians.values)
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
        if (state.guardians.length == recoveryGroup.guardians.length)
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
    );
  }
}
