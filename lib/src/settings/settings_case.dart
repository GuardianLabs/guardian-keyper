import 'dart:async';

import '/src/core/repository/repository_root.dart';

import 'settings_repository.dart';

export 'package:get_it/get_it.dart';
export 'package:flutter_bloc/flutter_bloc.dart';

export 'settings_model.dart';

class SettingsCase extends Cubit<SettingsModel> {
  SettingsCase({SettingsRepository? settingsRepository})
      : _settingsRepository =
            settingsRepository ?? GetIt.I<RepositoryRoot>().settingsRepository,
        super(const SettingsModel()) {
    _subscription = _settingsRepository.stream.listen((e) => emit(e));
  }

  final SettingsRepository _settingsRepository;
  late final StreamSubscription<SettingsModel> _subscription;

  Future<String> setDeviceName(final String value) async {
    await _settingsRepository.setDeviceName(value);
    emit(state.copyWith(deviceName: value));
    return value;
  }

  Future<String> setPassCode(final String value) async {
    await _settingsRepository.setPassCode(value);
    emit(state.copyWith(passCode: value));
    return value;
  }

  Future<bool> setIsBiometricsEnabled(final bool value) async {
    await _settingsRepository.setIsBiometricsEnabled(value);
    emit(state.copyWith(isBiometricsEnabled: value));
    return value;
  }

  Future<bool> setIsBootstrapEnabled(final bool value) async {
    await _settingsRepository.setIsBootstrapEnabled(value);
    emit(state.copyWith(isBootstrapEnabled: value));
    return value;
  }
}
