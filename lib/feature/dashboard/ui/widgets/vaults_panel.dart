import 'package:flutter/material.dart';

import 'package:guardian_keyper/ui/theme/theme.dart';

import 'restore_vault_button.dart';
import 'shards_count_button.dart';
import 'vaults_count_button.dart';

class VaultsPanel extends StatelessWidget {
  const VaultsPanel({super.key});

  @override
  Widget build(BuildContext context) => Container(
        decoration: boxDecoration,
        padding: paddingAll20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: paddingB12,
              child: Text(
                'Vaults',
                textAlign: TextAlign.left,
                style: stylePoppins616,
              ),
            ),
            Padding(
              padding: paddingB20,
              child: Text(
                'Create a Vault to secure your Secret '
                'with the help of your Guardians.',
                style: styleSourceSansPro416Purple,
                textAlign: TextAlign.left,
              ),
            ),
            // My Vaults
            const Padding(padding: paddingV6, child: VaultsCountButton()),
            // Stored Shards
            const Padding(padding: paddingV6, child: ShardsCountButton()),
            // Restore Vault
            const Padding(padding: paddingV6, child: RestoreVaultButton()),
          ],
        ),
      );
}
