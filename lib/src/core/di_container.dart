import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'model/core_model.dart';
import 'adapter/hive_adapter.dart';
import 'service/auth_service.dart';
import 'service/platform_service.dart';
import 'service/analytics_service.dart';
import 'service/p2p_network_service.dart';

export 'package:hive_flutter/hive_flutter.dart';
export 'package:provider/provider.dart';
export 'adapter/hive_adapter.dart';

class DIContainer with WidgetsBindingObserver {
  final Globals globals;
  final AuthService authService;
  final AnalyticsService analyticsService;
  final PlatformService platformService;
  final P2PNetworkService networkService;
  late final Box<SettingsModel> boxSettings;
  late final Box<MessageModel> boxMessages;
  late final Box<RecoveryGroupModel> boxRecoveryGroups;

  late PeerId _myPeerId;

  DIContainer({
    this.globals = const Globals(),
    this.authService = const AuthService(),
    P2PNetworkService? networkService,
    this.platformService = const PlatformService(),
    this.analyticsService = const AnalyticsService(),
  }) : networkService = networkService ?? P2PNetworkService(globals: globals) {
    WidgetsBinding.instance.addObserver(this);
  }

  PeerId get myPeerId => _myPeerId;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      await boxSettings.flush();
      await boxRecoveryGroups.flush();
      await boxMessages.flush();
    }
  }

  Future<DIContainer> init() async {
    final storedKeyBunch = await platformService.readKeyBunch();
    final keyBunch = await networkService.init(storedKeyBunch);
    if (keyBunch != storedKeyBunch) {
      await platformService.writeKeyBunch(keyBunch);
    }

    final cipher = HiveAesCipher(keyBunch.encryptionAesKey);
    await Hive.initFlutter(globals.storageName);
    Hive
      ..registerAdapter<MessageModel>(MessageModelAdapter())
      ..registerAdapter<SettingsModel>(SettingsModelAdapter())
      ..registerAdapter<SecretShardModel>(SecretShardModelAdapter())
      ..registerAdapter<RecoveryGroupModel>(RecoveryGroupModelAdapter());

    boxMessages = await Hive.openBox<MessageModel>(
      MessageModel.boxName,
      encryptionCipher: cipher,
    );
    boxSettings = await Hive.openBox<SettingsModel>(
      SettingsModel.boxName,
      encryptionCipher: cipher,
    );
    boxRecoveryGroups = await Hive.openBox<RecoveryGroupModel>(
      RecoveryGroupModel.boxName,
      encryptionCipher: cipher,
    );
    if (boxSettings.deviceName.isEmpty) {
      final deviceName =
          await platformService.getDeviceName(keyBunch.encryptionPublicKey);
      boxSettings.deviceName = deviceName.length > globals.maxNameLength
          ? deviceName.substring(0, globals.maxNameLength)
          : deviceName;
    }
    _myPeerId = PeerId(
      token: networkService.router.selfId.value,
      name: boxSettings.deviceName,
    );
    if (boxSettings.isProxyEnabled) {
      networkService.addBootstrapServer(
        peerId: globals.bsPeerId,
        ipV4: globals.bsAddressV4,
        ipV6: globals.bsAddressV6,
        port: globals.bsPort,
      );
    }
    boxSettings.watch().listen(
          (event) => _myPeerId = PeerId(
            token: networkService.router.selfId.value,
            name: (event.value as SettingsModel).deviceName,
          ),
        );
    return this;
  }
}
