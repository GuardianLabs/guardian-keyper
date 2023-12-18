import 'package:flutter/material.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/theme/theme.dart';
import 'package:guardian_keyper/ui/utils/screen_size.dart';

export 'package:flutter/material.dart';

export 'package:guardian_keyper/ui/theme/theme.dart';

class ScaffoldSafe extends StatelessWidget {
  const ScaffoldSafe({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(child: child),
      );
}

class HeaderBar extends StatelessWidget {
  static const double sideSize = 68;

  const HeaderBar({
    super.key,
    this.caption,
    this.captionSpans,
    this.captionWidget,
    this.backButton,
    this.closeButton,
    this.isTransparent = false,
  });

  final String? caption;
  final List<TextSpan>? captionSpans;
  final Widget? backButton;
  final Widget? captionWidget;
  final Widget? closeButton;
  final bool isTransparent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: sideSize,
      color: isTransparent ? Colors.transparent : theme.colorScheme.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Button
          Container(
            height: sideSize,
            width: sideSize,
            alignment: Alignment.center,
            child: backButton,
          ),
          // Caption
          Expanded(
              child: Container(
            height: sideSize,
            alignment: Alignment.center,
            child: captionWidget ??
                RichText(
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: caption,
                    children: captionSpans,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
          )),
          // Right Button
          Container(
            height: sideSize,
            width: sideSize,
            alignment: Alignment.center,
            child: closeButton,
          ),
        ],
      ),
    );
  }
}

class HeaderBarCloseButton extends StatelessWidget {
  const HeaderBarCloseButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onPressed ?? Navigator.of(context).pop,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: CircleAvatar(
          backgroundColor: colorScheme.secondary,
          child: Icon(
            Icons.close,
            color: colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}

class HeaderBarMoreButton extends StatelessWidget {
  const HeaderBarMoreButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: CircleAvatar(
          backgroundColor: colorScheme.secondary,
          child: Icon(
            Icons.keyboard_control,
            color: colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}

class HeaderBarBackButton extends StatelessWidget {
  const HeaderBarBackButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onPressed ?? Navigator.of(context).pop,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: CircleAvatar(
          backgroundColor: colorScheme.secondary,
          child: Icon(
            Icons.arrow_back,
            color: colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}

class PageTitle extends StatelessWidget {
  const PageTitle({
    super.key,
    this.title,
    this.subtitle,
    this.subtitleSpans,
  });

  final String? title;
  final String? subtitle;
  final List<TextSpan>? subtitleSpans;

  @override
  Widget build(BuildContext context) {
    final paddingTop = switch (ScreenSize.get(MediaQuery.of(context).size)) {
      ScreenSmall _ => paddingT12,
      ScreenMedium _ => paddingT20,
      _ => paddingT32,
    };
    final theme = Theme.of(context);
    return Padding(
      padding: paddingH20,
      child: Column(
        children: [
          // Title
          if (title != null)
            Padding(
              padding: paddingTop,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: title,
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
          // Subtitle
          if (subtitle != null || subtitleSpans != null)
            Padding(
              padding: paddingT20,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: subtitle,
                  children: subtitleSpans,
                  style: const TextStyle(
                    height: 1.5,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          Padding(padding: paddingTop),
        ],
      ),
    );
  }
}

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({
    super.key,
    this.icon,
    this.titleString,
    this.textString,
    this.textSpan,
    this.body,
    this.footer,
  });

  final Widget? icon;
  final String? titleString;
  final String? textString;
  final List<TextSpan>? textSpan;
  final Widget? body;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: paddingAll20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon
          if (icon != null)
            Padding(
              padding: paddingB32,
              child: icon,
            ),
          // Title
          if (titleString != null)
            Padding(
              padding: paddingB12,
              child: Text(
                titleString!,
                style: textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
          // Text
          if (textString != null || textSpan != null)
            Padding(
              padding: paddingB12,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: textTheme.bodyMedium,
                  text: textString,
                  children: textSpan,
                ),
              ),
            ),
          // Body
          if (body != null)
            Padding(
              padding: paddingT20,
              child: body,
            ),
          // Footer
          if (footer != null)
            Padding(
              padding: paddingT20,
              child: footer,
            ),
          const Padding(padding: paddingB20),
        ],
      ),
    );
  }
}

// TBD: remove
class DotColored extends StatelessWidget {
  const DotColored({
    required this.color,
    this.size = 8,
    this.child,
    super.key,
  });

  final Widget? child;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        height: size,
        width: size,
        child: child,
      );
}

SnackBar buildSnackBar(
  BuildContext context, {
  String? text,
  List<TextSpan>? textSpans,
  Duration duration = snackBarDuration,
  bool isFloating = false,
  bool isError = false,
}) {
  final theme = Theme.of(context);
  return SnackBar(
    duration: duration,
    behavior: isFloating ? SnackBarBehavior.floating : null,
    margin: paddingAll20,
    backgroundColor:
        isError ? theme.colorScheme.error : theme.snackBarTheme.backgroundColor,
    content: RichText(
      text: TextSpan(
        text: text,
        children: textSpans,
        style: isError
            ? theme.snackBarTheme.contentTextStyle!.copyWith(
                color: theme.colorScheme.onError,
              )
            : theme.snackBarTheme.contentTextStyle,
      ),
    ),
  );
}
