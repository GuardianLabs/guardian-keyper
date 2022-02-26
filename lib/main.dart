import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sodium/sodium.dart' show KeyPair, SecureKey;
import 'package:p2plib/p2plib.dart' as p2p;

import 'src/di_provider.dart';
import 'src/core/service/event_bus.dart';
import 'src/core/service/kv_storage.dart';

import 'src/settings/settings_service.dart';
import 'src/settings/settings_controller.dart';
import 'src/recovery_group/recovery_group_service.dart';
import 'src/recovery_group/recovery_group_controller.dart';
import 'src/guardian/guardian_service.dart';
import 'src/guardian/guardian_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final crypto = p2p.P2PCrypto();
  await crypto.init();

  final eventBus = EventBus();
  final kvStorage = KVStorage();
  final settingsService = SettingsService(kvStorage);

  final keyPair = await settingsService.getKeyPair();
  final p2pRouter = p2p.Router(
      p2p.UdpConnection(),
      KeyPair(
          publicKey: keyPair.publicKey,
          secretKey: SecureKey.fromList(crypto.sodium, keyPair.privateKey)));

  final settingsController = SettingsController(
    settingsService: settingsService,
    eventBus: eventBus,
  );
  final recoveryGroupController = RecoveryGroupController(
    recoveryGroupService: RecoveryGroupService(storage: kvStorage),
    eventBus: eventBus,
    p2pRouter: p2pRouter,
  );
  final guardianController = GuardianController(
    // guardianService: GuardianService(storage: kvStorage, router: p2pRouter),
    guardianService: GuardianService(storage: kvStorage),
    eventBus: eventBus,
    p2pRouter: p2pRouter,
  );

  FlutterNativeSplash.removeAfter((BuildContext context) async {
    await settingsController.load();
    // await guardianController.load();
    await recoveryGroupController.load();
  });

  runApp(DIProvider(
    settingsController: settingsController,
    guardianController: guardianController,
    recoveryGroupController: recoveryGroupController,
  ));
}
