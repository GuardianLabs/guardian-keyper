import 'package:equatable/equatable.dart';

import '/src/core/model/core_model.dart';

class SettingsModel extends Equatable {
  static const minNameLength = IdWithNameBase.minNameLength;
  static const maxNameLength = IdWithNameBase.maxNameLength;

  final bool isBiometricsEnabled, isBootstrapEnabled, hasBiometrics;
  final String passCode, deviceName;

  const SettingsModel({
    this.passCode = '',
    this.deviceName = '',
    this.isBiometricsEnabled = false,
    this.isBootstrapEnabled = true,
    this.hasBiometrics = false,
  });

  @override
  List<Object> get props => [
        isBiometricsEnabled,
        isBootstrapEnabled,
        hasBiometrics,
        deviceName,
        passCode,
      ];

  bool get isEmpty => passCode.isEmpty && deviceName.isEmpty;

  bool get isNotEmpty => passCode.isNotEmpty || deviceName.isNotEmpty;

  SettingsModel copyWith({
    final String? deviceName,
    final String? passCode,
    final bool? isBiometricsEnabled,
    final bool? isBootstrapEnabled,
    final bool? hasBiometrics,
  }) =>
      SettingsModel(
        deviceName: deviceName ?? this.deviceName,
        passCode: passCode ?? this.passCode,
        isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
        isBootstrapEnabled: isBootstrapEnabled ?? this.isBootstrapEnabled,
        hasBiometrics: hasBiometrics ?? this.hasBiometrics,
      );
}
