import 'dart:io';
import 'package:flutter/material.dart' hide Router;
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:sodium/sodium.dart' show KeyPair, SecureKey;
import 'package:p2plib/p2plib.dart';

import 'src/di_provider.dart';
import 'src/core/service/event_bus.dart';
import 'src/core/service/kv_storage.dart';

import 'src/settings/settings_service.dart';
import 'src/settings/settings_controller.dart';
import 'src/recovery_group/recovery_group_service.dart';
import 'src/recovery_group/recovery_group_controller.dart';
import 'src/guardian/guardian_service.dart';
import 'src/guardian/guardian_controller.dart';

Future<String?> _getDeviceName() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final androidInfo = await deviceInfoPlugin.androidInfo;
    return androidInfo.model ?? androidInfo.id;
  }
  if (Platform.isIOS) {
    final iosInfo = await deviceInfoPlugin.iosInfo;
    return iosInfo.model ?? iosInfo.name;
  }
  return null;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final eventBus = EventBus();
  final kvStorage = KVStorage();
  final settingsService = SettingsService(kvStorage);

  final crypto = P2PCrypto();
  await crypto.init();
  final keyPair = await settingsService.getKeyPair();

  final router = Router(
    UdpConnection(),
    KeyPair(
        publicKey: keyPair.publicKey,
        secretKey: SecureKey.fromList(crypto.sodium, keyPair.privateKey)),
  );
  final settingsController = SettingsController(
    settingsService: settingsService,
    eventBus: eventBus,
  );
  final recoveryGroupController = RecoveryGroupController(
    recoveryGroupService: RecoveryGroupService(storage: kvStorage),
    eventBus: eventBus,
    router: router,
  );
  final guardianController = GuardianController(
    guardianService: GuardianService(storage: kvStorage),
    eventBus: eventBus,
    router: router,
  );

  FlutterNativeSplash.removeAfter((BuildContext context) async {
    await settingsController.load();
    await guardianController.load(
      await _getDeviceName(),
      await NetworkInfo().getWifiIP(),
    );
    await recoveryGroupController.load();
    await router.run();
  });

  runApp(DIProvider(
    settingsController: settingsController,
    guardianController: guardianController,
    recoveryGroupController: recoveryGroupController,
  ));
}
