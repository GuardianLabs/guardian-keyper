import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/action_card.dart';
import 'package:guardian_keyper/ui/theme/brand_colors.dart';

import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

import 'package:guardian_keyper/feature/home/ui/dialogs/on_show_id_dialog.dart';
import 'package:guardian_keyper/feature/message/ui/dialogs/on_qr_code_show_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_vault_transfer_dialog.dart';
import 'package:guardian_keyper/feature/home/ui/widgets/copy_my_key_to_clipboard_button.dart';

class DashboardList extends StatelessWidget {
  const DashboardList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brandColors = theme.extension<BrandColors>()!;
    final vaultRepository = GetIt.I<VaultRepository>();
    final networkManager = GetIt.I<NetworkManager>();
    final selfId = networkManager.selfId;
    return ListView(
      padding: paddingAll20,
      children: [
        // Device Name
        StreamBuilder<String>(
          stream: networkManager.state.map((e) => e.deviceName),
          builder: (context, snapshot) => Text(
            snapshot.data ?? selfId.name,
            style: theme.textTheme.titleLarge,
          ),
        ),
        Row(
          children: [
            // My Key
            Text(
              selfId.toHexShort(),
              style: theme.textTheme.bodySmall,
            ),
            // Copy to Clipboard
            CopyMyKeyToClipboardButton(id: selfId.asHex),
            // Show full ID
            IconButton(
              icon: const Icon(Icons.visibility_outlined),
              onPressed: () => OnShowIdDialog.show(
                context,
                id: selfId.asHex,
              ),
            ),
            const Spacer(),
            // Settings
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => Navigator.of(context).pushNamed(routeSettings),
            )
          ],
        ),
        // Create a Vault
        Padding(
          padding: paddingT20,
          child: ActionCard(
            icon: Icon(
              Icons.add,
              color: brandColors.highlightColor,
              size: 24,
            ),
            title: 'Create a Vault',
            subtitle: 'Safely store seed phrases, passwords, '
                'and codes in your Vault.',
            onTap: () => Navigator.of(context).pushNamed(routeVaultCreate),
          ),
        ),
        // Restore my Vault
        Padding(
          padding: paddingT20,
          child: ActionCard(
            icon: Icon(
              Icons.replay,
              color: brandColors.highlightColor,
              size: 24,
            ),
            title: 'Restore my Vault',
            subtitle: 'Recover your Vault with help of Guardians.',
            onTap: () => Navigator.of(context).pushNamed(routeVaultRestore),
          ),
        ),
        // Become a Guardian
        Padding(
          padding: paddingT20,
          child: ActionCard(
            title: 'Become a Guardian',
            subtitle: 'Safeguard a part of another user`s Vault.',
            icon: Icon(
              Icons.shield_outlined,
              color: brandColors.highlightColor,
              size: 24,
            ),
            onTap: () async {
              final message =
                  await GetIt.I<MessageInteractor>().createJoinVaultCode();
              if (context.mounted) {
                OnQRCodeShowDialog.show(
                  context,
                  message: message,
                  caption: 'Become a Guardian',
                  title: 'Guardian QR code',
                  subtitle:
                      'To become a Guardian, show the QR code below to the '
                      'Owner of the Vault. If sharing QR is not possible, '
                      'try sharing a text-code instead.',
                );
              }
            },
          ),
        ),
        // Assist with a Vault
        StreamBuilder<VaultRepositoryEvent>(
          stream: vaultRepository.watch(),
          builder: (context, _) => Offstage(
            offstage: vaultRepository.values.isEmpty,
            child: Padding(
              padding: paddingT20,
              child: ActionCard(
                icon: Icon(
                  Icons.auto_awesome_outlined,
                  color: brandColors.highlightColor,
                  size: 24,
                ),
                title: 'Assist with a Vault',
                subtitle: 'Provide assistance to restore a Vault '
                    'or transfer its ownership to another user.',
                onTap: () => OnVaultTransferDialog.show(context,
                    vaults: vaultRepository.values
                        .where((e) => e.ownerId != selfId)),
              ),
            ),
          ),
        ),
        // Dev panel
        if (kDebugMode)
          Padding(
            padding: paddingT20,
            child: ActionCard(
              icon: Icon(
                Icons.app_shortcut,
                color: brandColors.dangerColor,
              ),
              title: 'DevPanel',
              subtitle: 'Shortcut to show mocked dialogs and components',
              onTap: () => Navigator.of(context).pushNamed(routeDevPanel),
            ),
          ),
      ],
    );
  }
}
