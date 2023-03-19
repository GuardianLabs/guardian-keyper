import '/src/core/consts.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/repository/repository_root.dart';

class RemoveVaultBottomSheet extends StatelessWidget {
  const RemoveVaultBottomSheet({super.key, required this.group});

  final RecoveryGroupModel group;

  @override
  Widget build(final BuildContext context) => BottomSheetWidget(
        footer: ElevatedButton(
          child: const SizedBox(
            width: double.infinity,
            child: Text(
              'Remove the Vault',
              textAlign: TextAlign.center,
            ),
          ),
          onPressed: () => showModalBottomSheet<Object?>(
            context: context,
            isScrollControlled: true,
            builder: (_) => BottomSheetWidget(
              icon: const IconOf.removeGroup(
                isBig: true,
                bage: BageType.warning,
              ),
              titleString: 'Do you want to remove this Vault?',
              textString:
                  'All the Secrets from this Vault will be removed as well.',
              footer: SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Yes, remove the Vault',
                  onPressed: () => GetIt.I<RepositoryRoot>()
                      .vaultRepository
                      .delete(group.aKey)
                      .then(
                        (_) => Navigator.of(context).popUntil(
                          ModalRoute.withName(routeGroupEdit),
                        ),
                      ),
                ),
              ),
            ),
          ).then(Navigator.of(context).pop),
        ),
      );
}
