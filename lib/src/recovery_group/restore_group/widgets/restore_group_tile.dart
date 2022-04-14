import 'package:flutter/material.dart';

import '../../../core/theme_data.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/icon_of.dart';

import '../restore_group_view.dart';

const bottomSheetText =
    'Lost access to your device used to store your secrets? No problem, you can restore access for each recovery group here.';
const bottomSheetList = [
  'Now ask each of your Guardians within the group to open their Guardian app',
  'They must select your group',
  'Direct them to click "Change Owner"',
  'Show them your QR code',
];

class RestoreGroupListTile extends StatelessWidget {
  const RestoreGroupListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Restore Group'),
      subtitle: const Text('Restore access to my group'),
      leading: const CircleAvatar(backgroundColor: clIndigo500),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => BottomSheetWidget(
          icon: const IconOf.group(radius: 40), // TBD: create new icon
          title: 'Restore Group',
          text: bottomSheetText,
          body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: clIndigo700,
            ),
            child: const NumberedListWidget(list: bottomSheetList),
          ),
          footer: PrimaryTextButton(
            text: 'Show QR Code',
            onPressed: () {
              Navigator.of(context).popAndPushNamed(RestoreGroupView.routeName);
            },
          ),
        ),
      ),
    );
  }
}
