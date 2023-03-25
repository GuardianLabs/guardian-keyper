import 'package:flutter/material.dart';

import '/src/core/consts.dart';
import '/src/core/ui/theme/theme.dart';
import '/src/core/data/core_model.dart';

export 'package:flutter/material.dart';

export '/src/core/ui/theme/theme.dart';

class ScaffoldSafe extends StatelessWidget {
  final Widget child;

  const ScaffoldSafe({super.key, required this.child});

  @override
  Widget build(final BuildContext context) => Scaffold(
        primary: true,
        resizeToAvoidBottomInset: true,
        body: SafeArea(child: child),
      );
}

class HeaderBar extends StatelessWidget {
  static const double sideSize = 68;

  final String? caption;
  final List<TextSpan>? captionSpans;
  final Widget? backButton;
  final Widget? closeButton;
  final bool isTransparent;

  const HeaderBar({
    super.key,
    this.caption,
    this.captionSpans,
    this.backButton,
    this.closeButton,
    this.isTransparent = false,
  });

  @override
  Widget build(final BuildContext context) => Container(
        height: sideSize,
        color: isTransparent
            ? Colors.transparent
            : Theme.of(context).colorScheme.background,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: sideSize,
              width: sideSize,
              alignment: Alignment.center,
              child: backButton,
            ),
            Expanded(
                child: Container(
              height: sideSize,
              alignment: Alignment.center,
              child: RichText(
                maxLines: 1,
                softWrap: false,
                text: TextSpan(
                  text: caption,
                  children: captionSpans,
                  style: textStylePoppins616,
                ),
              ),
            )),
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
  final void Function()? onPressed;

  const HeaderBarCloseButton({super.key, this.onPressed});

  @override
  Widget build(final BuildContext context) => GestureDetector(
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
  final void Function()? onPressed;

  const HeaderBarMoreButton({super.key, this.onPressed});

  @override
  Widget build(final BuildContext context) => GestureDetector(
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
  final void Function()? onPressed;

  const HeaderBarBackButton({super.key, this.onPressed});

  @override
  Widget build(final BuildContext context) => GestureDetector(
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
  final String? title;
  final String? subtitle;
  final List<TextSpan>? titleSpans;
  final List<TextSpan>? subtitleSpans;

  const PageTitle({
    super.key,
    this.title,
    this.titleSpans,
    this.subtitle,
    this.subtitleSpans,
  });

  @override
  Widget build(final BuildContext context) {
    final paddingTop = MediaQuery.of(context).size.height > smallScreenHeight
        ? paddingTop32
        : paddingTop12;
    return Padding(
      padding: paddingH20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: paddingTop,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: title,
                children: titleSpans,
                style: textStylePoppins620,
              ),
            ),
          ),
          if (subtitle != null || subtitleSpans != null)
            Padding(
              padding: paddingTop20,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: subtitle,
                  children: subtitleSpans,
                  style: textStyleSourceSansPro416Purple.copyWith(
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
  final String text;
  final void Function()? onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(final BuildContext context) => Material(
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: onPressed == null
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF548BB4), Color(0xFF2E68AC)],
                  )
                : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF7BE7FF), Color(0xFF3AABF0)],
                  ),
          ),
          height: 48,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onPressed,
            splashColor: clBlue,
            child: Center(
              child: Text(
                text,
                overflow: TextOverflow.clip,
                maxLines: 1,
                style: textStylePoppins616.copyWith(
                  color: onPressed == null ? const Color(0xFF8FB1D0) : clWhite,
                ),
              ),
            ),
          ),
        ),
      );
}

class BottomSheetWidget extends StatelessWidget {
  final Widget? icon;
  final String? titleString;
  final String? textString;
  final List<TextSpan>? textSpan;
  final Widget? body;
  final Widget? footer;

  const BottomSheetWidget({
    super.key,
    this.icon,
    this.titleString,
    this.textString,
    this.textSpan,
    this.body,
    this.footer,
  });

  @override
  Widget build(final BuildContext context) => Padding(
        padding: paddingAll20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Padding(padding: paddingBottom32, child: icon),
            if (titleString != null)
              Padding(
                padding: paddingBottom12,
                child: Text(
                  titleString!,
                  style: textStylePoppins620,
                  textAlign: TextAlign.center,
                ),
              ),
            if (textString != null || textSpan != null)
              Padding(
                padding: paddingBottom12,
                child: RichText(
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  text: TextSpan(
                    style: textStyleSourceSansPro616Purple,
                    text: textString,
                    children: textSpan,
                  ),
                ),
              ),
            if (body != null) body!,
            if (footer != null) Padding(padding: paddingV20, child: footer),
          ],
        ),
      );
}

class InfoPanel extends StatelessWidget {
  final AnimationController? animationController;
  final String? title;
  final String? text;
  final List<TextSpan>? textSpan;
  final IconData? icon;
  final Color color;

  const InfoPanel({
    super.key,
    this.title,
    this.text,
    this.textSpan,
    this.icon,
    required this.color,
    this.animationController,
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

  @override
  Widget build(final BuildContext context) => animationController == null
      ? buildBody()
      : DecoratedBoxTransition(
          decoration: DecorationTween(
            begin: boxDecorationStart,
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
                padding: paddingTop12,
                child: Text(
                  title!,
                  style: textStyleSourceSansPro616,
                  textAlign: TextAlign.center,
                ),
              ),
            if (text != null || textSpan != null)
              Padding(
                padding: paddingTop12,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: text,
                    style: textStyleSourceSansPro414Purple,
                    children: textSpan,
                  ),
                ),
              ),
          ],
        ),
      );
}

class DotColored extends StatelessWidget {
  final Widget? child;
  final Color color;
  final double size;

  const DotColored({
    super.key,
    this.child,
    this.color = clWhite,
    this.size = 8,
  });

  @override
  Widget build(final BuildContext context) => Container(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        height: size,
        width: size,
        child: child,
      );
}

SnackBar buildSnackBar({
  String? text,
  List<TextSpan>? textSpans,
  bool isFloating = false,
  bool isError = false,
  Duration duration = const Duration(seconds: 4),
}) =>
    SnackBar(
      duration: duration,
      behavior: isFloating ? SnackBarBehavior.floating : null,
      margin: paddingAll20,
      backgroundColor: isError ? clRed : clGreen,
      content: RichText(
        text: TextSpan(
          text: text,
          children: textSpans,
          style: TextStyle(color: isError ? clWhite : clGreenDark),
        ),
      ),
    );

List<TextSpan> buildTextWithId({
  required IdWithNameBase id,
  bool isIdBold = false,
  String? leadingText,
  String? trailingText,
  TextStyle? style,
}) =>
    [
      if (leadingText != null) TextSpan(text: leadingText),
      TextSpan(
        text: '${id.name} ',
        style: isIdBold
            ? style?.copyWith(fontWeight: FontWeight.w600) ?? textStyleBold
            : style,
      ),
      TextSpan(text: id.emoji),
      if (trailingText != null) TextSpan(text: trailingText),
    ];
