import '/src/core/di_container.dart';
import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/model/core_model.dart';

import '../../widgets/guardian_tile_widget.dart';

class GuardianTileWithPingWidget extends StatefulWidget {
  const GuardianTileWithPingWidget({super.key, required this.guardian});

  final PeerId guardian;

  @override
  State<GuardianTileWithPingWidget> createState() =>
      _GuardianTileWithPingWidgetState();
}

class _GuardianTileWithPingWidgetState
    extends State<GuardianTileWithPingWidget> {
  bool? _isWaiting;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onLongPress: () async {
          if (_isWaiting != null) return; // Not yet ready for new ping
          final diContainer = context.read<DIContainer>();
          setState(() => _isWaiting = true);
          final startedAt = DateTime.now();
          final hasPong = await diContainer.networkService
              .pingPeer(peerId: widget.guardian);
          if (!mounted) return;
          final msElapsed = DateTime.now().difference(startedAt).inMilliseconds;
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
            duration: diContainer.globals.snackBarDuration,
          ));
          Future.delayed(
            diContainer.globals.snackBarDuration,
            () => mounted ? setState(() => _isWaiting = null) : null,
          );
        },
        child: GuardianTileWidget(
          guardian: widget.guardian,
          isWaiting: _isWaiting ?? false,
        ),
      );
}
