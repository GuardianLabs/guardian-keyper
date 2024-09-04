import 'package:flutter/material.dart';
import 'package:guardian_keyper/ui/presenters/settings_presenter.dart';

class ThemeModeSwitcher extends StatelessWidget {
  const ThemeModeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<SettingsPresenter, bool?>(
      selector: (_, presenter) => presenter.isDarkModeOn,
      builder: (context, isDarkModeOn, child) {
        return SegmentedButton<bool?>(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).colorScheme.surface;
                }
                return null;
              },
            ),
          ),
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
          selected: {isDarkModeOn},
          onSelectionChanged: (values) async {
            final selectedValue = values.first;
            if (selectedValue == null) {
              final isSystemDarkMode =
                  MediaQuery.of(context).platformBrightness == Brightness.dark;
              await context
                  .read<SettingsPresenter>()
                  .setIsDarkModeOn(isSystemDarkMode);
            } else {
              await context
                  .read<SettingsPresenter>()
                  .setIsDarkModeOn(selectedValue);
            }
          },
        );
      },
    );
  }
}
