import 'package:flutter/foundation.dart';
import 'package:messagepack/messagepack.dart';

import '/src/core/model/core_model.dart';

@immutable
class SettingsModel extends Serializable {
  static const currentVersion = 1;
  static const minNameLength = 3;
  static const maxNameLength = 25;

  final String passCode;
  final String deviceName;
  final bool isBiometricsEnabled;
  final bool isBootstrapEnabled;

  const SettingsModel({
    this.passCode = '',
    this.deviceName = '',
    this.isBiometricsEnabled = false,
    this.isBootstrapEnabled = true,
  });

  factory SettingsModel.fromBytes(Uint8List bytes) {
    final u = Unpacker(bytes);
    if (u.unpackInt() != currentVersion) throw const FormatException();
    return SettingsModel(
      passCode: u.unpackString()!,
      deviceName: u.unpackString()!,
      isBiometricsEnabled: u.unpackBool()!,
      isBootstrapEnabled: u.unpackBool()!,
    );
  }

  @override
  List<Object> get props => [
        passCode,
        deviceName,
        isBiometricsEnabled,
        isBootstrapEnabled,
      ];

  @override
  bool get isEmpty => passCode.isEmpty && deviceName.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  bool get isNameTooShort => deviceName.length < minNameLength;

  @override
  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packString(passCode)
      ..packString(deviceName)
      ..packBool(isBiometricsEnabled)
      ..packBool(isBootstrapEnabled);
    return p.takeBytes();
  }

  SettingsModel copyWith({
    String? passCode,
    String? deviceName,
    bool? isBiometricsEnabled,
    bool? isBootstrapEnabled,
  }) =>
      SettingsModel(
        passCode: passCode ?? this.passCode,
        deviceName: deviceName ?? this.deviceName,
        isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
        isBootstrapEnabled: isBootstrapEnabled ?? this.isBootstrapEnabled,
      );
}
