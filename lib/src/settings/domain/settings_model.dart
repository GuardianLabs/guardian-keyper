import 'dart:typed_data';
import 'package:equatable/equatable.dart';

class SettingsModel extends Equatable {
  const SettingsModel({
    required this.seed,
    required this.passCode,
    required this.deviceName,
    required this.isBootstrapEnabled,
    required this.isBiometricsEnabled,
  });

  @override
  List<Object> get props => [
        seed,
        passCode,
        deviceName,
        isBootstrapEnabled,
        isBiometricsEnabled,
      ];

  final Uint8List seed;
  final String passCode, deviceName;
  final bool isBiometricsEnabled, isBootstrapEnabled;

  SettingsModel copyWith({
    final String? passCode,
    final String? deviceName,
    final bool? isBootstrapEnabled,
    final bool? isBiometricsEnabled,
  }) =>
      SettingsModel(
        seed: seed,
        passCode: passCode ?? this.passCode,
        deviceName: deviceName ?? this.deviceName,
        isBootstrapEnabled: isBootstrapEnabled ?? this.isBootstrapEnabled,
        isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
      );
}
