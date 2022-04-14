import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme_data.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/icon_of.dart';
import '../../core/model/p2p_model.dart';
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
        child: StreamBuilder<P2PPacket>(
            initialData: null,
            stream: controller.p2pNetwork.stream,
            builder: ((context, snapshot) {
              if (snapshot.hasError) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Error: ${snapshot.error}'),
                      Text('Stack Trace: ${snapshot.stackTrace}'),
                    ]);
              }
              return Column(
                children: [
                  // Header
                  const HeaderBar(caption: 'Ownership change'),
                  // Icon
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: IconOf.group(radius: 40),
                  ),
                  // Caption
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Confirm ownership change',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Text
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      '${qrCode.peerName} has asked you to change the owner for ${secretShard.groupName}, please approve the request',
                      style: GoogleFonts.sourceSansPro(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Info Card
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: clIndigo700,
                        borderRadius: borderRadius,
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('GROUP NAME'),
                              Text(secretShard.groupName),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('FROM'),
                              Text(secretShard.ownerName),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(base64Encode(secretShard.owner)
                                .substring(0, 16)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('TO'),
                              Text(qrCode.peerName),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                base64Encode(qrCode.pubKey).substring(0, 16)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('STATUS'),
                              if (snapshot.hasError) const Text('Error'),
                              if (snapshot.hasData &&
                                  snapshot.data?.status ==
                                      MessageStatus.success)
                                const Text('Success'),
                              if (snapshot.data == null)
                                const Text('Awaiting your approval'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Footer
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: SecondaryTextButton(
                            text: 'Reject',
                            onPressed: Navigator.of(context).pop,
                          ),
                        ),
                        Container(width: 10),
                        Expanded(
                          child: PrimaryTextButton(
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
              );
            })),
      ),
    );
  }
}
