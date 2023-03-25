import '/src/core/consts.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/model/core_model.dart';

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
        subtitle: _buildSubtitle(group),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: clWhite),
        onTap: () => Navigator.pushNamed(
          context,
          routeGroupEdit,
          arguments: group.id,
        ),
      );

  Text _buildSubtitle(final RecoveryGroupModel group) {
    final styleRed = textStyleSourceSansPro414.copyWith(color: clRed);
    if (group.isRestoring) {
      return group.isRestricted
          ? Text('Restricted usage', style: styleRed)
          : Text('Complete the Recovery', style: styleRed);
    } else {
      return group.isFull
          ? Text(
              // TBD: i18n
              '${group.size} Guardians, ${group.secrets.length} Secrets',
              style: textStyleSourceSansPro414,
            )
          : Text('Add more Guardians', style: styleRed);
    }
  }
}
