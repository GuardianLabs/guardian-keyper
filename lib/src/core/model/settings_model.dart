part of 'core_model.dart';

@immutable
class SettingsModel extends Equatable {
  static const currentVersion = 1;

  final String passCode;
  final String deviceName;
  final bool isBiometricsEnabled;
  final bool isProxyEnabled;

  const SettingsModel({
    this.passCode = '',
    this.deviceName = '',
    this.isBiometricsEnabled = false,
    this.isProxyEnabled = true,
  });
  factory SettingsModel.fromBytes(Uint8List bytes) {
    final u = Unpacker(bytes);
    if (u.unpackInt() != currentVersion) throw const FormatException();
    return SettingsModel(
      passCode: u.unpackString()!,
      deviceName: u.unpackString()!,
      isBiometricsEnabled: u.unpackBool()!,
      isProxyEnabled: u.unpackBool()!,
    );
  }

  @override
  List<Object> get props => [
        passCode,
        deviceName,
        isBiometricsEnabled,
        isProxyEnabled,
      ];

  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packString(passCode)
      ..packString(deviceName)
      ..packBool(isBiometricsEnabled)
      ..packBool(isProxyEnabled);
    return p.takeBytes();
  }

  SettingsModel copyWith({
    String? passCode,
    String? deviceName,
    bool? isBiometricsEnabled,
    bool? isProxyEnabled,
  }) =>
      SettingsModel(
        passCode: passCode ?? this.passCode,
        deviceName: deviceName ?? this.deviceName,
        isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
        isProxyEnabled: isProxyEnabled ?? this.isProxyEnabled,
      );
}
