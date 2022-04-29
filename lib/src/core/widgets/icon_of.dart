import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/src/core/theme_data.dart';

enum BageType { ok, warning, error }

class IconOf extends StatelessWidget {
  final String icon;
  final double? radius;
  final double? size;
  final Color? color;
  final Color? bgColor;
  final BageType? bage;

  const IconOf({
    Key? key,
    required this.icon,
    this.size,
    this.radius,
    this.color,
    this.bgColor,
    this.bage,
  }) : super(key: key);

  const IconOf.app(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/logo.svg',
        super(key: key);

  const IconOf.yourDevices(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/your_devices_v1.svg',
        super(key: key);

  const IconOf.fiduciaries(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/fiduciaries_v1.svg',
        super(key: key);

  const IconOf.owner(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/owner_v1.svg',
        super(key: key);

  const IconOf.shardOwner(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/shard_owner_v1.svg',
        super(key: key);

  const IconOf.groups(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/no_groups_v1.svg',
        super(key: key);

  const IconOf.restoreGroup(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/restore_group_v1.svg',
        super(key: key);

  const IconOf.removeGroup(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/remove_group_v1.svg',
        super(key: key);

  const IconOf.trash(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/trash_v1.svg',
        super(key: key);

  const IconOf.secrets(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/no_secrets_v1.svg',
        super(key: key);

  const IconOf.secret(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/secret_v1.svg',
        super(key: key);

  const IconOf.secretRecovered(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/secret_recovered_v1.svg',
        super(key: key);

  const IconOf.shield(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/shield_v1.svg',
        super(key: key);

  const IconOf.scanQR(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/scan_qr_v1.svg',
        super(key: key);

  const IconOf.splitAndShare(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/split_and_share_v1.svg',
        super(key: key);

  const IconOf.bottomHome(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/bottom_home_v1.svg',
        super(key: key);

  const IconOf.bottomShield(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/bottom_shield_v1.svg',
        super(key: key);

  const IconOf.bottomBell(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/bottom_bell_v1.svg',
        super(key: key);

  const IconOf.bottomSettings(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/bottom_settings_v1.svg',
        super(key: key);

  const IconOf.nameChanged(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/name_changed_v1.svg',
        super(key: key);

  const IconOf.notitications(
      {Key? key, this.radius, this.color, this.bgColor, this.size, this.bage})
      : icon = 'assets/icons/notitications_v1.svg',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final dSize = size ?? IconTheme.of(context).size ?? 40;
    final iconWidget = CircleAvatar(
      radius: radius ?? dSize / 2,
      backgroundColor: bgColor ?? IconTheme.of(context).color,
      child: icon.endsWith('.svg')
          ? SvgPicture.asset(icon, height: dSize, width: dSize, color: color)
          : Image(image: AssetImage(icon), height: dSize, width: dSize),
    );
    late Widget bageWidget;
    late Color bageColor;
    switch (bage) {
      case null:
        return iconWidget;
      case BageType.ok:
        bageColor = clGreen;
        bageWidget = Icon(Icons.done, color: clWhite, size: dSize / 2);
        break;
      case BageType.warning:
        bageColor = clYellow;
        bageWidget =
            Icon(Icons.priority_high_outlined, color: clWhite, size: dSize / 2);
        break;
      case BageType.error:
        bageColor = clRed;
        bageWidget = Icon(Icons.close, color: clWhite, size: dSize / 2);
        break;
    }
    return Container(
      alignment: Alignment.center,
      height: dSize * 2,
      width: dSize * 2,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            left: dSize * 1.5,
            child: CircleAvatar(
              radius: dSize / 3,
              child: bageWidget,
              backgroundColor: bageColor,
            ),
          ),
        ],
      ),
    );
  }
}
