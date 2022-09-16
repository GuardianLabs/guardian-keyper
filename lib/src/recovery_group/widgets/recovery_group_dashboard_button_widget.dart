import 'package:flutter/material.dart';

import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';
import '/src/core/theme_data.dart';

class RecoveryGroupDashboardButtonWidget extends StatelessWidget {
  const RecoveryGroupDashboardButtonWidget({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<
          Box<RecoveryGroupModel>>(
      valueListenable:
          context.read<DIContainer>().boxRecoveryGroup.listenable(),
      builder: (_, boxRecoveryGroup, __) => Container(
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
                      'My secrets',
                      style: textStyleSourceSansPro612.copyWith(color: clBlack),
                    ),
                    Text(
                      '${boxRecoveryGroup.keys.length} Groups',
                      style: textStylePoppins616.copyWith(color: clBlack),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios_outlined, color: clBlack),
              ],
            ),
          ));
}
