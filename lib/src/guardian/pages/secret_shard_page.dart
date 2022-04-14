import 'package:flutter/material.dart';

import '../../core/theme_data.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/icon_of.dart';
import '../guardian_model.dart';
import 'scan_qr_code_page.dart';

class SecretShardPage extends StatelessWidget {
  final SecretShard secretShard;

  const SecretShardPage({
    Key? key,
    required this.secretShard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const HeaderBar(
              caption: 'Recovery Groups',
              backButton: HeaderBarBackButton(),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(20),
              child: ListTile(
                tileColor: clIndigo700,
                title: Text(secretShard.groupName),
                subtitle: Text('Owner: ${secretShard.ownerName}'),
                leading: const IconOf.app(),
                trailing: Text(
                    '${secretShard.groupSize}/${secretShard.groupThreshold}'),
              ),
            ),
            // Footer
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
              child: PrimaryTextButton(
                text: 'Change Owner',
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => BottomSheetWidget(
                    icon: const IconOf.group(radius: 40),
                    title: 'Change Owner',
                    text:
                        'Are you sure you want to change owner for MetaMask Wallet group? This action cannot be undone.',
                    footer: PrimaryTextButton(
                      text: 'Confirm',
                      onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          maintainState: false,
                          builder: (_) =>
                              ScanQRCodePage(secretShard: secretShard),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
