import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/widgets/common.dart';

import 'widgets/recovery_group_tile_widget.dart';
import 'create_group/create_group_view.dart';
import 'recovery_group_controller.dart';

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
                padding: paddingV20,
                child: IconOf.groups(radius: 40, size: 30),
              ),
              RichText(
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.clip,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'You don`t have any\n',
                      style: textStylePoppinsBold20,
                    ),
                    TextSpan(
                      text: 'recovery groups',
                      style: textStylePoppinsBold20Blue,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: PrimaryButtonBig(
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
                  child: RecoveryGroupTileWidget(group: group),
                )
            ],
          );
  }
}
