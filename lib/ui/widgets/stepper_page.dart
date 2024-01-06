import 'package:guardian_keyper/ui/utils/screen_size.dart';

import 'common.dart';
import 'step_indicator.dart';

class StepperPage extends StatelessWidget {
  const StepperPage({
    required this.stepCurrent,
    required this.stepsCount,
    this.title,
    this.subtitle,
    this.children,
    this.topButton,
    this.bottomButton,
    super.key,
  });

  final int stepCurrent;
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
    return ColoredBox(
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Step Indicator
            Padding(
              padding: paddingTop,
              child: StepIndicator(
                stepCurrent: stepCurrent,
                stepsCount: stepsCount,
              ),
            ),
            // Title
            if (title != null)
              Padding(
                padding: paddingTop,
                child: Text(
                  title!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
            Expanded(
              child: children == null
                  ? Container()
                  : ListView(children: children!),
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
      ),
    );
  }
}
