import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/network/domain/entity/peer_id.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';
import 'package:guardian_keyper/feature/vault/ui/widgets/guardian_list_tile.dart';

class GuardianWithPingTile extends StatefulWidget {
  const GuardianWithPingTile({
    required this.guardian,
    super.key,
  });

  final PeerId guardian;

  @override
  State<GuardianWithPingTile> createState() => _GuardianWithPingTileState();
}

class _GuardianWithPingTileState extends State<GuardianWithPingTile> {
  bool _isWaiting = false;

  @override
  Widget build(BuildContext context) => GuardianListTile(
        guardian: widget.guardian,
        isWaiting: _isWaiting,
        onLongPress: () async {
          if (_isWaiting) return;
          setState(() => _isWaiting = true);
          final startedAt = DateTime.now();
          final hasPong =
              await GetIt.I<VaultInteractor>().pingPeer(widget.guardian);
          if (!mounted) return;
          if (hasPong) {
            final msElapsed =
                DateTime.now().difference(startedAt).inMilliseconds;
            ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
              context,
              text: '${widget.guardian.name} is online. Ping $msElapsed ms.',
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
              context,
              text: 'Couldn’t reach out to ${widget.guardian.name}.',
              isError: true,
            ));
          }
          setState(() => _isWaiting = false);
        },
      );
}
