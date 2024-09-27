import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/domain/entity/peer_id.dart';
import 'package:guardian_keyper/ui/widgets/styled_icon.dart';

class GuardianListTile extends StatelessWidget {
  GuardianListTile({
    required PeerId guardian,
    this.leading = const _GuardianCheckedIcon(),
    this.isWaiting = false,
    this.onTap,
    this.onLongPress,
    super.key,
  })  : title = guardian.name,
        subtitle = 'ID: ${guardian.toHexShort()}';

  const GuardianListTile.my({
    super.key,
  })  : onTap = null,
        onLongPress = null,
        isWaiting = false,
        title = 'My device',
        subtitle = 'Acts as a Guardian',
        leading = const _GuardianCheckedIcon();

  const GuardianListTile.empty({
    this.onTap,
    super.key,
  })  : isWaiting = false,
        onLongPress = null,
        title = 'Guardian Slot',
        subtitle = 'Tap to Add',
        leading = const _GuardianEmptyIcon();

  GuardianListTile.pending({
    required PeerId guardian,
    super.key,
  })  : onTap = null,
        onLongPress = null,
        isWaiting = false,
        title = guardian.name,
        subtitle = 'ID: ${guardian.toHexShort()}',
        leading = const _GuardianPendingIcon();

  GuardianListTile.rejected({
    required PeerId guardian,
    super.key,
  })  : onTap = null,
        onLongPress = null,
        isWaiting = false,
        title = guardian.name,
        subtitle = 'ID: ${guardian.toHexShort()}',
        leading = const _GuardianRejectedIcon();

  final bool isWaiting;
  final Widget? leading;
  final String title;
  final String subtitle;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: leading,
        title: Text(title, maxLines: 1),
        subtitle: Text(subtitle, maxLines: 1),
        trailing: isWaiting ? const CircularProgressIndicator.adaptive() : null,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: kDefaultTilePadding,
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      );
}

class _GuardianCheckedIcon extends StatelessWidget {
  const _GuardianCheckedIcon();

  @override
  Widget build(BuildContext context) => StyledIcon(
        icon: Icons.check,
        scale: 0.6,
        outlined: true,
        color: Theme.of(context).colorScheme.primary,
        bgColor: Theme.of(context).colorScheme.primary,
      );
}

class _GuardianEmptyIcon extends StatelessWidget {
  const _GuardianEmptyIcon();

  @override
  Widget build(BuildContext context) => StyledIcon(
        icon: Icons.add,
        scale: 0.6,
        outlined: true,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        bgColor: Theme.of(context).colorScheme.primary,
      );
}

class _GuardianPendingIcon extends StatelessWidget {
  const _GuardianPendingIcon();

  @override
  Widget build(BuildContext context) => StyledIcon(
        icon: Icons.hourglass_empty,
        bgColor: Theme.of(context).colorScheme.primary,
        color: Theme.of(context).colorScheme.primary,
        outlined: true,
        scale: 0.6,
      );
}

class _GuardianRejectedIcon extends StatelessWidget {
  const _GuardianRejectedIcon();

  @override
  Widget build(BuildContext context) => StyledIcon(
        icon: Icons.close,
        scale: 0.6,
        outlined: true,
        color: Theme.of(context).colorScheme.error,
        bgColor: Theme.of(context).colorScheme.primary,
      );
}
