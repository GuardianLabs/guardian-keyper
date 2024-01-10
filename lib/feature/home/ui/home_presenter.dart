import 'package:guardian_keyper/data/managers/auth_manager.dart';
import 'package:guardian_keyper/data/managers/network_manager.dart';
import 'package:guardian_keyper/data/repositories/settings_repository.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';
import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';
import 'package:guardian_keyper/ui/utils/page_controller_base.dart';

export 'package:provider/provider.dart';

class HomePresenter extends PageControllerBase {
  HomePresenter({
    required super.stepsCount,
    super.initialPage,
  });

  final _authManager = GetIt.I<AuthManager>();
  final _networkManager = GetIt.I<NetworkManager>();
  final _vaultRepository = GetIt.I<VaultRepository>();
  final _messageInteractor = GetIt.I<MessageInteractor>();
  final _settingsRepository = GetIt.I<SettingsRepository>();

  bool get needPasscode => _authManager.needPasscode;

  bool get isFirstStart => _authManager.passCode.isEmpty;
  bool get isNotFirstStart => _authManager.passCode.isNotEmpty;

  Future<void> onStart() async {
    await _networkManager.start();
  }

  Future<void> onResumed() async {
    await _authManager.onResumed();
  }

  Future<void> onInactive() async {
    await _authManager.onInactive();
  }

  Future<void> onPaused() async {
    await _networkManager.stop();
    await _vaultRepository.flush();
    await _messageInteractor.pruneMessages();
  }
}
