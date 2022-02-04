import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../globals.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({
    Key? key,
    this.title,
    this.backButton,
    this.closeButton,
  }) : super(key: key);

  final Widget? title;
  final Widget? backButton;
  final Widget? closeButton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (title != null)
          Align(
            alignment: Alignment.center,
            child: title,
          ),
        // Close button (right)
        if (closeButton != null)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, right: 20),
              child: closeButton,
            ),
          ),
        //Back button (left)
        if (backButton != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 20),
              child: backButton,
            ),
          ),
      ],
    );
  }
}

class HeaderBarTitleLogo extends StatelessWidget {
  const HeaderBarTitleLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 48),
          child: Image(
            height: 33,
            width: 33,
            image: AssetImage('assets/images/logo.png'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Guardian Network',
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class HeaderBarCloseButton extends StatelessWidget {
  const HeaderBarCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).listTileTheme.tileColor,
      child: IconButton(
        color: Colors.white,
        icon: const Icon(Icons.close),
        // onPressed: Navigator.of(context).pop,
        onPressed: () {
          if (Navigator.of(context).canPop()) Navigator.of(context).pop();
        },
      ),
    );
  }
}

class HeaderBarBackButton extends StatelessWidget {
  const HeaderBarBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).listTileTheme.tileColor,
      child: IconButton(
        color: Colors.white,
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (Navigator.of(context).canPop()) Navigator.of(context).pop();
        },
      ),
    );
  }
}

class FooterButton extends StatelessWidget {
  const FooterButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF7BE7FF),
                Color(0xFF3AABF0),
              ],
            )),
        child: TextButton(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          onPressed: onPressed,
        ));
  }
}

class ListTileButton extends StatelessWidget {
  const ListTileButton({
    Key? key,
    this.text,
    this.leading,
    this.trailing,
    this.bgColor,
    required this.onPressed,
  }) : super(key: key);

  final String? text;
  final String? leading;
  final String? trailing;
  final Color? bgColor;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: text == null
          ? null
          : Text(
              text!,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
      leading: leading == null
          ? null
          : CircleIcon(
              bgColor: bgColor,
              icon: leading!,
            ),
      trailing: trailing == null
          ? null
          : CircleIcon(
              bgColor: bgColor,
              icon: trailing!,
            ),
      onTap: onPressed,
    );
  }
}

class CircleIcon extends StatelessWidget {
  const CircleIcon({
    Key? key,
    required this.icon,
    required this.bgColor,
  }) : super(key: key);

  final String icon;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        shape: BoxShape.circle,
      ),
      height: 40,
      width: 40,
      child: Center(
          child: Image(
        image: AssetImage(icon),
        height: 20,
        width: 20,
      )),
    );
  }
}

class DotBar extends StatelessWidget {
  const DotBar({
    Key? key,
    this.active = 0,
    required this.count,
  }) : super(key: key);

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              decoration: BoxDecoration(
                color: i == active ? Colors.white : clIndigo500,
                shape: BoxShape.circle,
              ),
              height: 8,
              width: 8,
            ),
          ),
      ],
    );
  }
}

class SimpleCard extends StatelessWidget {
  const SimpleCard({
    Key? key,
    this.leading,
    this.trailing,
    required this.caption,
    required this.text,
  }) : super(key: key);

  final Widget? leading;
  final Widget? trailing;
  final String caption;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 335,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                leading == null ? Container() : leading!,
                trailing == null ? Container() : trailing!,
                Text(caption),
                Text(text),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
