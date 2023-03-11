import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '/src/core/model/core_model.dart';

@immutable
class SettingsModel extends Equatable {
  final PeerId deviceId;
  final String passCode;
  final bool isBiometricsEnabled;
  final bool isBootstrapEnabled;

  const SettingsModel({
    required this.deviceId,
    this.passCode = '',
    this.isBiometricsEnabled = false,
    this.isBootstrapEnabled = true,
  });

  @override
  List<Object> get props => [
        isBiometricsEnabled,
        isBootstrapEnabled,
        passCode,
        deviceId,
      ];

  bool get isNameTooShort =>
      deviceId.name.length < IdWithNameBase.minNameLength;

  SettingsModel copyWith({
    PeerId? deviceId,
    String? passCode,
    bool? isBiometricsEnabled,
    bool? isBootstrapEnabled,
  }) =>
      SettingsModel(
        deviceId: deviceId ?? this.deviceId,
        passCode: passCode ?? this.passCode,
        isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
        isBootstrapEnabled: isBootstrapEnabled ?? this.isBootstrapEnabled,
      );
}
