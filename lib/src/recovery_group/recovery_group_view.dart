import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme_data.dart';
import '../core/widgets/icon_of.dart';
import '../core/widgets/common.dart';
import 'create_group/create_group_view.dart';
import 'recovery_group_controller.dart';
import 'edit_group/recovery_group_edit_view.dart';

class RecoveryGroupView extends StatelessWidget {
  static const routeName = '/recovery_group';

  const RecoveryGroupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groups = Provider.of<RecoveryGroupController>(context).groups;

    return groups.isEmpty
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: IconOf.group(radius: 40),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('You don`t have any recovery groups'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: PrimaryTextButton(
                  text: 'Create Recovery Group',
                  onPressed: () =>
                      Navigator.pushNamed(context, CreateGroupView.routeName),
                ),
              ),
            ],
          )
        : ListView(
            primary: true,
            shrinkWrap: true,
            children: [
              for (final group in groups.values)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: ListTile(
                    tileColor: clIndigo700,
                    textColor: group.isMissed ? clRed : null,
                    iconColor: group.isMissed ? clRed : clIndigo700,
                    title: Text(group.name),
                    leading: const IconOf.app(),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child:
                              Text('${group.guardians.length}/${group.size}'),
                        ),
                        DotColored(
                            color: group.isCompleted
                                ? clGreen
                                : group.isNotCompleted
                                    ? clYellow
                                    : clRed),
                      ],
                    ),
                    onTap: () => Navigator.pushNamed(
                        context, RecoveryGroupEditView.routeName,
                        arguments: group.name),
                  ),
                )
            ],
          );
  }
}
