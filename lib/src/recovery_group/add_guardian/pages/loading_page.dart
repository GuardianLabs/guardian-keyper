import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/model/p2p_model.dart';
import '../add_guardian_controller.dart';
import '../../recovery_group_controller.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<RecoveryGroupController>();
    return StreamBuilder<P2PPacket>(
        initialData: P2PPacket.emptyBody(
          requestStatus: RequestStatus.idle,
          type: MessageType.authPeer,
        ),
        stream: controller.networkStream.stream,
        builder: (context, snapshot) {
          final state = context.read<AddGuardianController>();

          if (snapshot.hasError || !snapshot.hasData) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Name: ${state.guardianName}'),
                  Text('Error: ${snapshot.error}'),
                  Text('Stack Trace: ${snapshot.stackTrace}'),
                  Text('Packet Type: ${snapshot.data?.type.name}'),
                  Text('Packet Status: ${snapshot.data?.status.name}'),
                  Text('Packet Body: ${snapshot.data?.body}'),
                ]);
          }
          final p2pPacket = snapshot.data!;

          if (p2pPacket.requestStatus == RequestStatus.idle) {
            controller.sendAuthRequest(QRCode.fromBase64(state.guardianCode));
          } else if (p2pPacket.type == MessageType.authPeer &&
              p2pPacket.status == MessageStatus.success &&
              state.guardianName.isEmpty) {
            state.guardianName = p2pPacket.body.isEmpty
                ? 'No name'
                : String.fromCharCodes(p2pPacket.body);
            Future.delayed(const Duration(seconds: 1), state.nextScreen);
          }
          return const Center(child: CircularProgressIndicator.adaptive());
        });
  }
}
