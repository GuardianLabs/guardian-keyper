import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme_data.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/icon_of.dart';

import '../../../core/model/p2p_model.dart' show RecoveryGroupType;
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
                  isSelected: state.groupType == RecoveryGroupType.devices,
                  bgColor: clIndigo700,
                  caption: 'Devices',
                  text:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod.',
                  leading: const IconOf.group(),
                ),
              ),
              const SizedBox(height: 10),
              SimpleCard(
                isSelected: state.groupType == RecoveryGroupType.fiduciaries,
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
          child: PrimaryTextButton(
            text: 'Continue',
            onPressed: state.groupType == null ? null : state.nextScreen,
          ),
        ),
        Container(height: 50),
      ],
    );
  }
}
