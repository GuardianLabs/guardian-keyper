import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/utils/utils.dart';
import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/feature/network/domain/entity/peer_id.dart';

import '../vault_show_presenter.dart';
import '../../widgets/guardian_list_tile.dart';

class GuardianWithPingTile extends StatefulWidget {
  const GuardianWithPingTile({super.key, required this.guardian});

  final PeerId guardian;

  @override
  State<GuardianWithPingTile> createState() => _GuardianWithPingTileState();
}

class _GuardianWithPingTileState extends State<GuardianWithPingTile> {
  bool _isWaiting = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onLongPress: _isWaiting
            ? null
            : () async {
                setState(() => _isWaiting = true);
                final startedAt = DateTime.now();
                final hasPong = await context
                    .read<VaultShowPresenter>()
                    .pingPeer(widget.guardian);
                if (!mounted) return;
                final msElapsed =
                    DateTime.now().difference(startedAt).inMilliseconds;
                setState(() => _isWaiting = false);
                ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
                  isError: !hasPong,
                  textSpans: hasPong
                      ? [
                          ...buildTextWithId(id: widget.guardian),
                          TextSpan(text: ' is online.\nPing $msElapsed ms.'),
                        ]
                      : [
                          const TextSpan(text: 'Couldn’t reach out to '),
                          ...buildTextWithId(id: widget.guardian),
                          const TextSpan(text: '. Connection timeout.'),
                        ],
                ));
                await Future.delayed(
                  snackBarDuration,
                  () => mounted ? setState(() => _isWaiting = false) : null,
                );
              },
        child: GuardianListTile(
          guardian: widget.guardian,
          isWaiting: _isWaiting,
        ),
      );
}
