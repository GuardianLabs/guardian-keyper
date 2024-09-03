import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:p2plib/p2plib.dart' as p2p;
import 'package:p2plib_flutter/router.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/domain/entity/peer_id.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';
import 'package:guardian_keyper/data/services/platform_service.dart';

import 'package:guardian_keyper/data/repositories/settings_repository.dart';

export 'package:get_it/get_it.dart';

class NetworkManager {
  NetworkManager({
    Router? router,
  }) : _router = router ??
            Router.mdns(
              port: bsPort,
              serviceName: 'Guardian Keyper',
              serviceType: '_guardianKeyper._udp',
            );

  final Router _router;

  final _platformService = GetIt.I<PlatformService>();

  final _settingsRepository = GetIt.I<SettingsRepository>();

  late final _settingsChanges =
      _settingsRepository.watch().listen(_updateSettings);

  late final _messageStream = _router.messageStream.asBroadcastStream();

  late PeerId _selfId;

  PeerId get selfId => _selfId;

  Stream<MessageModel> get messageStream => _messageStream
      .map((e) => MessageModel.fromBytes(e.payload!))
      .asBroadcastStream();

  Future<NetworkManager> init() async {
    final seed = _settingsRepository.get<Uint8List>(PreferencesKeys.keySeed);
    if (seed == null) {
      await _settingsRepository.set<Uint8List>(
        PreferencesKeys.keySeed,
        await _router.init(),
      );
    } else {
      await _router.init(seed);
    }
    _selfId = PeerId(
      token: _router.selfId.value,
      name: _settingsRepository.get<String>(
        PreferencesKeys.keyDeviceName,
        await _platformService.getDeviceName(),
      )!,
    );
    await _toggleBootstrap(
      _settingsRepository.get<bool>(PreferencesKeys.keyIsBootstrapEnabled),
    );
    await start();
    _settingsChanges.resume();
    return this;
  }

  Future<void> dispose() async {
    await _settingsChanges.cancel();
  }

  Future<void> start() async {
    await _router.start();
  }

  Future<void> stop() async {
    await _router.stop();
  }

  Future<bool> pingPeer(PeerId peerId) =>
      _router.pingPeer(p2p.PeerId(value: peerId.token));

  bool getPeerStatus(PeerId peerId) =>
      _router.getPeerStatus(p2p.PeerId(value: peerId.token));

  Future<void> sendToPeer(
    PeerId peerId, {
    required MessageModel message,
    bool isConfirmable = false,
  }) async {
    try {
      await _router.sendMessage(
        dstPeerId: p2p.PeerId(value: peerId.token),
        isConfirmable: isConfirmable,
        payload: message.toBytes(),
      );
    } catch (e) {
      if (kDebugMode) print(e);
      if (isConfirmable) rethrow;
    }
  }

  Future<void> _updateSettings(SettingsRepositoryEvent event) async {
    switch (event.key) {
      case PreferencesKeys.keyDeviceName:
        final deviceName = event.value as String?;
        _selfId = _selfId.copyWith(
          name: deviceName == null || deviceName.isEmpty
              ? await _platformService.getDeviceName()
              : deviceName,
        );

      case PreferencesKeys.keyIsBootstrapEnabled:
        await _toggleBootstrap(event.value as bool?);

      // ignore: no_default_cases
      default:
    }
  }

  Future<void> _toggleBootstrap(bool? isBootstrapEnabled) async {
    if (isBootstrapEnabled ?? true) {
      try {
        await _router.addBootstrap(
          bsName: bsName,
          bsPeerId: bsPeerId,
          port: bsPort,
        );
      } catch (e) {
        if (kDebugMode) print(e);
      }
    } else {
      _router.removeAllBootstraps();
    }
  }
}
