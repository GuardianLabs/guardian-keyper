import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';
import '/src/core/theme/theme.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/widgets/common.dart';

class VaultsPage extends StatelessWidget {
  const VaultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final diContainer = context.read<DIContainer>();
    final myPeerId = diContainer.myPeerId;
    return ValueListenableBuilder<Box<RecoveryGroupModel>>(
      valueListenable: diContainer.boxRecoveryGroups.listenable(),
      builder: (_, boxRecoveryGroups, __) {
        final guardedGroups =
            boxRecoveryGroups.values.where((e) => e.ownerId == myPeerId);
        return Column(
          children: [
            // Header
            const HeaderBar(caption: 'Vaults'),
            // Body
            if (guardedGroups.isEmpty) ...[
              Padding(
                padding: paddingV32,
                child: Text(
                  'Welcome to Vaults',
                  textAlign: TextAlign.center,
                  style: textStylePoppins620,
                  overflow: TextOverflow.clip,
                ),
              ),
              Text(
                'The Vaults is a place where you can securely keep your '
                'secrets such as seed phrases or passwords.',
                style: textStyleSourceSansPro416,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: paddingV32 + paddingH20,
                child: const _AddVaultButton(),
              ),
            ] else
              Expanded(
                child: ListView(
                  padding: paddingAll20,
                  children: [
                    for (final group in guardedGroups)
                      Padding(
                        padding: paddingV6,
                        child: _VaultListTile(group: group),
                      ),
                    const Padding(
                      padding: paddingV32,
                      child: _AddVaultButton(),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _AddVaultButton extends StatelessWidget {
  const _AddVaultButton();

  @override
  Widget build(BuildContext context) => PrimaryButton(
        text: 'Add a new Vault',
        onPressed: () => Navigator.pushNamed(
          context,
          '/recovery_group/create',
        ),
      );
}

class _VaultListTile extends StatelessWidget {
  final RecoveryGroupModel group;

  const _VaultListTile({required this.group});

  @override
  Widget build(BuildContext context) => ListTile(
        leading: const IconOf.shield(color: clWhite),
        title: Text(group.id.name, style: textStyleSourceSansPro614),
        subtitle: group.secrets.isNotEmpty
            ? Text(
                '${group.size} Guardians',
                style: textStyleSourceSansPro414,
              )
            : Text(
                'This Vault is not complited',
                style: textStyleSourceSansPro414.copyWith(color: clRed),
              ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: clWhite),
        onTap: () => Navigator.pushNamed(
          context,
          '/recovery_group/edit',
          arguments: group.id,
        ),
      );
}
