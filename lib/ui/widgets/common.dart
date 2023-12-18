import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../utils/screen_size.dart';

export 'package:flutter/material.dart';

export '../theme/theme.dart';

class ScaffoldSafe extends StatelessWidget {
  const ScaffoldSafe({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: clIndigo900,
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
  Widget build(BuildContext context) => Container(
        height: sideSize,
        color: isTransparent
            ? Colors.transparent
            : Theme.of(context).colorScheme.background,
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
                      style: stylePoppins616,
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

class HeaderBarCloseButton extends StatelessWidget {
  const HeaderBarCloseButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed ?? Navigator.of(context).pop,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: const Icon(Icons.close, color: clWhite),
          ),
        ),
      );
}

class HeaderBarMoreButton extends StatelessWidget {
  const HeaderBarMoreButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: const Icon(Icons.keyboard_control, color: clWhite),
          ),
        ),
      );
}

class HeaderBarBackButton extends StatelessWidget {
  const HeaderBarBackButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed ?? Navigator.of(context).pop,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: const Icon(Icons.arrow_back, color: clWhite),
          ),
        ),
      );
}

class PageTitle extends StatelessWidget {
  const PageTitle({
    super.key,
    this.title,
    this.titleSpans,
    this.subtitle,
    this.subtitleSpans,
  });

  final String? title;
  final String? subtitle;
  final List<TextSpan>? titleSpans;
  final List<TextSpan>? subtitleSpans;

  @override
  Widget build(BuildContext context) {
    final paddingTop =
        ScreenSize.get(MediaQuery.of(context).size) is ScreenSmall
            ? paddingT12
            : paddingT32;
    return Padding(
      padding: paddingH20,
      child: Column(
        children: [
          Padding(
            padding: paddingTop,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: title,
                children: titleSpans,
                style: stylePoppins620,
              ),
            ),
          ),
          if (subtitle != null || subtitleSpans != null)
            Padding(
              padding: paddingT20,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: subtitle,
                  children: subtitleSpans,
                  style: styleSourceSansPro416Purple.copyWith(
                    height: 1.5,
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

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onPressed,
          child: Text(text),
        ),
      );
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
  Widget build(BuildContext context) => Padding(
        padding: paddingAll20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Padding(
                padding: paddingB32,
                child: icon,
              ),
            if (titleString != null)
              Padding(
                padding: paddingB12,
                child: Text(
                  titleString!,
                  style: stylePoppins620,
                  textAlign: TextAlign.center,
                ),
              ),
            if (textString != null || textSpan != null)
              Padding(
                padding: paddingB12,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: styleSourceSansPro616Purple,
                    text: textString,
                    children: textSpan,
                  ),
                ),
              ),
            if (body != null) body!,
            if (footer != null)
              Padding(
                padding: paddingV20,
                child: footer,
              ),
          ],
        ),
      );
}

class InfoPanel extends StatelessWidget {
  const InfoPanel({
    required this.color,
    this.title,
    this.text,
    this.textSpan,
    this.icon,
    this.animationController,
    super.key,
  });

  const InfoPanel.info({
    super.key,
    this.title,
    this.text,
    this.textSpan,
    this.icon = Icons.info_outline,
    this.color = clBlue,
    this.animationController,
  });

  const InfoPanel.warning({
    super.key,
    this.title,
    this.text,
    this.textSpan,
    this.icon = Icons.error_outline,
    this.color = clYellow,
    this.animationController,
  });

  const InfoPanel.error({
    super.key,
    this.title,
    this.text,
    this.textSpan,
    this.icon = Icons.error,
    this.color = clRed,
    this.animationController,
  });

  final AnimationController? animationController;
  final String? title;
  final String? text;
  final List<TextSpan>? textSpan;
  final IconData? icon;
  final Color color;

  @override
  Widget build(BuildContext context) => animationController == null
      ? buildBody()
      : DecoratedBoxTransition(
          decoration: DecorationTween(
            begin: BoxDecoration(
              borderRadius: borderRadius8,
              color: clIndigo500,
            ),
            end: boxDecoration,
          ).animate(animationController!),
          child: buildBody(),
        );

  Widget buildBody() => Container(
        decoration: animationController == null ? boxDecoration : null,
        padding: paddingAll20,
        child: Column(
          children: [
            if (icon != null) Icon(icon, color: color, size: 20),
            if (title != null)
              Padding(
                padding: paddingT12,
                child: Text(
                  title!,
                  style: styleSourceSansPro616,
                  textAlign: TextAlign.center,
                ),
              ),
            if (text != null || textSpan != null)
              Padding(
                padding: paddingT12,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: text,
                    style: styleSourceSansPro414Purple,
                    children: textSpan,
                  ),
                ),
              ),
          ],
        ),
      );
}

class DotColored extends StatelessWidget {
  const DotColored({
    super.key,
    this.child,
    this.color = clWhite,
    this.size = 8,
  });

  final Widget? child;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        height: size,
        width: size,
        child: child,
      );
}
