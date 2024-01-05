import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/settings/bloc/theme_mode_cubit.dart';

class ThemeModeSwitcher extends StatelessWidget {
  const ThemeModeSwitcher({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ThemeModeCubit, ThemeMode>(
        bloc: GetIt.I<ThemeModeCubit>(),
        builder: (context, state) => SegmentedButton<ThemeMode>(
          segments: const [
            ButtonSegment(
              label: Text('Light'),
              value: ThemeMode.light,
            ),
            ButtonSegment(
              label: Text('System'),
              value: ThemeMode.system,
            ),
            ButtonSegment(
              label: Text('Dark'),
              value: ThemeMode.dark,
            ),
          ],
          showSelectedIcon: false,
          emptySelectionAllowed: false,
          multiSelectionEnabled: false,
          selected: {state},
          onSelectionChanged: (values) =>
              GetIt.I<ThemeModeCubit>().setThemeMode(values.first),
        ),
      );
}
