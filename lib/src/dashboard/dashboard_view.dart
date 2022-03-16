import 'package:flutter/material.dart';
import 'package:guardian_network/src/core/model/p2p_model.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../core/widgets/common.dart';
// import '../core/widgets/icon_of.dart';
// import '../guardian/guardian_view.dart';
import '../settings/settings_controller.dart';
import '../guardian/guardian_controller.dart';
// import '../core/model/p2p_model.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GuardianController>(context);
    final size = MediaQuery.of(context).size.width - 20;
    return RefreshIndicator(
      onRefresh: () async => controller.generateAuthToken(),
      child: ListView(
        children: [
          // Header
          const HeaderBar(title: HeaderBarTitleLogo()),
          // Body
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            height: size,
            width: size,
            child: QrImage(
                data: controller
                    .getQRCode(
                        context.read<SettingsController>().keyPair.publicKey)
                    .toString()),
          ),
          StreamBuilder<P2PPacket>(
            initialData: P2PPacket.emptyBody(),
            stream: controller.p2pNetwork.stream,
            builder: (context, snapshot) => snapshot.hasError
                ? Column(
                    children: [
                      Text('Error: ${snapshot.error}'),
                      Text('Stack Trace: ${snapshot.stackTrace}'),
                    ],
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
