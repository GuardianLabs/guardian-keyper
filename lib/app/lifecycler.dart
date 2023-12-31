import 'dart:async';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/data/repositories/settings_repository.dart';
import 'package:guardian_keyper/ui/utils/current_route_observer.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';
import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';
import 'package:guardian_keyper/feature/message/data/message_repository.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';
import 'package:guardian_keyper/feature/message/ui/dialogs/on_message_active_dialog.dart';
import 'package:guardian_keyper/feature/message/ui/dialogs/on_qr_code_show_dialog.dart';
import 'package:guardian_keyper/feature/auth/ui/dialogs/on_demand_auth_dialog.dart';
import 'package:guardian_keyper/feature/home/ui/home_screen.dart';

class Lifecycler extends StatefulWidget {
  const Lifecycler({super.key});

  @override
  State<Lifecycler> createState() => _LifecyclerState();
}

class _LifecyclerState extends State<Lifecycler> with WidgetsBindingObserver {
  final _authManager = GetIt.I<AuthManager>();
  final _networkManager = GetIt.I<NetworkManager>();
  final _vaultRepository = GetIt.I<VaultRepository>();
  final _settingsRepository = GetIt.I<SettingsRepository>();
  final _messageInteractor = GetIt.I<MessageInteractor>();
  final _routeObserver = GetIt.I<CurrentRouteObserver>();

  late final StreamSubscription<MessageRepositoryEvent> _requestsStream;

  DateTime _lastExitTryAt = DateTime.timestamp();

  bool _canShowNotification = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Listen network requests
    _requestsStream = _messageInteractor.watch().listen(
      (e) {
        if (!_canShowNotification || e.isDeleted) return;
        final message = e.message;
        if (message == null || message.isCreated) return;
        final currentRouteName = _routeObserver.currentRouteName;
        if (currentRouteName == '/' ||
            currentRouteName == OnQRCodeShowDialog.route) {
          if (message.isReceived || message.hasResponse) {
            _canShowNotification = false;
            OnMessageActiveDialog.show(context, message: message).then(
              (_) {
                _canShowNotification = true;
                if (mounted && currentRouteName == OnQRCodeShowDialog.route) {
                  Navigator.of(context).popUntil((r) => r.isFirst);
                }
              },
            );
          }
        }
      },
    );
    // Do stuff on start
    Future.microtask(() async {
      if (_authManager.passCode.isEmpty) {
        await Navigator.of(context).pushNamed(routeIntro);
      } else {
        _messageInteractor.pruneMessages();
        await OnDemandAuthDialog.show(context);
      }
      await _networkManager.start();
    });
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await _networkManager.start();
        await _authManager.onResumed();
      case AppLifecycleState.paused:
        await _networkManager.stop();
        await _vaultRepository.flush();
        await _messageInteractor.flush();
        await _settingsRepository.flush();
      case _:
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Future<bool> didPopRoute() {
    final now = DateTime.timestamp();
    if (_lastExitTryAt.isBefore(now.subtract(snackBarDuration))) {
      _lastExitTryAt = now;
      showSnackBar(
        context,
        text: 'Tap back again to exit',
      );
      return Future.value(true);
    }
    return super.didPopRoute();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _requestsStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const HomeScreen();
}
