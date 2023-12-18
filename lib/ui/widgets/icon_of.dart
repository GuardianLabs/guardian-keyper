import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/theme.dart';

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

  const IconOf.removeVault({
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
  Widget build(BuildContext context) {
    final actualSize = (size ?? 40) * (isBig ?? false ? 2 : 1);
    final iconWidget = Container(
      decoration: BoxDecoration(
        color: bgColor ?? Theme.of(context).colorScheme.secondary,
        shape: BoxShape.circle,
      ),
      height: actualSize,
      width: actualSize,
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

      case BageType.warning:
        bageColor = clYellow;
        bageWidget = Icon(
          Icons.priority_high_outlined,
          color: clWhite,
          size: bageSize,
        );

      case BageType.error:
        bageColor = clRed;
        bageWidget = Icon(
          Icons.close,
          color: clWhite,
          size: bageSize,
        );

      case _:
    }

    return SizedBox.square(
      dimension: actualSize,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        fit: StackFit.expand,
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
