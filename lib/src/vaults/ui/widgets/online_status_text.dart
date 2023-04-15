import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import '/src/core/ui/theme/theme.dart';
import '/src/core/data/core_model.dart';
import '/src/core/data/network_manager.dart';

class OnlineStatusText extends StatefulWidget {
  final PeerId peerId;

  const OnlineStatusText({super.key, required this.peerId});

  @override
  State<OnlineStatusText> createState() => _OnlineStatusTextState();
}

class _OnlineStatusTextState extends State<OnlineStatusText> {
  final _networkService = GetIt.I<NetworkManager>();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      _networkService.messageTTL,
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
