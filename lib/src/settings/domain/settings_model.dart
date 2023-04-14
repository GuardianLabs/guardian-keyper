import 'dart:typed_data';

enum SettingsKeys {
  seed,
  passCode,
  deviceName,
  isBootstrapEnabled,
  isBiometricsEnabled,
}

class SettingsEvent {
  final SettingsKeys key;
  final SettingsModel value;

  const SettingsEvent({required this.key, required this.value});
}

class SettingsModel {
  const SettingsModel({
    required this.seed,
    required this.passCode,
    required this.deviceName,
    required this.isBootstrapEnabled,
    required this.isBiometricsEnabled,
  });

  @override
  bool operator ==(Object other) =>
      other is SettingsModel &&
      runtimeType == other.runtimeType &&
      seed == other.seed &&
      passCode == other.passCode &&
      deviceName == other.deviceName &&
      isBootstrapEnabled == other.isBootstrapEnabled &&
      isBiometricsEnabled == other.isBiometricsEnabled;

  @override
  int get hashCode => Object.hash(
        runtimeType,
        passCode,
        deviceName,
        isBootstrapEnabled,
        isBiometricsEnabled,
      );

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
