import 'package:flutter/material.dart';

import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';
import '/src/core/theme/theme.dart';

class VaultsCountButton extends StatelessWidget {
  const VaultsCountButton({super.key});

  @override
  Widget build(BuildContext context) {
    final diContainer = context.read<DIContainer>();
    final myPeerId = diContainer.myPeerId;
    return ValueListenableBuilder<Box<RecoveryGroupModel>>(
      valueListenable: diContainer.boxRecoveryGroups.listenable(),
      builder: (_, boxRecoveryGroups, __) {
        final groupsCount =
            boxRecoveryGroups.values.where((e) => e.ownerId == myPeerId).length;
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
}
