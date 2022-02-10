import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme_data.dart';
import '../../../widgets/common.dart';
import '../../../widgets/icon_of.dart';

import '../../recovery_group_model.dart';
import '../create_group_controller.dart';

class ChooseTypePage extends StatelessWidget {
  const ChooseTypePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CreateGroupController>(context);
    return Column(
      children: [
        // Header
        const HeaderBar(
          caption: 'Create Recovery Group',
          closeButton: HeaderBarCloseButton(),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              GestureDetector(
                onTap: () => state.groupType = RecoveryGroupType.devices,
                child: SimpleCard(
                  isSelected: state.group.type == RecoveryGroupType.devices,
                  bgColor: clIndigo700,
                  caption: 'Devices',
                  text:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod.',
                  leading: const IconOf.group(),
                ),
              ),
              const SizedBox(height: 10),
              SimpleCard(
                isSelected: state.group.type == RecoveryGroupType.fiduciaries,
                bgColor: clIndigo800,
                caption: 'Fiduciaries',
                text:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod.',
                leading: const IconOf.group(),
                trailing: Container(
                  height: 28,
                  width: 53,
                  alignment: Alignment.center,
                  decoration: decorBlueButton,
                  child: const Text('Soon'),
                ),
              ),
            ],
          ),
        ),
        // Footer
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: FooterButton(
            text: 'Continue',
            onPressed: state.group.type == RecoveryGroupType.none
                ? null
                : state.nextScreen,
          ),
        ),
        Container(height: 50),
      ],
    );
  }
}
