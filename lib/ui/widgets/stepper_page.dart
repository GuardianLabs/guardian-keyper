import 'common.dart';
import 'step_indicator.dart';
import '../utils/screen_size.dart';

export '../presenters/page_presenter_base.dart';

class StepperPage extends StatelessWidget {
  const StepperPage({
    required this.stepCurrent,
    required this.stepsCount,
    this.title,
    this.subtitle,
    this.child,
    this.children,
    this.topButton,
    this.bottomButton,
    super.key,
  });

  final int stepCurrent;
  final int stepsCount;
  final String? title;
  final String? subtitle;
  final Widget? child;
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
    return Column(
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
            padding: paddingTDefault,
            child: Text(
              subtitle!,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        // Child or Children
        Expanded(
          child: child ??
              (children == null ? Container() : ListView(children: children!)),
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
      ],
    );
  }
}
