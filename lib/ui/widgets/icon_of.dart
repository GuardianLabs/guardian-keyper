import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconOf extends StatelessWidget {
  final String icon;
  final double size;
  final Color? color;
  final Color? bgColor;

  const IconOf.app({
    super.key,
    this.size = 40,
    this.color,
    this.bgColor = Colors.transparent,
  }) : icon = 'assets/icons/logo.svg';

  const IconOf.user({
    super.key,
    this.size = 40,
    this.color,
    this.bgColor,
  }) : icon = 'assets/icons/user.svg';

  const IconOf.twice({
    super.key,
    this.size = 40,
    this.color,
    this.bgColor,
  }) : icon = 'assets/icons/twice.svg';

  const IconOf.moveVault({
    super.key,
    this.size = 40,
    this.color,
    this.bgColor,
  }) : icon = 'assets/icons/move_vault.svg';

  const IconOf.confirmIdentity({
    super.key,
    this.size = 40,
    this.color,
    this.bgColor,
  }) : icon = 'assets/icons/confirm_identity.svg';

  const IconOf.connection({
    super.key,
    this.size = 40,
    this.color,
    this.bgColor,
  }) : icon = 'assets/icons/connection.svg';

  const IconOf.passcode({
    super.key,
    this.size = 40,
    this.color,
    this.bgColor,
  }) : icon = 'assets/icons/passcode.svg';

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: bgColor ?? Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
        ),
        height: size,
        width: size,
        child: SvgPicture.asset(
          icon,
          colorFilter: color == null
              ? null
              : ColorFilter.mode(
                  color!,
                  BlendMode.srcIn,
                ),
        ),
      );
}
