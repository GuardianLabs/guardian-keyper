import 'package:hive_flutter/hive_flutter.dart';

import '/src/core/model/core_model.dart';

class SecretShardModelAdapter extends TypeAdapter<SecretShardModel> {
  @override
  final typeId = SecretShardModel.typeId;

  @override
  SecretShardModel read(BinaryReader reader) =>
      SecretShardModel.fromBytes(reader.readByteList());

  @override
  void write(BinaryWriter writer, SecretShardModel obj) =>
      writer.writeByteList(obj.toBytes());
}

class RecoveryGroupModelAdapter extends TypeAdapter<RecoveryGroupModel> {
  @override
  final typeId = RecoveryGroupModel.typeId;

  @override
  RecoveryGroupModel read(BinaryReader reader) =>
      RecoveryGroupModel.fromBytes(reader.readByteList());

  @override
  void write(BinaryWriter writer, RecoveryGroupModel obj) =>
      writer.writeByteList(obj.toBytes());
}

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final typeId = MessageModel.typeId;

  @override
  MessageModel read(BinaryReader reader) =>
      MessageModel.fromBytes(reader.readByteList());

  @override
  void write(BinaryWriter writer, MessageModel obj) =>
      writer.writeByteList(obj.toBytes());
}

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final typeId = SettingsModel.typeId;

  @override
  SettingsModel read(BinaryReader reader) =>
      SettingsModel.fromBytes(reader.readByteList());

  @override
  void write(BinaryWriter writer, SettingsModel obj) =>
      writer.writeByteList(obj.toBytes());
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
