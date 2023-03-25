import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/src/core/ui/theme/theme.dart';

enum BageType { ok, warning, error }

class IconOf extends StatelessWidget {
  final String icon;
  final double? size;
  final bool? isBig;
  final Color? color;
  final Color? bgColor;
  final BageType? bage;

  const IconOf.app({
    super.key,
    this.size,
    this.isBig,
    this.color,
    this.bgColor = Colors.transparent,
    this.bage,
  }) : icon = 'assets/icons/logo.svg';

  const IconOf.navBarHome({
    super.key,
    this.size = 30,
    this.isBig,
    this.color,
    this.bgColor = Colors.transparent,
    this.bage,
  }) : icon = 'assets/icons/navbar_home_v1.svg';

  const IconOf.navBarHomeSelected({
    super.key,
    this.size = 30,
    this.isBig,
    this.color,
    this.bgColor = Colors.transparent,
    this.bage,
  }) : icon = 'assets/icons/navbar_home_selected_v1.svg';

  const IconOf.navBarKey({
    super.key,
    this.size = 30,
    this.isBig,
    this.color,
    this.bgColor = Colors.transparent,
    this.bage,
  }) : icon = 'assets/icons/navbar_key_v1.svg';

  const IconOf.navBarKeySelected({
    super.key,
    this.size = 30,
    this.isBig,
    this.color,
    this.bgColor = Colors.transparent,
    this.bage,
  }) : icon = 'assets/icons/navbar_key_selected_v1.svg';

  const IconOf.navBarShield({
    super.key,
    this.size = 30,
    this.isBig,
    this.color,
    this.bgColor = Colors.transparent,
    this.bage,
  }) : icon = 'assets/icons/navbar_shield_v1.svg';

  const IconOf.navBarShieldSelected({
    super.key,
    this.size = 30,
    this.isBig,
    this.color,
    this.bgColor = Colors.transparent,
    this.bage,
  }) : icon = 'assets/icons/navbar_shield_selected_v1.svg';

  const IconOf.navBarBell({
    super.key,
    this.size = 30,
    this.isBig,
    this.color,
    this.bgColor = Colors.transparent,
    this.bage,
  }) : icon = 'assets/icons/navbar_bell_v1.svg';

  const IconOf.navBarBellSelected({
    super.key,
    this.size = 30,
    this.isBig,
    this.color,
    this.bgColor = Colors.transparent,
    this.bage,
  }) : icon = 'assets/icons/navbar_bell_selected_v1.svg';

  const IconOf.yourDevices({
    super.key,
    this.size,
    this.isBig,
    this.color,
    this.bgColor,
    this.bage,
  }) : icon = 'assets/icons/your_devices_v1.svg';

  const IconOf.fiduciaries({
    super.key,
    this.size,
    this.isBig,
    this.color,
    this.bgColor,
    this.bage,
  }) : icon = 'assets/icons/fiduciaries_v1.svg';

  const IconOf.owner({
    super.key,
    this.size,
    this.isBig,
    this.color,
    this.bgColor,
    this.bage,
  }) : icon = 'assets/icons/owner_v1.svg';

  const IconOf.shardOwner({
    super.key,
    this.size,
    this.isBig,
    this.color,
    this.bgColor,
    this.bage,
  }) : icon = 'assets/icons/shard_owner_v1.svg';

  const IconOf.removeGroup({
    super.key,
    this.size,
    this.isBig,
    this.color,
    this.bgColor,
    this.bage,
  }) : icon = 'assets/icons/remove_group_v1.svg';

  const IconOf.secrets({
    super.key,
    this.size,
    this.isBig,
    this.color,
    this.bgColor,
    this.bage,
  }) : icon = 'assets/icons/no_secrets_v1.svg';

  const IconOf.secret({
    super.key,
    this.size,
    this.isBig,
    this.color,
    this.bgColor,
    this.bage,
  }) : icon = 'assets/icons/secret_v1.svg';

  const IconOf.secretRestoration({
    super.key,
    this.size,
    this.isBig,
    this.color,
    this.bgColor,
    this.bage,
  }) : icon = 'assets/icons/secret_restoration_v1.svg';

  const IconOf.shield({
    super.key,
    this.size,
    this.isBig,
    this.color,
    this.bgColor,
    this.bage,
  }) : icon = 'assets/icons/shield_v1.svg';

  const IconOf.scanQR({
    super.key,
    this.size,
    this.isBig,
    this.color,
    this.bgColor,
    this.bage,
  }) : icon = 'assets/icons/scan_qr_v1.svg';

  const IconOf.splitAndShare({
    super.key,
    this.size,
    this.isBig,
    this.color,
    this.bgColor,
    this.bage,
  }) : icon = 'assets/icons/split_and_share_v1.svg';

  const IconOf.share({
    super.key,
    this.size,
    this.isBig,
    this.color,
    this.bgColor,
    this.bage,
  }) : icon = 'assets/icons/share_v1.svg';

  const IconOf.passcode({
    super.key,
    this.size,
    this.isBig,
    this.color,
    this.bgColor,
    this.bage,
  }) : icon = 'assets/icons/passcode_v1.svg';

  const IconOf.biometricLogon({
    super.key,
    this.size,
    this.isBig,
    this.color,
    this.bgColor,
    this.bage,
  }) : icon = 'assets/icons/biometric_logon_v1.svg';

  @override
  Widget build(final BuildContext context) {
    final actualSize = (size ?? 40) * (isBig == true ? 2 : 1);
    final iconWidget = Container(
      decoration: BoxDecoration(
        color: bgColor ?? Theme.of(context).colorScheme.secondary,
        shape: BoxShape.circle,
      ),
      height: actualSize,
      width: actualSize,
      child: SvgPicture.asset(
        icon,
        colorFilter:
            color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
      ),
    );
    if (bage == null) return iconWidget;

    late Widget bageWidget;
    late Color bageColor;
    final bageSize = actualSize / 4;

    switch (bage) {
      case BageType.ok:
        bageColor = clGreen;
        bageWidget = Icon(
          Icons.done,
          color: clWhite,
          size: bageSize,
        );
        break;
      case BageType.warning:
        bageColor = clYellow;
        bageWidget = Icon(
          Icons.priority_high_outlined,
          color: clWhite,
          size: bageSize,
        );
        break;
      case BageType.error:
        bageColor = clRed;
        bageWidget = Icon(
          Icons.close,
          color: clWhite,
          size: bageSize,
        );
        break;
      default:
    }

    return SizedBox(
      height: actualSize,
      width: actualSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: bageColor,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: bageWidget,
            ),
          ),
        ],
      ),
    );
  }
}
