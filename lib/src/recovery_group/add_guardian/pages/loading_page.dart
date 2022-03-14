import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/model/p2p_model.dart';
import '../add_guardian_controller.dart';
import '../../recovery_group_controller.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller =
        Provider.of<RecoveryGroupController>(context, listen: false);
    return StreamBuilder<P2PPacketStream>(
        initialData: const P2PPacketStream(requestStatus: RequestStatus.idle),
        stream: controller.networkStream.stream,
        builder: (context, snapshot) {
          final state =
              Provider.of<AddGuardianController>(context, listen: false);
          state.guardianPeer = snapshot.data?.p2pPacket?.peerPubKey;
          state.guardianName = snapshot.data?.p2pPacket?.body == null
              ? 'No name'
              : String.fromCharCodes(snapshot.data!.p2pPacket!.body);

          switch (snapshot.data?.requestStatus) {
            case RequestStatus.idle:
              controller.sendAuthRequest(QRCode.fromBase64(state.guardianCode));
              break;
            case RequestStatus.sent:
              Future.delayed(const Duration(seconds: 1), state.nextScreen);
              break;
            case RequestStatus.timeout:
              Future.delayed(const Duration(seconds: 1), state.previousScreen);
              break;
            // case RequestStatus.sending:
            // case RequestStatus.error:
            // case null:
            default:
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Center(child: CircularProgressIndicator.adaptive()),
              Text('Name: ${state.guardianName}'),
              Text('Error: ${snapshot.data?.error}'),
              Text('Stack Trace: ${snapshot.data?.stackTrace}'),
              Text('Request Status: ${snapshot.data?.requestStatus?.name}'),
              Text('Packet Status: ${snapshot.data?.p2pPacket?.status.name}'),
              Text('Packet Body: ${snapshot.data?.p2pPacket?.body}'),
            ],
          );
        });
  }
}
