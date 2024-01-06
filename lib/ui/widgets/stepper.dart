import 'package:guardian_keyper/ui/utils/screen_size.dart';

import 'common.dart';
import 'step_indicator.dart';

class Stepper extends StatelessWidget {
  const Stepper({
    required this.step,
    required this.stepsCount,
    this.title,
    this.subtitle,
    this.children,
    this.topButton,
    this.bottomButton,
    super.key,
  });

  final int step;
  final int stepsCount;
  final String? title;
  final String? subtitle;
  final List<Widget>? children;
  final Widget? topButton;
  final Widget? bottomButton;

  @override
  Widget build(BuildContext context) {
    final paddingTop = switch (ScreenSize(context)) {
      ScreenSmall _ => const EdgeInsets.only(top: 12),
      ScreenMedium _ => const EdgeInsets.only(top: 20),
      _ => const EdgeInsets.only(top: 24),
    };
    final theme = Theme.of(context);
    return SafeArea(
      minimum: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Step Indicator
          StepIndicator(
            step: step,
            stepsCount: stepsCount,
          ),
          // Title
          if (title != null)
            Padding(
              padding: paddingTop,
              child: Text(
                title!,
                style: theme.textTheme.headlineLarge,
              ),
            ),
          // Subtitle
          if (subtitle != null)
            Padding(
              padding: paddingT20,
              child: Text(
                subtitle!,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          // Children
          if (children != null)
            Expanded(
              child: ListView(children: children!),
            ),
          // Top Button
          if (topButton != null)
            Padding(
              padding: paddingTop,
              child: topButton,
            ),
          // Bottom Button
          if (bottomButton != null)
            Padding(
              padding: paddingTop,
              child: bottomButton,
            ),
          Padding(padding: paddingTop),
        ],
      ),
    );
  }
}
