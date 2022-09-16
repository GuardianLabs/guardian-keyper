import 'package:event_bus/event_bus.dart';
import 'package:hive_flutter/hive_flutter.dart';

export 'package:provider/provider.dart';
export 'package:hive_flutter/hive_flutter.dart';

import 'model/core_model.dart';
import 'service/network_service.dart';
import 'service/platform_service.dart';

class DIContainer {
  static final _eventBus = EventBus();
  final GlobalsModel globals;
  final PlatformService platformService;
  final NetworkService networkService;
  final Box<SettingsModel> boxSettings;
  final Box<MessageModel> boxMessages;
  final Box<SecretShardModel> boxSecretShards;
  final Box<RecoveryGroupModel> boxRecoveryGroup;

  const DIContainer({
    this.globals = const GlobalsModel(),
    this.platformService = const PlatformService(),
    required this.networkService,
    required this.boxSettings,
    required this.boxMessages,
    required this.boxSecretShards,
    required this.boxRecoveryGroup,
  });

  EventBus get eventBus => _eventBus;

  PeerId get myPeerId => PeerId(value: networkService.router.pubKey.data);

  static Future<DIContainer> bootstrap({
    GlobalsModel globals = const GlobalsModel(),
    PlatformService platformService = const PlatformService(),
  }) async {
    await initCrypto();
    final keyBunch = await platformService.getKeyBunch(generateKeyBunch);
    final cipher = HiveAesCipher(keyBunch.encryptionAesKey);
    await Hive.initFlutter('data');
    Hive
      ..registerAdapter<MessageModel>(MessageModelAdapter())
      ..registerAdapter<SettingsModel>(SettingsModelAdapter())
      ..registerAdapter<SecretShardModel>(SecretShardModelAdapter())
      ..registerAdapter<RecoveryGroupModel>(RecoveryGroupModelAdapter());

    final boxMessages = await Hive.openBox<MessageModel>(
      'messages',
      encryptionCipher: cipher,
    );
    final boxSettings = await Hive.openBox<SettingsModel>(
      'settings',
      encryptionCipher: cipher,
    );
    final boxSecretShards = await Hive.openBox<SecretShardModel>(
      'shards',
      encryptionCipher: cipher,
    );
    final boxRecoveryGroup = await Hive.openBox<RecoveryGroupModel>(
      'groups',
      encryptionCipher: cipher,
    );
    if (boxSettings.deviceName.isEmpty) {
      boxSettings.deviceName =
          await platformService.getDeviceName(keyBunch.encryptionPublicKey);
    }
    return DIContainer(
      globals: globals,
      boxSettings: boxSettings,
      boxMessages: boxMessages,
      boxSecretShards: boxSecretShards,
      boxRecoveryGroup: boxRecoveryGroup,
      platformService: platformService,
      networkService: NetworkService.udp(
        keyBunch: keyBunch,
        bsAddressV4: boxSettings.isProxyEnabled ? globals.bsAddressV4 : null,
        bsAddressV6: boxSettings.isProxyEnabled ? globals.bsAddressV6 : null,
      ),
    );
  }
}

extension SettingsModelExt on Box<SettingsModel> {
  SettingsModel readWhole() => get(0) ?? const SettingsModel();
  Future<void> writeWhole(SettingsModel settings) => put(0, settings);

  String get passCode => readWhole().passCode;
  String get deviceName => readWhole().deviceName;
  bool get isBiometricsEnabled => readWhole().isBiometricsEnabled;
  bool get isProxyEnabled => readWhole().isProxyEnabled;

  set passCode(String value) =>
      writeWhole(readWhole().copyWith(passCode: value));
  set deviceName(String value) =>
      writeWhole(readWhole().copyWith(deviceName: value));
  set isBiometricsEnabled(bool value) =>
      writeWhole(readWhole().copyWith(isBiometricsEnabled: value));
  set isProxyEnabled(bool value) =>
      writeWhole(readWhole().copyWith(isProxyEnabled: value));
}

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 1;

  @override
  SettingsModel read(BinaryReader reader) =>
      SettingsModel.fromBytes(reader.readByteList());

  @override
  void write(BinaryWriter writer, SettingsModel obj) =>
      writer.writeByteList(obj.toBytes());
}

class SecretShardModelAdapter extends TypeAdapter<SecretShardModel> {
  @override
  final int typeId = 10;

  @override
  SecretShardModel read(BinaryReader reader) =>
      SecretShardModel.fromBytes(reader.readByteList());

  @override
  void write(BinaryWriter writer, SecretShardModel obj) =>
      writer.writeByteList(obj.toBytes());
}

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final int typeId = 11;

  @override
  MessageModel read(BinaryReader reader) =>
      MessageModel.fromBytes(reader.readByteList());

  @override
  void write(BinaryWriter writer, MessageModel obj) =>
      writer.writeByteList(obj.toBytes());
}

class RecoveryGroupModelAdapter extends TypeAdapter<RecoveryGroupModel> {
  @override
  final int typeId = 20;

  @override
  RecoveryGroupModel read(BinaryReader reader) =>
      RecoveryGroupModel.fromBytes(reader.readByteList());

  @override
  void write(BinaryWriter writer, RecoveryGroupModel obj) =>
      writer.writeByteList(obj.toBytes());
}
