import 'package:flutter/material.dart';

import '/src/core/theme_data.dart';

import '../guardian_controller.dart';

class GuardianDashboardButtonWidget extends StatelessWidget {
  const GuardianDashboardButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GuardianController>(context);
    return Container(
      decoration: BoxDecoration(borderRadius: borderRadius, color: clYellow),
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
                '${controller.secretShards.length} Shards',
                style: textStylePoppins616.copyWith(color: clBlack),
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios_outlined, color: clBlack),
        ],
      ),
    );
  }
}
