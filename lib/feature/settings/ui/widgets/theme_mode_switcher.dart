import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/presenters/theme_presenter.dart';

class ThemeModeSwitcher extends StatelessWidget {
  const ThemeModeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final themePresenter = context.watch<ThemePresenter>();
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
      selected: {themePresenter.themeMode},
      onSelectionChanged: (values) => themePresenter.setThemeMode(values.first),
    );
  }
}
