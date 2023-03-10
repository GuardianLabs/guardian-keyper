import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '../settings_cubit.dart';

class ToggleBootstrapListTile extends StatelessWidget {
  const ToggleBootstrapListTile({super.key});

  @override
  Widget build(final BuildContext context) =>
      BlocBuilder<SettingsCubit, SettingsModel>(
        bloc: GetIt.I<SettingsCubit>(),
        builder: (_, state) => SwitchListTile.adaptive(
          secondary: const IconOf.splitAndShare(),
          title: const Text('Proxy connection'),
          subtitle: const Text(
            'Connect through Keyper-operated proxy server',
          ),
          value: state.isBootstrapEnabled,
          onChanged: GetIt.I<SettingsCubit>().setIsBootstrapEnabled,
        ),
      );
}
