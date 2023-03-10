import 'package:flutter_bloc/flutter_bloc.dart';

import '/src/core/model/core_model.dart';
import '/src/core/service/platform_service.dart';
import '/src/core/service/p2p_network_service.dart';

import 'settings_model.dart';
import 'settings_repository.dart';

export 'package:get_it/get_it.dart';
export 'package:flutter_bloc/flutter_bloc.dart';

export 'settings_model.dart';

class SettingsCubit extends Cubit<SettingsModel> {
  late final bool hasBiometrics;
  final _repository = GetIt.I<SettingsRepository>();

  SettingsCubit() : super(const SettingsModel());

  set deviceName(final String deviceName) =>
      emit(state.copyWith(deviceName: deviceName));

  Future<SettingsModel> init() async {
    hasBiometrics = await GetIt.I<PlatformService>().hasBiometrics;
    var deviceName = await _repository.getDeviceName();
    if (deviceName.isEmpty) {
      deviceName = await GetIt.I<PlatformService>()
          .getDeviceName(maxNameLength: SettingsModel.maxNameLength);
    }
    final settings = SettingsModel(
      passCode: await _repository.getPassCode(),
      deviceName: deviceName,
      isBootstrapEnabled: await _repository.getIsBootstrapEnabled(),
      isBiometricsEnabled: await _repository.getIsBiometricsEnabled(),
    );
    emit(settings);
    return settings;
  }

  Future<void> setDeviceName(final String deviceName) async {
    await _repository.setDeviceName(deviceName);
    emit(state.copyWith(deviceName: deviceName));
  }

  Future<void> setPassCode(final String passCode) async {
    await _repository.setPassCode(passCode);
    emit(state.copyWith(passCode: passCode));
  }

  Future<void> setIsBiometricsEnabled(final bool isBiometricsEnabled) async {
    await _repository.setIsBiometricsEnabled(isBiometricsEnabled);
    emit(state.copyWith(isBiometricsEnabled: isBiometricsEnabled));
  }

  Future<void> setIsBootstrapEnabled(final bool isBootstrapEnabled) async {
    final globals = GetIt.I<Globals>();
    final p2pNetworkService = GetIt.I<P2PNetworkService>();
    isBootstrapEnabled
        ? p2pNetworkService.addBootstrapServer(
            peerId: globals.bsPeerId,
            ipV4: globals.bsAddressV4,
            ipV6: globals.bsAddressV6,
            port: globals.bsPort,
          )
        : p2pNetworkService.addBootstrapServer(peerId: globals.bsPeerId);
    await _repository.setIsBootstrapEnabled(isBootstrapEnabled);
    emit(state.copyWith(isBootstrapEnabled: isBootstrapEnabled));
  }

  // Future<void> save() async {
  //   await _repository.setDeviceName(state.deviceName);
  // }
}
