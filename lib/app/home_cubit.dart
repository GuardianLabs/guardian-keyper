import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';
// import 'package:guardian_keyper/feature/wallet/data/wallet_manager.dart';
import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

export 'package:get_it/get_it.dart';
export 'package:flutter_bloc/flutter_bloc.dart';

enum HomeState { initial, normal, needAuth, needOnboarding }

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial);

  final _authManager = GetIt.I<AuthManager>();
  // final _walletManager = GetIt.I<WalletManager>();
  final _networkManager = GetIt.I<NetworkManager>();
  final _vaultRepository = GetIt.I<VaultRepository>();
  final _messageInteractor = GetIt.I<MessageInteractor>();

  Future<void> onResumed() async {
    if (state == HomeState.normal) {
      await _networkManager.start();
      await _authManager.onResumed();
    }
  }

  Future<void> onPaused() async {
    await _networkManager.stop();
    await _vaultRepository.flush();
    await _messageInteractor.flush();
    emit(HomeState.needAuth);
  }

  Future<void> unlock([_]) async {
    await _networkManager.start();
    emit(HomeState.normal);
  }

  Future<void> start() async {
    // if (_walletManager.hasNoEntropy) {
    if (_authManager.passCode.isEmpty) {
      emit(HomeState.needOnboarding);
    } else if (_authManager.passCode.isNotEmpty) {
      emit(HomeState.needAuth);
      await _messageInteractor.pruneMessages();
    }
  }
}
