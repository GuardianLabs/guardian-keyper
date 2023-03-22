import 'package:flutter/material.dart';

import '/src/core/theme/theme.dart';

import '../home_controller.dart';

class VaultsCountButton extends StatelessWidget {
  const VaultsCountButton({super.key});

  @override
  Widget build(final BuildContext context) {
    final myVaults = context.watch<HomeController>().myVaults;
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
                '${myVaults.length} Vaults',
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
