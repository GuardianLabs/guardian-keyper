import 'package:flutter/material.dart';

import 'package:guardian_keyper/src/core/ui/theme/theme.dart';
import 'package:guardian_keyper/src/vaults/ui/_dashboard/pages/vaults_page.dart';

import '../presenters/dashboard_presenter.dart';
import '../presenters/home_presenter.dart';

class VaultsCountButton extends StatelessWidget {
  const VaultsCountButton({super.key});

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: () => context.read<HomePresenter>().gotoPage<VaultsPage>(),
        child: Container(
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
                  Selector<DashboardPresenter, int>(
                    selector: (
                      final BuildContext context,
                      final DashboardPresenter presenter,
                    ) =>
                        presenter.vaultsCount,
                    builder: (
                      final BuildContext context,
                      final int vaultsCount,
                      final Widget? widget,
                    ) =>
                        Text(
                      '$vaultsCount Vaults',
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
