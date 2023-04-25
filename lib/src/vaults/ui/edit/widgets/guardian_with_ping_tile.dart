import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/ui/widgets/emoji.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';
import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

import '../../../domain/vault_interactor.dart';
import '../../widgets/guardian_list_tile.dart';

class GuardianWithPingTile extends StatefulWidget {
  const GuardianWithPingTile({super.key, required this.guardian});

  final PeerId guardian;

  @override
  State<GuardianWithPingTile> createState() => _GuardianWithPingTileState();
}

class _GuardianWithPingTileState extends State<GuardianWithPingTile> {
  final _vaultInteractor = GetIt.I<VaultInteractor>();

  bool _isWaiting = false;

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onLongPress: _isWaiting
            ? null
            : () async {
                if (widget.guardian == _vaultInteractor.selfId) return;
                setState(() => _isWaiting = true);
                final startedAt = DateTime.now();
                final hasPong =
                    await _vaultInteractor.pingPeer(widget.guardian);
                if (!mounted) return;
                final msElapsed =
                    DateTime.now().difference(startedAt).inMilliseconds;
                setState(() => _isWaiting = false);
                ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
                  isError: !hasPong,
                  textSpans: hasPong
                      ? [
                          ...buildTextWithId(
                            id: widget.guardian,
                            style: textStyleBold,
                          ),
                          TextSpan(text: ' is online.\nPing $msElapsed ms.'),
                        ]
                      : [
                          const TextSpan(text: 'Couldn’t reach out to '),
                          ...buildTextWithId(
                            id: widget.guardian,
                            style: textStyleBold,
                          ),
                          const TextSpan(text: '. Connection timeout.'),
                        ],
                  duration: snackBarDuration,
                ));
                Future.delayed(
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
