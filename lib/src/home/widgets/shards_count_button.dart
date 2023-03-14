import 'package:flutter/material.dart';

import '/src/core/theme/theme.dart';
import '/src/guardian/guardian_controller.dart';

class ShardsCountButton extends StatelessWidget {
  const ShardsCountButton({super.key});

  @override
  Widget build(final BuildContext context) =>
      ValueListenableBuilder<Box<RecoveryGroupModel>>(
        valueListenable: GetIt.I<Box<RecoveryGroupModel>>().listenable(),
        builder: (_, boxRecoveryGroups, __) {
          final myId = GetIt.I<GuardianController>().state;
          final groupsCount =
              boxRecoveryGroups.values.where((e) => e.ownerId != myId).length;
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
