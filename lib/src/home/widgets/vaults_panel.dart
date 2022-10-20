import 'package:flutter/material.dart';

import '/src/core/theme/theme.dart';

import '../home_view.dart';
import '../home_controller.dart';
import '../pages/shards_page.dart';
import '../pages/vaults_page.dart';
import 'shards_count_button.dart';
import 'vaults_count_button.dart';

class VaultsPanel extends StatelessWidget {
  const VaultsPanel({super.key});

  @override
  Widget build(context) => Container(
        decoration: boxDecoration,
        padding: paddingAll20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: paddingBottom12,
              child: Text(
                'Vaults',
                textAlign: TextAlign.left,
                style: textStylePoppins616,
              ),
            ),
            Padding(
              padding: paddingBottom20,
              child: Text(
                'Create a Vault to secure your Secret with the help of your Guardians.',
                textAlign: TextAlign.left,
                style: textStyleSourceSansPro416.copyWith(color: clPurpleLight),
              ),
            ),
            // My Vaults
            Padding(
              padding: paddingV6,
              child: GestureDetector(
                onTap: () => context
                    .read<HomeController>()
                    .gotoScreen(HomeView.getPageNumber<VaultsPage>()),
                child: const VaultsCountButton(),
              ),
            ),
            // Stored Shards
            Padding(
              padding: paddingV6,
              child: GestureDetector(
                onTap: () => context
                    .read<HomeController>()
                    .gotoScreen(HomeView.getPageNumber<ShardsPage>()),
                child: const ShardsCountButton(),
              ),
            ),
            // Restore Vault
            Padding(
              padding: paddingV6,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(
                  '/recovery_group/restore',
                  arguments: false,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: clIndigo500,
                  ),
                  padding: paddingAll8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recovery',
                            style: textStyleSourceSansPro612,
                          ),
                          Text(
                            'Restore a Vault',
                            style: textStylePoppins616,
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios_outlined),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
