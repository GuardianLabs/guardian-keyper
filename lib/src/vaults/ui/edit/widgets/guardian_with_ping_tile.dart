import 'package:get_it/get_it.dart';

import '/src/core/app/consts.dart';
import '../../../../core/domain/entity/core_model.dart';
import '/src/core/ui/widgets/emoji.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/data/network_manager.dart';

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
  Widget build(final BuildContext context) => GestureDetector(
        onLongPress: _isWaiting
            ? null
            : () async {
                final networkService = GetIt.I<NetworkManager>();
                if (widget.guardian == networkService.myPeerId) return;
                setState(() => _isWaiting = true);
                final startedAt = DateTime.now();
                final hasPong = await networkService.pingPeer(widget.guardian);
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
