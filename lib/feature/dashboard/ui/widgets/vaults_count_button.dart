import 'package:flutter/material.dart';

import 'package:guardian_keyper/ui/theme/theme.dart';
import 'package:guardian_keyper/ui/screens/home_screen.dart';

import '../dashboard_presenter.dart';

class VaultsCountButton extends StatelessWidget {
  const VaultsCountButton({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: context.findAncestorStateOfType<HomeScreenState>()?.gotoVaults,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius8,
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
                    style: styleSourceSansPro612.copyWith(color: clBlack),
                  ),
                  Selector<DashboardPresenter, int>(
                    selector: (_, presenter) => presenter.vaultsCount,
                    builder: (_, vaultsCount, __) => Text(
                      '$vaultsCount Vaults',
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
