import 'dart:io';
import 'package:flutter/material.dart' hide Router;
import 'package:flutter/services.dart';
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

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final deviceAddress = await NetworkInfo().getWifiIP();
  String? deviceName;
  final deviceInfoPlugin = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfoPlugin.androidInfo;
    deviceName = androidInfo.model ?? androidInfo.id;
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfoPlugin.iosInfo;
    deviceName = iosInfo.model ?? iosInfo.name;
  }

  final eventBus = EventBus();
  final kvStorage = KVStorage();
  final settingsService = SettingsService(
    storage: kvStorage,
    deviceName: deviceName ?? '',
  );

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
    keyPair: keyPair,
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

  try {
    await settingsController.load();
    await guardianController.load(
      settingsController.deviceName,
      deviceAddress,
    );
    await recoveryGroupController.load(
      settingsController.deviceName,
      deviceAddress,
    );
  } catch (_) {}

  await router.run();

  runApp(DIProvider(
    settingsController: settingsController,
    guardianController: guardianController,
    recoveryGroupController: recoveryGroupController,
  ));
  FlutterNativeSplash.remove();
}
