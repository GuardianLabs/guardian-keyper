import 'package:flutter/material.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/misc.dart';
import '/src/core/widgets/icon_of.dart';

import '../recovery_group_model.dart';
import '../edit_group/recovery_group_edit_view.dart';

class RecoveryGroupTileWidget extends StatelessWidget {
  final RecoveryGroupModel group;

  const RecoveryGroupTileWidget({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = group.isMissed ? clRed : clYellow;
    return ListTile(
      dense: true,
      textColor: group.isMissed ? clRed : null,
      iconColor: group.isMissed ? clRed : theme.colorScheme.onPrimary,
      leading: const IconOf.shield(radius: 18, size: 20),
      title: Text(group.name, style: textStylePoppinsBold16),
      subtitle: RichText(
        textAlign: TextAlign.left,
        overflow: TextOverflow.clip,
        text: TextSpan(
          style: textStyleSourceSansProBold14,
          children: <TextSpan>[
            TextSpan(
              text: group.guardians.length.toString(),
              style: TextStyle(color: group.isCompleted ? clGreen : color),
            ),
            TextSpan(text: '/${group.size}'),
          ],
        ),
      ),
      trailing: group.isCompleted ? null : DotColored(color: color),
      onTap: () => Navigator.pushNamed(
        context,
        RecoveryGroupEditView.routeName,
        arguments: group.name,
      ),
    );
  }
}
