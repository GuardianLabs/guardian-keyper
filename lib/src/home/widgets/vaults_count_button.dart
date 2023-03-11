import 'package:flutter/material.dart';

import '/src/core/di_container.dart';
import '/src/core/theme/theme.dart';
import '/src/core/model/core_model.dart';
import '/src/settings/settings_controller.dart';

class VaultsCountButton extends StatelessWidget {
  const VaultsCountButton({super.key});

  @override
  Widget build(final BuildContext context) =>
      ValueListenableBuilder<Box<RecoveryGroupModel>>(
        valueListenable: GetIt.I<DIContainer>().boxRecoveryGroups.listenable(),
        builder: (_, boxRecoveryGroups, __) {
          final myId = GetIt.I<SettingsController>().state.deviceId;
          final groupsCount =
              boxRecoveryGroups.values.where((e) => e.ownerId == myId).length;
          return Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: clGreen,
            ),
            padding: paddingAll8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Vaults',
                      style: textStyleSourceSansPro612.copyWith(color: clBlack),
                    ),
                    Text(
                      '$groupsCount Groups',
                      style: textStylePoppins616.copyWith(color: clBlack),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios_outlined, color: clBlack),
              ],
            ),
          );
        },
      );
}
