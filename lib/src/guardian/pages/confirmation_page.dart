import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/core/utils.dart';
import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/model/p2p_model.dart';

import '../guardian_controller.dart';
import '../guardian_model.dart';

class ConfirmationPage extends StatelessWidget {
  final SecretShard secretShard;
  final QRCode qrCode;

  const ConfirmationPage({
    Key? key,
    required this.secretShard,
    required this.qrCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<GuardianController>();
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        // Header
        const HeaderBar(caption: 'Ownership change'),
        // Body
        Expanded(
            child: ListView(
          primary: true,
          shrinkWrap: true,
          children: [
            // Icon
            const Padding(
              padding: paddingAll20,
              child: IconOf.owner(
                radius: 40,
                size: 40,
                bage: BageType.warning,
              ),
            ),
            // Caption
            Padding(
              padding: paddingAll20,
              child: Text(
                'Confirm ownership change',
                style: textStylePoppinsBold20,
                textAlign: TextAlign.center,
              ),
            ),
            // Text
            Padding(
              padding: paddingAll20,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: textStyleSourceSansProRegular16,
                  children: <TextSpan>[
                    TextSpan(
                      text: qrCode.peerName,
                      style: textStyleSourceSansProBold16,
                    ),
                    const TextSpan(
                        text: ' has asked you to change the owner for '),
                    TextSpan(
                      text: secretShard.groupName,
                      style: textStyleSourceSansProBold16,
                    ),
                    const TextSpan(text: ', please approve the request'),
                  ],
                ),
              ),
            ),
            // Info Card
            Padding(
              padding: paddingAll20,
              child: SecretShardCard(secretShard: secretShard, qrCode: qrCode),
            ),
            // Informer
            Padding(
              padding: paddingAll20,
              child: InfoPanel.info(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: textStyleSourceSansProRegular16,
                    children: <TextSpan>[
                      const TextSpan(
                        text:
                            'When the majority of Guardians confirm this operation, ',
                      ),
                      TextSpan(
                        text: qrCode.peerName,
                        style: textStyleSourceSansProBold16,
                      ),
                      const TextSpan(text: 'will become a new owner of '),
                      TextSpan(
                        text: secretShard.groupName,
                        style: textStyleSourceSansProBold16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
        // Footer
        Padding(
          padding: paddingFooter,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: const Text('Reject'),
                  style: buttonStyleSecondary,
                  onPressed: Navigator.of(context).pop,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: PrimaryButtonBig(
                  text: 'Confirm',
                  onPressed: () async {
                    await controller.sendTakeOwnershipRequest(
                        qrCode, secretShard);
                    await controller.changeOwnership(
                        secretShard, qrCode.pubKey, qrCode.peerName);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    )));
  }
}

class SecretShardCard extends StatelessWidget {
  const SecretShardCard({
    Key? key,
    required this.secretShard,
    required this.qrCode,
  }) : super(key: key);

  final SecretShard secretShard;
  final QRCode qrCode;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<GuardianController>();
    return StreamBuilder<P2PPacket>(
        initialData: null,
        stream: controller.p2pNetwork.stream,
        builder: (context, snapshot) {
          return Container(
            decoration: boxDecoration,
            padding: paddingAll20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'GROUP NAME',
                      style: textStyleSourceSansProBold12.copyWith(
                          color: clPurpleLight),
                    ),
                    Text(
                      secretShard.groupName,
                      style: textStyleSourceSansProBold16,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'FROM',
                      style: textStyleSourceSansProBold12.copyWith(
                          color: clPurpleLight),
                    ),
                    Text(
                      secretShard.ownerName,
                      style: textStyleSourceSansProBold16,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    toHexShort(secretShard.owner),
                    style: textStyleSourceSansProRegular14.copyWith(
                        color: Colors.cyan.shade50),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TO',
                      style: textStyleSourceSansProBold12.copyWith(
                          color: clPurpleLight),
                    ),
                    Text(
                      qrCode.peerName,
                      style: textStyleSourceSansProBold16,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    toHexShort(qrCode.pubKey),
                    style: textStyleSourceSansProRegular14.copyWith(
                        color: Colors.cyan.shade50),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
