import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '../settings_repository.dart';
import '../pages/set_device_name_page.dart';

class ChangeDeviceNameListTile extends StatelessWidget {
  const ChangeDeviceNameListTile({super.key});

  @override
  Widget build(final BuildContext context) =>
      BlocSelector<SettingsRepository, SettingsModel, String>(
        selector: (state) => state.deviceName,
        bloc: GetIt.I<SettingsRepository>(),
        builder: (final BuildContext context, final deviceName) => ListTile(
          leading: const IconOf.shardOwner(),
          title: const Text('Change Guardian name'),
          subtitle: Text(
            deviceName,
            style: textStyleSourceSansPro414Purple,
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const SetDeviceNamePage(),
          )),
        ),
      );
}
