import 'package:flutter_bloc/flutter_bloc.dart';

import '/src/core/consts.dart';
import '/src/core/model/core_model.dart';
import '/src/core/service/platform_service.dart';
import '/src/core/service/p2p_network_service.dart';

import 'settings_model.dart';
import 'settings_repository.dart';

export 'package:get_it/get_it.dart';
export 'package:flutter_bloc/flutter_bloc.dart';

export 'settings_model.dart';

class SettingsController extends Cubit<SettingsModel> {
  late final bool hasBiometrics;

  final _repository = GetIt.I<SettingsRepository>();

  SettingsController()
      : super(SettingsModel(
          deviceId: PeerId(token: GetIt.I<P2PNetworkService>().myId),
        ));

  Future<void> init() async {
    hasBiometrics = await GetIt.I<PlatformService>().hasBiometrics;
    var deviceName = await _repository.getDeviceName();
    if (deviceName.isEmpty) {
      deviceName = await GetIt.I<PlatformService>()
          .getDeviceName(maxNameLength: IdWithNameBase.maxNameLength);
    }
    emit(SettingsModel(
      deviceId: state.deviceId.copyWith(name: deviceName),
      passCode: await _repository.getPassCode(),
      isBootstrapEnabled: await _repository.getIsBootstrapEnabled(),
      isBiometricsEnabled: await _repository.getIsBiometricsEnabled(),
    ));
  }

  void setDeviceName(final String deviceName) => emit(state.copyWith(
        deviceId: state.deviceId.copyWith(name: deviceName),
      ));

  Future<void> saveDeviceName() =>
      _repository.setDeviceName(state.deviceId.name);

  Future<void> setPassCode(final String passCode) async {
    await _repository.setPassCode(passCode);
    emit(state.copyWith(passCode: passCode));
  }

  Future<void> setIsBiometricsEnabled(final bool isBiometricsEnabled) async {
    await _repository.setIsBiometricsEnabled(isBiometricsEnabled);
    emit(state.copyWith(isBiometricsEnabled: isBiometricsEnabled));
  }

  Future<void> setIsBootstrapEnabled(final bool isBootstrapEnabled) async {
    final p2pNetworkService = GetIt.I<P2PNetworkService>();
    isBootstrapEnabled
        ? p2pNetworkService.addBootstrapServer(
            peerId: Envs.bsPeerId,
            ipV4: Envs.bsAddressV4,
            ipV6: Envs.bsAddressV6,
            port: Envs.bsPort,
          )
        : p2pNetworkService.addBootstrapServer(peerId: Envs.bsPeerId);
    await _repository.setIsBootstrapEnabled(isBootstrapEnabled);
    emit(state.copyWith(isBootstrapEnabled: isBootstrapEnabled));
  }
}
