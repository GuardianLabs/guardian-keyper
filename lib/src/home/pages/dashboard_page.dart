import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/recovery_group/restore_group/restore_group_view.dart';
import '/src/settings/settings_controller.dart';
import '/src/guardian/guardian_controller.dart';
import '/src/core/model/p2p_model.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GuardianController>(context);
    return RefreshIndicator(
      onRefresh: () async => controller.generateAuthToken(),
      child: ListView(
        children: [
          // Header
          const HeaderBar(title: HeaderBarTitleLogo()),
          // Body
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.width * 0.75,
            child: QrImage(
                foregroundColor: Colors.white,
                data: controller
                    .getQRCode(
                        context.read<SettingsController>().keyPair.publicKey)
                    .toString()),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ListTile(
              title: const Text('Restore Group'),
              subtitle: const Text('Restore access to my group'),
              leading: const CircleAvatar(backgroundColor: clIndigo500),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () =>
                  Navigator.of(context).pushNamed(RestoreGroupView.routeName),
            ),
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
