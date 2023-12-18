import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/data/repositories/settings_repository.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';
import 'package:guardian_keyper/feature/message/ui/dialogs/on_message_active_dialog.dart';

class DevPanelScreen extends StatelessWidget {
  const DevPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final networkManager = GetIt.I<NetworkManager>();
    final items = [
      ListTile(
        title: const Text('OnMessageActiveDialog'),
        subtitle: Text(MessageCode.createVault.name),
        onTap: () => OnMessageActiveDialog.show(
          context,
          message: MessageModel(
            code: MessageCode.createVault,
            peerId: networkManager.selfId.copyWith(name: 'Myself'),
            payload: Vault(
              ownerId: networkManager.selfId.copyWith(name: 'Himself'),
              id: VaultId(name: 'Cool Vault'),
            ),
          ),
        ),
      ),
      ListTile(
        title: const Text('show Intro'),
        onTap: () => Navigator.of(context).pushNamed(routeIntro),
      ),
      ListTile(
        title: const Text('Clear all Settings'),
        onTap: () async {
          await GetIt.I<SettingsRepository>().clear();
          if (context.mounted) {
            showSnackBar(
              context,
              text: 'Settings has been cleared!',
              isFloating: true,
            );
          }
        },
      ),
    ];
    return ScaffoldSafe(
        child: ListView.separated(
      padding: paddingAll20,
      itemCount: items.length,
      itemBuilder: (context, index) => items[index],
      separatorBuilder: (context, index) => const SizedBox(height: 20),
    ));
  }
}
