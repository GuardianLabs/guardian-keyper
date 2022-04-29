import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '../add_secret_controller.dart';
import '../../recovery_group_controller.dart';
import '../../widgets/guardian_tile_widget.dart';

class SplitAndShareSecretPage extends StatelessWidget {
  const SplitAndShareSecretPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AddSecretController>(context);
    final controller = context.read<RecoveryGroupController>();
    final group = controller.groups[state.groupName]!;

    return Column(
      children: [
        // Header
        const HeaderBar(closeButton: HeaderBarCloseButton()),
        // Body
        Expanded(
          child: ListView(
            padding: paddingH20,
            primary: true,
            shrinkWrap: true,
            children: [
              const IconOf.splitAndShare(radius: 40, size: 40),
              Padding(
                padding: paddingAll20,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Your secret ', style: textStylePoppinsBold20),
                      TextSpan(
                          text: 'will be split and shared ',
                          style: textStylePoppinsBold20Blue),
                      TextSpan(
                          text: 'among the following Guardians',
                          style: textStylePoppinsBold20),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: paddingBottom20,
                child: RichText(
                  text: TextSpan(
                    style: textStyleSourceSansProBold12,
                    children: <TextSpan>[
                      const TextSpan(text: 'GUARDIANS '),
                      TextSpan(
                          text: group.size.toString(),
                          style: const TextStyle(color: clBlue)),
                    ],
                  ),
                ),
              ),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var guardian in group.guardians.values)
                      GuardianTileWidget(guardian: guardian)
                  ],
                ),
              ),
            ],
          ),
        ),
        // Footer
        Padding(
          padding: paddingFooter,
          child: PrimaryButtonBig(
            text: 'Split and Share Secret',
            onPressed: () {
              state.shards = controller.splitSecret(state.secret, group);
              state.nextScreen();
            },
          ),
        ),
      ],
    );
  }
}
