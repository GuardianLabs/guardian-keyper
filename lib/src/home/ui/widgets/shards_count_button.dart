import 'package:flutter/material.dart';

import 'package:guardian_keyper/src/core/ui/theme/theme.dart';
import 'package:guardian_keyper/src/vaults/ui/_dashboard/pages/shards_page.dart';

import '../presenters/dashboard_presenter.dart';
import '../presenters/home_presenter.dart';

class ShardsCountButton extends StatelessWidget {
  const ShardsCountButton({super.key});

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: () => context.read<HomePresenter>().gotoPage<ShardsPage>(),
        child: Container(
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
                  Selector<DashboardPresenter, int>(
                    selector: (
                      final BuildContext context,
                      final DashboardPresenter presenter,
                    ) =>
                        presenter.shardsCount,
                    builder: (
                      final BuildContext context,
                      final int shardsCount,
                      final Widget? widget,
                    ) =>
                        Text(
                      '$shardsCount Shards',
                      style: textStylePoppins616.copyWith(color: clBlack),
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
