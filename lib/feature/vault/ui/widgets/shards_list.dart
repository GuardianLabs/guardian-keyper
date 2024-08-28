import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';
import 'package:guardian_keyper/feature/message/ui/dialogs/on_qr_code_show_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_become_owner_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_change_owner_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_vault_transfer_dialog.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

class ShardsList extends StatelessWidget {
  const ShardsList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vaultInteractor = GetIt.I<VaultInteractor>();

    return StreamBuilder<Object>(
      stream: vaultInteractor.watch(),
      builder: (context, _) {
        final shards = vaultInteractor.shards.toList();
        return Padding(
          padding: paddingAll20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: shards.isEmpty
                    ? const Center(
                        child: PageTitle(
                          title: 'Shards will appear here',
                          subtitle:
                              'Shards you are guarding will be displayed here. Each shard is a secure '
                              'component of someone else`s Secret, essential for collective recovery, '
                              'yet individually reveals no information.',
                        ),
                      )
                    : ListView.separated(
                        separatorBuilder: (_, __) =>
                            const Padding(padding: paddingT12),
                        itemCount: shards.length,
                        itemBuilder: (context, index) {
                          final vault = shards[index];
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(cornerRadius),
                              ),
                              color: theme.colorScheme.surface,
                            ),
                            child: vault.hasNoSecrets
                                ? ListTile(
                                    visualDensity: VisualDensity.standard,
                                    minTileHeight: 88,
                                    title: Text(vault.id.name),
                                    subtitle: Text(
                                      'Owner: ${vault.ownerId.name}\n'
                                      '${vault.secrets.length} Shard(s)',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      strutStyle: const StrutStyle(height: 1.5),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0,
                                      horizontal: 16,
                                    ),
                                  )
                                : ExpansionTile(
                                    key: PageStorageKey(vault.id.name),
                                    visualDensity: VisualDensity.standard,
                                    minTileHeight: 88,
                                    title: Text(vault.id.name),
                                    subtitle: Text(
                                      'Owner: ${vault.ownerId.name}\n'
                                      '${vault.secrets.length} Shard(s)',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      strutStyle: const StrutStyle(height: 1.5),
                                    ),
                                    childrenPadding: EdgeInsets.zero,
                                    children: [
                                      Divider(
                                        height: 1,
                                        color: theme.colorScheme.primary
                                            .withOpacity(0.6),
                                      ),
                                      Column(
                                        children: [
                                          for (final secretShard
                                              in vault.secrets.keys)
                                            ListTile(
                                              title: Text(secretShard.name),
                                            ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            child: Padding(
                                              padding: paddingB12,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  FilledButton(
                                                    onPressed: () =>
                                                        OnBecomeOwnerDialog
                                                            .show(
                                                      context,
                                                      vault: vault,
                                                    ),
                                                    child:
                                                        const Text('Own Safe'),
                                                  ),
                                                  FilledButton(
                                                    onPressed: () =>
                                                        OnChangeOwnerDialog
                                                            .show(
                                                      context,
                                                      vaultId: vault.id,
                                                    ),
                                                    child: const Text(
                                                        'Help Restore'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                          );
                        },
                      ),
              ),

              //Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.shield,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                        onPressed: () async {
                          final message = await GetIt.I<MessageInteractor>()
                              .createJoinVaultCode();
                          if (context.mounted) {
                            OnQRCodeShowDialog.show(
                              context,
                              message: message,
                              caption: 'Become a Guardian',
                              title: 'Guardian QR code',
                              subtitle:
                                  'To become a Guardian, show the QR code below to the '
                                  'Safe Owner. If sharing the QR code is not possible, '
                                  'share the text-code instead.',
                            );
                          }
                        },
                        padding: EdgeInsets.zero,
                      ),
                      const Padding(
                        padding: paddingT12,
                        child: Text('Become a Guardian'),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.auto_awesome_outlined,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                        onPressed: () => OnVaultTransferDialog.show(
                          context,
                          vaults: vaultInteractor.shards,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      const Padding(
                        padding: paddingT12,
                        child: Text('Help Restore a Safe'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
