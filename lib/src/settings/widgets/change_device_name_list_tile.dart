import '/src/core/di_container.dart';
import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '../pages/set_device_name_page.dart';

class ChangeDeviceNameListTile extends StatelessWidget {
  const ChangeDeviceNameListTile({super.key});

  @override
  Widget build(BuildContext context) => ListTile(
        leading: const IconOf.shardOwner(),
        title: const Text('Change Guardian name'),
        subtitle: Text(
          context.read<DIContainer>().myPeerId.emoji,
          style: textStyleSourceSansPro414Purple,
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const ScaffoldWidget(child: SetDeviceNamePage()),
        )),
      );
}
