import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/data/repositories/settings_repository.dart';

class ThemeModeSwitcher extends StatelessWidget {
  const ThemeModeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsRepository = GetIt.I<SettingsRepository>();
    return StreamBuilder(
      initialData: settingsRepository.get<bool>(
        PreferencesKeys.keyIsDarkModeOn,
      ),
      stream: settingsRepository
          .watch<bool>(PreferencesKeys.keyIsDarkModeOn)
          .map((event) => event.value),
      builder: (context, snapshot) {
        return SegmentedButton<bool?>(
          segments: const [
            ButtonSegment(
              label: Text('Light'),
              value: false,
            ),
            ButtonSegment(
              label: Text('System'),
              value: null,
            ),
            ButtonSegment(
              label: Text('Dark'),
              value: true,
            ),
          ],
          showSelectedIcon: false,
          emptySelectionAllowed: false,
          multiSelectionEnabled: false,
          selected: {snapshot.data},
          onSelectionChanged: (values) async {
            await settingsRepository.setNullable<bool>(
              PreferencesKeys.keyIsDarkModeOn,
              values.first,
            );
          },
        );
      },
    );
  }
}
