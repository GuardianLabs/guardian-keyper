import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:guardian_keyper/src/core/ui/theme/theme.dart';
import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

import '../../domain/vault_interactor.dart';

class OnlineStatusText extends StatefulWidget {
  final PeerId peerId;

  const OnlineStatusText({super.key, required this.peerId});

  @override
  State<OnlineStatusText> createState() => _OnlineStatusTextState();
}

class _OnlineStatusTextState extends State<OnlineStatusText> {
  final _vaultInteractor = GetIt.I<VaultInteractor>();
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      _vaultInteractor.requestRetryPeriod,
      (_) => _vaultInteractor.pingPeer(widget.peerId),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => StreamBuilder<bool>(
        initialData: _vaultInteractor.getPeerStatus(widget.peerId),
        stream: _vaultInteractor.peerStatusChangeStream
            .where((e) => e.key == widget.peerId)
            .map((e) => e.value),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<bool> snapshot,
        ) =>
            snapshot.data == true
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
