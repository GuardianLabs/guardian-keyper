import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/dialogs/qr_code_show_dialog.dart';

import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

import '../dialogs/on_show_id_dialog.dart';
import '../dialogs/on_vault_transfer_dialog.dart';
import '../widgets/copy_my_key_to_clipboard_button.dart';
import '../widgets/action_card.dart';
import '../dev_panel_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final selfId = GetIt.I<NetworkManager>().selfId;
    final vaultRepository = GetIt.I<VaultRepository>();
    return ListView(
      padding: paddingV20,
      children: [
        // Device Name
        StreamBuilder<NetworkManagerState>(
          stream: GetIt.I<NetworkManager>().state,
          builder: (context, snapshot) => Text(
            snapshot.data?.peerId.name ?? selfId.name,
            style: stylePoppins620,
          ),
        ),
        Row(
          children: [
            // My Key
            Text(
              selfId.toHexShort(),
              style: styleSourceSansPro414Purple,
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
            // TBD: change icon
            icon: const Icon(
              Icons.add,
              color: clGreen,
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
            // TBD: change icon
            icon: const Icon(
              Icons.replay,
              color: clGreen,
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
            // TBD: change icon
            icon: const Icon(
              Icons.shield_outlined,
              color: clGreen,
              size: 24,
            ),
            onTap: () async {
              final message =
                  await GetIt.I<MessageInteractor>().createJoinVaultCode();
              if (context.mounted) {
                QRCodeShowDialog.show(
                  context,
                  qrCode: message.toBase64url(),
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
                // TBD: change icon
                icon: const Icon(
                  Icons.auto_awesome_outlined,
                  color: clGreen,
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
              icon: const Icon(Icons.app_shortcut, color: clRed),
              title: 'DevPanel',
              subtitle: 'Shortcut to show mocked dialogs and components',
              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (context) => const DevPanelScreen(),
                fullscreenDialog: true,
              )),
            ),
          ),
      ],
    );
  }
}
