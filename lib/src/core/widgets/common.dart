import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme_data.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({
    Key? key,
    this.caption,
    this.title,
    this.backButton,
    this.closeButton,
  }) : super(key: key);

  final String? caption;
  final Widget? title;
  final Widget? backButton;
  final Widget? closeButton;

  @override
  Widget build(BuildContext context) {
    return Row(
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
          child: caption == null ? title : Text(caption!),
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
}

class HeaderBarTitleLogo extends StatelessWidget {
  const HeaderBarTitleLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/icons/logo.svg', height: 32, width: 32),
        const SizedBox(height: 8),
        const Text('Guardian'),
      ],
    );
  }
}

class HeaderBarCloseButton extends StatelessWidget {
  const HeaderBarCloseButton({Key? key, this.onPressed}) : super(key: key);

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
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
}

class HeaderBarBackButton extends StatelessWidget {
  const HeaderBarBackButton({Key? key, this.onPressed}) : super(key: key);

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
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
}

class PrimaryTextButton extends StatelessWidget {
  const PrimaryTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 48,
        width: double.infinity,
        decoration: decorBlueButton,
        child: TextButton(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          onPressed: onPressed,
        ));
  }
}

class SecondaryTextButton extends StatelessWidget {
  const SecondaryTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          color: clIndigo500,
          borderRadius: borderRadius,
        ),
        child: TextButton(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          onPressed: onPressed,
        ));
  }
}

class BottomSheetWidget extends StatelessWidget {
  static const _padding = EdgeInsets.only(right: 20, left: 20, bottom: 20);
  final Widget icon;
  final String title;
  final String text;
  final Widget? body;
  final Widget? footer;

  const BottomSheetWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.text,
    this.body,
    this.footer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(20),
          child: const HeaderBarCloseButton(),
        ),
        Container(
          alignment: Alignment.center,
          padding: _padding,
          child: icon,
        ),
        Container(
          alignment: Alignment.center,
          padding: _padding,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: _padding,
          child: Text(
            text,
            style: GoogleFonts.sourceSansPro(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        if (body != null)
          Container(
            alignment: Alignment.center,
            padding: _padding,
            child: body,
          ),
        if (footer != null)
          Container(
            alignment: Alignment.center,
            padding: _padding,
            child: footer,
          ),
      ],
    );
  }
}

class CircleNumber extends StatelessWidget {
  final double size;
  final int number;

  const CircleNumber({
    Key? key,
    this.size = 24,
    required this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        shape: BoxShape.circle,
      ),
      height: size,
      width: size,
      child: Center(child: Text(number.toString())),
    );
  }
}

class NumberedListWidget extends StatelessWidget {
  final List<String> list;

  const NumberedListWidget({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < list.length; i++)
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CircleNumber(number: i),
              ),
              Expanded(
                child: Text(
                  list[i],
                  softWrap: true,
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ]),
          )
      ],
    );
  }
}

class DotColored extends StatelessWidget {
  const DotColored({
    Key? key,
    this.color = Colors.white,
    this.size = 8,
  }) : super(key: key);

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      height: size,
      width: size,
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
            child: DotColored(color: i == active ? Colors.white : clIndigo700),
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
    this.text = '',
    this.bgColor,
    this.isSelected = false,
  }) : super(key: key);

  final Widget? leading;
  final Widget? trailing;
  final String caption;
  final String text;
  final Color? bgColor;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: isSelected ? Colors.transparent : bgColor,
        border: isSelected
            ? Border.all(
                color: clBlue,
                width: 2,
              )
            : null,
      ),
      height: 192,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                leading ?? Container(),
                trailing ?? Container(),
              ],
            ),
            Text(caption),
            Text(text),
          ],
        ),
      ),
    );
  }
}

class GuardianListTileWidget extends StatelessWidget {
  const GuardianListTileWidget({
    Key? key,
    this.iconColor = clGreen,
    required this.name,
    this.nameColor = clWhite,
    required this.code,
    this.tag,
    this.status,
  }) : super(key: key);

  final Color iconColor;
  final String name;
  final Color? nameColor;
  final String code;
  final String? tag;
  final Color? status;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: iconColor,
          foregroundColor: clWhite,
          child: const Icon(Icons.health_and_safety_outlined)),
      trailing: status == null ? null : DotColored(color: status!),
      title: Row(
        children: [
          Text(name, maxLines: 1, style: TextStyle(color: nameColor)),
          if (tag != null && tag!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: clIndigo500,
                ),
                child: Text('   ${tag!}   '),
              ),
            ),
        ],
      ),
      subtitle: Text(code.replaceAll('\\', r'\\'), maxLines: 1),
      isThreeLine: true,
      dense: true,
      // visualDensity: VisualDensity.comfortable,
    );
  }
}
