import '/src/core/model/core_model.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/widgets/common.dart';

class VaultListTile extends StatelessWidget {
  final RecoveryGroupModel group;

  const VaultListTile({super.key, required this.group});

  @override
  Widget build(final BuildContext context) => ListTile(
        leading: const IconOf.shield(color: clWhite),
        title: RichText(
          text: TextSpan(
            style: textStyleSourceSansPro614,
            children: buildTextWithId(id: group.id),
          ),
        ),
        subtitle: group.isRestoring
            ? Text(
                'Complete the Vault recovery',
                style: textStyleSourceSansPro414.copyWith(color: clRed),
              )
            : group.isFull
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
