import 'package:flutter/material.dart';

import '/src/core/theme/theme.dart';

import '../home_presenter.dart';

class ShardsCountButton extends StatelessWidget {
  const ShardsCountButton({super.key});

  @override
  Widget build(final BuildContext context) {
    final guardedVaults = context.watch<HomePresenter>().guardedVaults;
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
                '${guardedVaults.length} Shards',
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
