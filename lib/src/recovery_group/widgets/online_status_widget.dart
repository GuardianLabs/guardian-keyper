import 'dart:async';
import 'package:flutter/material.dart';

import '/src/core/theme/theme.dart';
import '/src/core/model/core_model.dart';
import '/src/core/service/service_root.dart';

class OnlineStatusWidget extends StatefulWidget {
  final PeerId peerId;

  const OnlineStatusWidget({super.key, required this.peerId});

  @override
  State<OnlineStatusWidget> createState() => _OnlineStatusWidgetState();
}

class _OnlineStatusWidgetState extends State<OnlineStatusWidget> {
  final _networkService = GetIt.I<ServiceRoot>().networkService;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      _networkService.router.messageTTL,
      (_) => _networkService.pingPeer(widget.peerId),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => StreamBuilder<bool>(
        initialData: _networkService.getPeerStatus(widget.peerId),
        stream: _networkService.peerStatusChangeStream
            .where((e) => e.key == widget.peerId)
            .map((e) => e.value),
        builder: (_, s) => s.data == true
            ? Text(
                'Online',
                style: textStyleSourceSansPro412.copyWith(color: clGreen),
              )
            : Text(
                'Offline',
                style: textStyleSourceSansPro412.copyWith(color: clRed),
              ),
      );
}
