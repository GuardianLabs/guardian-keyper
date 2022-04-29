import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '../recovery_secret_controller.dart';
import '../../widgets/guardian_tile_widget.dart';
import '../../widgets/shields_row_widget.dart';

class DiscoveryPeersPage extends StatefulWidget {
  const DiscoveryPeersPage({Key? key}) : super(key: key);

  @override
  State<DiscoveryPeersPage> createState() => _DiscoveryPeersPageState();
}

class _DiscoveryPeersPageState extends State<DiscoveryPeersPage> {
  @override
  void initState() {
    super.initState();
    context.read<RecoverySecretController>().requestShards();
  }

  @override
  void dispose() {
    context.read<RecoverySecretController>().timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<RecoverySecretController>(context);
    final guardiansLeft = state.group.threshold - state.shards.length;
    final isQuorum = state.shards.length >= state.group.threshold;
    return Column(
      children: [
        // Header
        const HeaderBar(
          caption: 'Secret Recovery',
          closeButton: HeaderBarCloseButton(),
        ),
        // Body
        Expanded(
            child: ListView(
          primary: true,
          shrinkWrap: true,
          padding: paddingH20,
          children: [
            // Icon
            PaddingTop(
              child: isQuorum
                  ? const IconOf.secretRecovered(radius: 40, size: 40)
                  : const IconOf.app(radius: 40, size: 40),
            ),
            // Shields
            Padding(
              padding: paddingTop40,
              child: ShieldsRow(
                total: state.group.size,
                highlighted: state.shards.length,
                isInSquare: true,
              ),
            ),
            // Text
            Padding(
              padding: paddingTop40,
              child: isQuorum
                  ? Text(
                      'Your secret has been recovered and is ready for use.',
                      style: textStyleSourceSansProRegular14.copyWith(
                          color: clPurpleLight),
                      textAlign: TextAlign.center,
                    )
                  : RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                '$guardiansLeft Guardian${guardiansLeft > 1 ? 's' : ''} ',
                            style: textStyleSourceSansProBold14,
                          ),
                          TextSpan(
                            text: 'left to recover the secret',
                            style: textStyleSourceSansProRegular14.copyWith(
                                color: clPurpleLight),
                          ),
                        ],
                      ),
                    ),
            ),
            // Guardians
            Padding(
              padding: paddingTop40,
              child: Card(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var guardian in state.group.guardians.values)
                    GuardianTileWidget(
                      guardian: guardian,
                      isHighlighted: state.shards.containsKey(guardian.pubKey),
                      isWaiting: !state.shards.containsKey(guardian.pubKey),
                    )
                ],
              )),
            ),
          ],
        )),
        // Footer
        if (isQuorum)
          Padding(
            padding: paddingFooter,
            child: PrimaryButtonBig(
              text: 'Access Secret',
              onPressed: state.nextScreen,
            ),
          ),
      ],
    );
  }
}
