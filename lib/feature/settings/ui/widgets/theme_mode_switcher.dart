import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/utils/theme_mode_mapper.dart';

import 'package:guardian_keyper/feature/settings/domain/use_case/settings_theme_case.dart';

class ThemeModeSwitcher extends StatelessWidget with ThemeModeMapper {
  const ThemeModeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModeHandler = SettingsThemeCase();
    return StreamBuilder<bool?>(
      initialData: themeModeHandler.isDarkMode,
      stream: themeModeHandler.events,
      builder: (context, snapshot) => SegmentedButton<ThemeMode>(
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
        selected: {mapBoolToThemeMode(snapshot.data)},
        onSelectionChanged: (themeModeSet) => themeModeHandler
            .setIsDarkMode(mapThemeModeToBool(themeModeSet.first)),
      ),
    );
  }
}
