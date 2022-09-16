import '/src/core/theme_data.dart';
import '/src/core/widgets/misc.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/model/core_model.dart';

import '../edit_group/recovery_group_edit_view.dart';

class RecoveryGroupTileWidget extends StatelessWidget {
  final RecoveryGroupModel group;

  const RecoveryGroupTileWidget({super.key, required this.group});

  @override
  Widget build(BuildContext context) => ListTile(
        leading: const IconOf.shield(color: clWhite),
        title: Text(group.name, style: textStyleSourceSansPro614),
        subtitle: group.hasSecret && group.isNotRestoring
            ? Text(
                '${group.maxSize} Guardians',
                style: textStyleSourceSansPro414,
              )
            : Text(
                group.isRestoring
                    ? 'This group is not yet restored'
                    : 'This group is not yet finished',
                style: textStyleSourceSansPro414.copyWith(color: clRed),
              ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: clWhite),
        onTap: () => Navigator.pushNamed(
          context,
          RecoveryGroupEditView.routeName,
          arguments: group.id,
        ),
      );
}
