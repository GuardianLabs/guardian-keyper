import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/widgets/selectable_card.dart';
import '/src/core/model/p2p_model.dart' show RecoveryGroupType;

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
        // Body
        Expanded(
          child: ListView(
            padding: paddingAll20,
            children: [
              // Your Devices
              GestureDetector(
                onTap: () => state.groupType = RecoveryGroupType.devices,
                child: SelectableCard(
                    isSelected: state.groupType == RecoveryGroupType.devices,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const IconOf.yourDevices(
                            radius: 20, size: 16, bgColor: clWhite),
                        Padding(
                          padding: paddingTop20,
                          child: Text('Your Devices',
                              style: textStylePoppinsBold16),
                        ),
                        Padding(
                          padding: paddingTop10,
                          child: Text(
                            _textYourDevices,
                            style: textStyleSourceSansProRegular14.copyWith(
                                color: clPurpleLight),
                          ),
                        ),
                      ],
                    )),
              ),
              const SizedBox(height: 10),
              // Fiduciaries
              SelectableCard(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const IconOf.fiduciaries(
                          radius: 20, size: 20, bgColor: clWhite),
                      Container(
                        height: 28,
                        width: 53,
                        alignment: Alignment.center,
                        decoration: boxDecoration.copyWith(color: clIndigo500),
                        child: Text('Soon', style: textStylePoppinsBold12),
                      ),
                    ],
                  ),
                  Padding(
                    padding: paddingTop20,
                    child: Text('Fiduciaries', style: textStylePoppinsBold16),
                  ),
                  Padding(
                    padding: paddingTop10,
                    child: Text(
                      _textFiduciaries,
                      style: textStyleSourceSansProRegular14.copyWith(
                          color: clPurpleLight),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
        // Footer
        Padding(
          padding: paddingFooter,
          child: PrimaryButtonBig(
            text: 'Continue',
            onPressed: state.groupType == null ? null : state.nextScreen,
          ),
        ),
      ],
    );
  }
}

const _textYourDevices = '''
Your devices and devices that belong to your
Guardians, trusted people, friends and family
who act on your behalf when required.
''';

const _textFiduciaries = '''
Trusted appointed fiduciary third parties
appointed to act as Guardians on your
behalf on a professional basis.''';
