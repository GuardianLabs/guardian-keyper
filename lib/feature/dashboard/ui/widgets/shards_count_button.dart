import 'package:flutter/material.dart';

import 'package:guardian_keyper/ui/theme/theme.dart';
import 'package:guardian_keyper/feature/home/ui/home_presenter.dart';

import '../dashboard_presenter.dart';

class ShardsCountButton extends StatelessWidget {
  const ShardsCountButton({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: context.read<HomePresenter>().gotoShards,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius8,
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
                    style: styleSourceSansPro612.copyWith(color: clBlack),
                  ),
                  Selector<DashboardPresenter, int>(
                    selector: (_, presenter) => presenter.shardsCount,
                    builder: (_, shardsCount, __) => Text(
                      '$shardsCount Shards',
                      style: stylePoppins616.copyWith(color: clBlack),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios_outlined, color: clBlack),
            ],
          ),
        ),
      );
}
