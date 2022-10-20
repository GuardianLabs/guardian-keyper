import 'dart:async';
import 'package:flutter/material.dart';

import '/src/core/theme/theme.dart';
import '/src/core/model/core_model.dart';
import '/src/core/di_container.dart';

class OnlineStatusWidget extends StatefulWidget {
  final PeerId peerId;

  const OnlineStatusWidget({super.key, required this.peerId});

  @override
  State<OnlineStatusWidget> createState() => _OnlineStatusWidgetState();
}

class _OnlineStatusWidgetState extends State<OnlineStatusWidget> {
  late final StreamSubscription<bool> _peerStatusSubscription;
  bool? _peerStatus;

  @override
  void initState() {
    super.initState();
    _peerStatusSubscription =
        context.read<DIContainer>().networkService.onPeerStatusChanged(
      (isOnline) {
        if (isOnline != _peerStatus) setState(() => _peerStatus = isOnline);
      },
      widget.peerId,
    );
  }

  @override
  void dispose() {
    _peerStatusSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _peerStatus == true
      ? Text(
          'Online',
          style: textStyleSourceSansPro412.copyWith(color: clGreen),
        )
      : Text(
          'Offline',
          style: textStyleSourceSansPro412.copyWith(color: clRed),
        );
}
