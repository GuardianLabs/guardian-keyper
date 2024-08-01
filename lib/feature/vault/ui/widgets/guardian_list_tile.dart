import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/domain/entity/peer_id.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

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
          horizontal: 16,
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      );
}

class _GuardianCheckedIcon extends StatelessWidget {
  const _GuardianCheckedIcon();

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          shape: BoxShape.circle,
        ),
        height: 40,
        width: 40,
        child: const Icon(Icons.check),
      );
}

class _GuardianEmptyIcon extends StatelessWidget {
  const _GuardianEmptyIcon();

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        height: 40,
        width: 40,
        child: const Icon(Icons.add),
      );
}

class _GuardianPendingIcon extends StatelessWidget {
  const _GuardianPendingIcon();

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          shape: BoxShape.circle,
        ),
        height: 40,
        width: 40,
        child: const IconOf.waiting(),
      );
}
