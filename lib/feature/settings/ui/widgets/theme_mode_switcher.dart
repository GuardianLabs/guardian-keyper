import 'package:flutter/material.dart';
import 'package:guardian_keyper/ui/presenters/settings_presenter.dart';

class ThemeModeSwitcher extends StatelessWidget {
  const ThemeModeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<SettingsPresenter, ThemeMode>(
      selector: (_, presenter) => presenter.themeMode,
      builder: (context, themeMode, child) {
        return SegmentedButton<ThemeMode>(
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
          selected: {themeMode},
          onSelectionChanged: (values) async {
            await context
                .read<SettingsPresenter>()
                .setIsThemeMode(values.first);
          },
        );
      },
    );
  }
}
