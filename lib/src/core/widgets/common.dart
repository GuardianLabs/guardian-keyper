import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme_data.dart';

class HeaderBar extends StatelessWidget {
  final String? caption;
  final Widget? title;
  final Widget? backButton;
  final Widget? closeButton;

  const HeaderBar({
    Key? key,
    this.caption,
    this.title,
    this.backButton,
    this.closeButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 100,
            width: 70,
            alignment: Alignment.centerRight,
            child: backButton,
          ),
          Container(
            height: 100,
            alignment: Alignment.center,
            child: caption == null
                ? title
                : Text(caption!, style: textStylePoppinsBold14),
          ),
          Container(
            height: 100,
            width: 70,
            alignment: Alignment.centerLeft,
            child: closeButton,
          ),
        ],
      );
}

class HeaderBarTitleLogo extends StatelessWidget {
  const HeaderBarTitleLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/logo.svg', height: 32, width: 32),
          const SizedBox(height: 8),
          const Text('Guardian'),
        ],
      );
}

class HeaderBarTitleWithSubtitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const HeaderBarTitleWithSubtitle({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style:
                textStyleSourceSansProRegular12.copyWith(color: clPurpleLight),
          ),
          Text(
            subtitle,
            style: textStylePoppinsBold14.copyWith(height: 2),
          ),
        ],
      );
}

class HeaderBarCloseButton extends StatelessWidget {
  final void Function()? onPressed;

  const HeaderBarCloseButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) => CircleAvatar(
        backgroundColor: Theme.of(context).listTileTheme.tileColor,
        child: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.close),
          onPressed: onPressed ??
              () {
                if (Navigator.of(context).canPop()) Navigator.of(context).pop();
              },
        ),
      );
}

class HeaderBarMoreButton extends StatelessWidget {
  final void Function()? onPressed;

  const HeaderBarMoreButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) => CircleAvatar(
        backgroundColor: Theme.of(context).listTileTheme.tileColor,
        child: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.keyboard_control),
          onPressed: onPressed,
        ),
      );
}

class HeaderBarBackButton extends StatelessWidget {
  final void Function()? onPressed;

  const HeaderBarBackButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) => CircleAvatar(
        backgroundColor: Theme.of(context).listTileTheme.tileColor,
        child: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: onPressed ??
              () {
                if (Navigator.of(context).canPop()) Navigator.of(context).pop();
              },
        ),
      );
}

class PrimaryButtonBig extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const PrimaryButtonBig({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Ink(
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
          child: Center(
            child: Text(text,
                style: textStylePoppinsBold16.copyWith(
                    color:
                        onPressed == null ? const Color(0xFF8FB1D0) : clWhite)),
          ),
          onTap: onPressed,
          splashColor: clBlue,
        ),
      );
}

class BottomSheetWidget extends StatelessWidget {
  static const _padding = EdgeInsets.only(right: 20, left: 20, top: 20);

  final Widget? icon;
  final String? titleString;
  final String? textString;
  final Widget? title;
  final List<TextSpan>? textSpan;
  final Widget? body;
  final Widget? footer;
  final bool haveCloseButton;

  const BottomSheetWidget({
    Key? key,
    this.icon,
    this.titleString,
    this.textString,
    this.title,
    this.textSpan,
    this.body,
    this.footer,
    this.haveCloseButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        if (icon != null) Padding(padding: _padding, child: icon),
        if (title != null || titleString != null)
          Padding(
            padding: _padding,
            child: titleString == null
                ? title
                : Text(titleString!, style: textStylePoppinsBold20),
          ),
        if (textString != null || textSpan != null)
          Padding(
            padding: _padding,
            child: textString == null
                ? RichText(
                    textAlign: TextAlign.center,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    text: TextSpan(children: textSpan),
                  )
                : Text(
                    textString!,
                    style: textStyleSourceSansProRegular16,
                    textAlign: TextAlign.center,
                  ),
          ),
        if (body != null) Padding(padding: _padding, child: body),
        if (footer != null)
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 40),
            child: footer,
          ),
        if (haveCloseButton)
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: HeaderBarCloseButton(),
          ),
        const SizedBox(height: 56),
      ],
    );
  }
}

class InfoPanel extends StatelessWidget {
  final String? text;
  final Widget? child;
  final IconData icon;
  final Color color;

  const InfoPanel({
    Key? key,
    this.text,
    this.child,
    required this.icon,
    required this.color,
  }) : super(key: key);

  const InfoPanel.info({
    Key? key,
    this.text,
    this.child,
    this.icon = Icons.info_outline,
    this.color = clBlue,
  }) : super(key: key);

  const InfoPanel.warning({
    Key? key,
    this.text,
    this.child,
    this.icon = Icons.error_outline,
    this.color = clYellow,
  }) : super(key: key);

  const InfoPanel.error({
    Key? key,
    this.text,
    this.child,
    this.icon = Icons.error,
    this.color = clRed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration,
      padding: paddingAll20,
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 14),
          if (text != null)
            Text(
              text!,
              textAlign: TextAlign.center,
              style: textStyleSourceSansProRegular14.copyWith(
                  color: clPurpleLight),
            ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class PaddingTop extends StatelessWidget {
  final Widget child;
  final bool withHorizontal;

  const PaddingTop({
    Key? key,
    required this.child,
    this.withHorizontal = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height >= heightBig) {
      return Padding(
        child: child,
        padding: withHorizontal
            ? const EdgeInsets.only(top: 40, left: 20, right: 20)
            : const EdgeInsets.only(top: 40),
      );
    }
    if (height >= heightMedium) {
      return Padding(
        child: child,
        padding: withHorizontal
            ? const EdgeInsets.only(top: 20, left: 20, right: 20)
            : paddingTop20,
      );
    }
    if (height >= heightSmall) {
      return Padding(
        child: child,
        padding: withHorizontal
            ? const EdgeInsets.only(top: 10, left: 20, right: 20)
            : paddingTop10,
      );
    }
    return withHorizontal
        ? Padding(
            padding: paddingH20,
            child: child,
          )
        : child;
  }
}

class PaddingBottom extends StatelessWidget {
  final Widget child;
  final bool withHorizontal;

  const PaddingBottom({
    Key? key,
    required this.child,
    this.withHorizontal = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height >= heightBig) {
      return Padding(
        child: child,
        padding: withHorizontal
            ? const EdgeInsets.only(bottom: 40, left: 20, right: 20)
            : const EdgeInsets.only(bottom: 40),
      );
    }
    if (height >= heightMedium) {
      return Padding(
        child: child,
        padding: withHorizontal
            ? const EdgeInsets.only(bottom: 20, left: 20, right: 20)
            : paddingTop20,
      );
    }
    if (height >= heightSmall) {
      return Padding(
        child: child,
        padding: withHorizontal
            ? const EdgeInsets.only(bottom: 10, left: 20, right: 20)
            : paddingTop10,
      );
    }
    return withHorizontal
        ? Padding(
            padding: paddingH20,
            child: child,
          )
        : child;
  }
}
