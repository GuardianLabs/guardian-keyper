import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconOf extends StatelessWidget {
  final String icon;
  final double? radius;
  final Color? bgColor;

  const IconOf({
    Key? key,
    required this.icon,
    this.radius,
    this.bgColor,
  }) : super(key: key);

  const IconOf.app({Key? key, this.radius, this.bgColor})
      : icon = 'assets/icons/logo.svg',
        super(key: key);

  const IconOf.connect({Key? key, this.radius, this.bgColor})
      : icon = 'assets/images/icon_connect.png',
        super(key: key);

  const IconOf.group({Key? key, this.radius, this.bgColor})
      : icon = 'assets/icons/group.svg',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 20,
      backgroundColor: IconTheme.of(context).color,
      child: icon.endsWith('.svg')
          ? SvgPicture.asset(icon)
          : Image(image: AssetImage(icon), height: 20, width: 20),
    );
  }
}
