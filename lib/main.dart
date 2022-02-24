import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sodium/sodium.dart' show KeyPair, SecureKey;
import 'package:p2plib/p2plib.dart' as p2p;

import 'src/di_provider.dart';
import 'src/core/service/event_bus.dart';
import 'src/core/service/kv_storage.dart';

import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'src/recovery_group/recovery_group_controller.dart';
import 'src/recovery_group/recovery_group_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final crypto = p2p.P2PCrypto();
  await crypto.init();

  final eventBus = EventBus();
  final kvStorage = KVStorage();

  final settingsController = SettingsController(
    settingsService: SettingsService(kvStorage),
    eventBus: eventBus,
  );

  final recoveryGroupService = RecoveryGroupService(kvStorage);
  final keyPairModel = await recoveryGroupService.getKeyPair();
  final keyPair = KeyPair(
      publicKey: keyPairModel.publicKey,
      secretKey: SecureKey.fromList(crypto.sodium, keyPairModel.privateKey));

  final recoveryGroupController = RecoveryGroupController(
    recoveryGroupService: recoveryGroupService,
    eventBus: eventBus,
    p2pRouter: p2p.Router(p2p.UdpConnection(), keyPair),
  );

  FlutterNativeSplash.removeAfter((BuildContext context) async {
    await settingsController.load();
    await recoveryGroupController.load();
  });

  runApp(DIProvider(
    settingsController: settingsController,
    recoveryGroupController: recoveryGroupController,
  ));
}
