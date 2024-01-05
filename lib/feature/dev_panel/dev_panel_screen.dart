import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';
import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';
import 'package:guardian_keyper/feature/message/data/message_repository.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

import 'package:guardian_keyper/feature/onboarding/ui/onboarding_screen.dart';
import 'package:guardian_keyper/feature/message/ui/dialogs/on_message_active_dialog.dart';

class DevPanelScreen extends StatelessWidget {
  static const route = '/dev_panel';

  const DevPanelScreen({super.key});

  @override
  Widget build(BuildContext context) => ScaffoldSafe(
        header: const HeaderBar(
          caption: 'Developer panel',
          rightButton: HeaderBarButton.close(),
        ),
        isSeparated: true,
        children: [
          ListTile(
            title: const Text('Clear all Requests'),
            onTap: () async {
              await GetIt.I<MessageRepository>().clear();
              if (context.mounted) {
                showSnackBar(
                  context,
                  text: 'Requests has been cleared!',
                  isFloating: true,
                );
              }
            },
          ),
          ListTile(
            title: const Text('Clear all Safes'),
            onTap: () async {
              await GetIt.I<VaultRepository>().clear();
              if (context.mounted) {
                showSnackBar(
                  context,
                  text: 'Safes has been cleared!',
                  isFloating: true,
                );
              }
            },
          ),
          ListTile(
            title: const Text('Clear passcode'),
            onTap: () async {
              await GetIt.I<AuthManager>().setPassCode('');
              if (context.mounted) {
                showSnackBar(
                  context,
                  text: 'Passcode has been cleared!',
                  isFloating: true,
                );
              }
            },
          ),
          ListTile(
            title: const Text('Show Onboarding'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (context) => const OnboardingScreen(),
              fullscreenDialog: true,
              maintainState: false,
            )),
          ),
          ListTile(
            title: const Text('OnMessageActiveDialog'),
            subtitle: Text(MessageCode.createVault.name),
            onTap: () {
              final networkManager = GetIt.I<NetworkManager>();
              OnMessageActiveDialog.show(
                context,
                message: MessageModel(
                  code: MessageCode.createVault,
                  peerId: networkManager.selfId.copyWith(name: 'Myself'),
                  payload: Vault(
                    id: VaultId(name: 'Cool Vault'),
                    ownerId: networkManager.selfId.copyWith(name: 'Himself'),
                  ),
                ),
              );
            },
          ),
        ],
      );
}
