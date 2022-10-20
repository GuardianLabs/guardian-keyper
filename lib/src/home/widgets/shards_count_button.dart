import 'package:flutter/material.dart';

import '/src/core/theme/theme.dart';
import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';

class ShardsCountButton extends StatelessWidget {
  const ShardsCountButton({super.key});

  @override
  Widget build(BuildContext context) {
    final diContainer = context.read<DIContainer>();
    final myPeerId = diContainer.myPeerId;
    return ValueListenableBuilder<Box<RecoveryGroupModel>>(
      valueListenable: diContainer.boxRecoveryGroups.listenable(),
      builder: (_, boxRecoveryGroups, __) {
        final groupsCount =
            boxRecoveryGroups.values.where((e) => e.ownerId != myPeerId).length;
        return Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: clYellow,
          ),
          padding: paddingAll8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stored Shards',
                    style: textStyleSourceSansPro612.copyWith(color: clBlack),
                  ),
                  Text(
                    '$groupsCount Shards',
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
