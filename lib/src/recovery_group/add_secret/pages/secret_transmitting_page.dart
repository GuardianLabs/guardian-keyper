import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '../add_secret_controller.dart';
import '../../recovery_group_controller.dart';
import '../../widgets/guardian_tile_widget.dart';
import '../../widgets/shields_row_widget.dart';

class SecretTransmittingPage extends StatefulWidget {
  const SecretTransmittingPage({Key? key}) : super(key: key);

  @override
  State<SecretTransmittingPage> createState() => _SecretTransmittingPageState();
}

class _SecretTransmittingPageState extends State<SecretTransmittingPage> {
  @override
  void initState() {
    super.initState();
    context.read<AddSecretController>().distributeShards();
  }

  @override
  void dispose() {
    context.read<AddSecretController>().timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<RecoveryGroupController>();
    final state = Provider.of<AddSecretController>(context);
    final recoveryGroup = controller.groups[state.groupName]!;
    final confirmed = recoveryGroup.guardians.length - state.shards.length;

    return Column(
      children: [
        // Header
        const HeaderBar(closeButton: HeaderBarCloseButton()),
        // Body
        Expanded(
          child: ListView(
            padding: paddingAll20,
            children: [
              const IconOf.splitAndShare(radius: 40, size: 40),
              Padding(
                padding: paddingAll20,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '$confirmed of ${recoveryGroup.size} ',
                        style: textStylePoppinsBold20Blue,
                      ),
                      TextSpan(
                          text: 'Guardians have confirmed receipt',
                          style: textStylePoppinsBold20),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: paddingAll20,
                child: ShieldsRow(
                  highlighted: confirmed,
                  total: recoveryGroup.size,
                  isInSquare: true,
                ),
              ),
              Container(
                decoration: boxDecoration,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var guardian in recoveryGroup.guardians.values)
                      GuardianTileWidget(
                        guardian: guardian,
                        isHighlighted:
                            !state.shards.containsKey(guardian.pubKey),
                        isWaiting: state.shards.containsKey(guardian.pubKey),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
        // Footer
        if (state.shards.isEmpty)
          Padding(
            padding: paddingFooter,
            child: PrimaryButtonBig(
              text: 'Done',
              onPressed: Navigator.of(context).pop,
            ),
          ),
      ],
    );
  }
}
