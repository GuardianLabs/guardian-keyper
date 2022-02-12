import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme_data.dart';
import '../widgets/icon_of.dart';
import '../widgets/common.dart';
import 'recovery_group_model.dart';
import 'recovery_group_controller.dart';
import 'create_group/create_group_view.dart';
import 'edit_group/recovery_group_edit_view.dart';

class RecoveryGroupView extends StatefulWidget {
  const RecoveryGroupView({Key? key}) : super(key: key);

  static const routeName = '/recovery_group';

  @override
  State<RecoveryGroupView> createState() => _RecoveryGroupViewState();
}

class _RecoveryGroupViewState extends State<RecoveryGroupView> {
  final _ctrl = TextEditingController();
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<RecoveryGroupController>(context);
    final recoveryGroups = List<RecoveryGroupModel>.from(state.groups.values)
        .where((element) =>
            element.name.toLowerCase().startsWith(_filter.toLowerCase()))
        .toList();
    recoveryGroups.sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
        primary: true,
        restorationId: 'RecoveryGroup',
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            // Header
            const HeaderBar(
              caption: 'Recovery Groups',
              backButton: HeaderBarBackButton(),
            ),
            // Search bar
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TextField(
                controller: _ctrl,
                restorationId: 'RecoveryGroupFilterInput',
                keyboardType: TextInputType.name,
                onChanged: (value) => setState(() => _filter = value),
                decoration: InputDecoration(
                  border: Theme.of(context).inputDecorationTheme.border,
                  filled: Theme.of(context).inputDecorationTheme.filled,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() {
                      _filter = '';
                      _ctrl.text = '';
                    }),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'GROUP',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      'GUARDIANS / STATUS',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ]),
            ),
            Expanded(
              child: ListView(
                children: [
                  for (final group in recoveryGroups)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 1, bottom: 1, left: 20, right: 20),
                      child: ListTile(
                        tileColor: clIndigo700,
                        textColor: group.status == RecoveryGroupStatus.missed
                            ? clRed
                            : null,
                        iconColor: group.status == RecoveryGroupStatus.missed
                            ? clRed
                            : clIndigo700,
                        title: Text(group.name),
                        leading: const IconOf.app(),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                  '${group.guardians.length}/${group.size}'),
                            ),
                            DotColored(
                                color: _colorOfGroupStatus(group.status)),
                          ],
                        ),
                        onTap: () => Navigator.pushNamed(
                            context, RecoveryGroupEditView.routeName,
                            arguments: group.name),
                      ),
                    )
                ],
              ),
            ),
            // Footer
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: FooterButton(
                text: 'Create New Group',
                onPressed: () {
                  _filter = '';
                  _ctrl.text = '';
                  Navigator.pushNamed(context, CreateGroupView.routeName);
                },
              ),
            ),
            Container(height: 50),
          ],
        ));
  }

  Color _colorOfGroupStatus(RecoveryGroupStatus status) {
    switch (status) {
      case RecoveryGroupStatus.completed:
        return clGreen;
      case RecoveryGroupStatus.notCompleted:
        return clYellow;
      case RecoveryGroupStatus.missed:
        return clRed;
    }
  }
}
