import '/src/core/consts.dart';
import '/src/core/di_container.dart';
import '/src/core/widgets/common.dart';
import '/src/core/model/core_model.dart';

import '../../widgets/guardian_list_tile.dart';

class GuardianTileWithPingWidget extends StatefulWidget {
  const GuardianTileWithPingWidget({super.key, required this.guardian});

  final PeerId guardian;

  @override
  State<GuardianTileWithPingWidget> createState() =>
      _GuardianTileWithPingWidgetState();
}

class _GuardianTileWithPingWidgetState
    extends State<GuardianTileWithPingWidget> {
  bool _isWaiting = false;

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onLongPress: _isWaiting
            ? null
            : () async {
                setState(() => _isWaiting = true);
                final startedAt = DateTime.now();
                final hasPong = await GetIt.I<DIContainer>()
                    .networkService
                    .pingPeer(widget.guardian);
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
