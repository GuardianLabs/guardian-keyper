import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconOf extends StatelessWidget {
  static const defaultIconSize = 40.0;

  final String icon;
  final double size;
  final Color? color;
  final Color? bgColor;

  const IconOf({
    required this.icon,
    this.size = defaultIconSize,
    this.color,
    this.bgColor = Colors.transparent,
    super.key,
  });

  const IconOf.logo({
    super.key,
    this.size = defaultIconSize,
    this.color,
    this.bgColor = Colors.transparent,
  }) : icon = 'assets/icons/logo.svg';

  const IconOf.user({
    super.key,
    this.size = defaultIconSize,
    this.color,
    this.bgColor,
  }) : icon = 'assets/icons/user.svg';

  const IconOf.twice({
    super.key,
    this.size = defaultIconSize,
    this.color,
    this.bgColor,
  }) : icon = 'assets/icons/twice.svg';

  const IconOf.moveVault({
    super.key,
    this.size = defaultIconSize,
    this.color,
    this.bgColor,
  }) : icon = 'assets/icons/move_vault.svg';

  const IconOf.confirmIdentity({
    super.key,
    this.size = defaultIconSize,
    this.color,
    this.bgColor,
  }) : icon = 'assets/icons/confirm_identity.svg';

  const IconOf.connection({
    super.key,
    this.size = defaultIconSize,
    this.color,
    this.bgColor,
  }) : icon = 'assets/icons/connection.svg';

  const IconOf.passcode({
    super.key,
    this.size = defaultIconSize,
    this.color,
    this.bgColor,
  }) : icon = 'assets/icons/passcode.svg';

  const IconOf.waiting({
    super.key,
    this.size = defaultIconSize,
    this.color,
    this.bgColor,
  }) : icon = 'assets/icons/waiting.svg';

  const IconOf.shard({
    super.key,
    this.size = defaultIconSize,
    this.color,
    this.bgColor,
  }) : icon = 'assets/icons/shard.svg';

  @override
  Widget build(BuildContext context) {
    final iconAsset = SvgPicture.asset(
      icon,
      colorFilter:
          color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
      height: size,
      width: size,
    );
    return bgColor == null
        ? iconAsset
        : Container(
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            height: size,
            width: size,
            child: iconAsset,
          );
  }
}
