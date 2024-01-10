import 'package:flutter/material.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/data/managers/auth_manager.dart';
import 'package:guardian_keyper/data/managers/network_manager.dart';

import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';
import 'package:guardian_keyper/feature/auth/ui/dialogs/on_demand_auth_dialog.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

class Lifecycle extends StatefulWidget {
  const Lifecycle({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<Lifecycle> createState() => _LifecycleState();
}

class _LifecycleState extends State<Lifecycle> with WidgetsBindingObserver {
  final _authManager = GetIt.I<AuthManager>();
  final _networkManager = GetIt.I<NetworkManager>();
  final _vaultRepository = GetIt.I<VaultRepository>();
  final _messageInteractor = GetIt.I<MessageInteractor>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() async {
      if (_authManager.passCode.isEmpty) {
        await Navigator.of(context).pushNamed(
          buildV3 ? routeOnboarding : routeIntro,
        );
      } else if (_authManager.passCode.isNotEmpty) {
        await OnDemandAuthDialog.show(context);
        await _messageInteractor.pruneMessages();
      }
      await _networkManager.start();
    });
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        await _authManager.onResumed();
        if (_authManager.needPasscode && mounted) {
          await OnDemandAuthDialog.show(context);
        }
        await _networkManager.start();
      case AppLifecycleState.inactive:
        await _authManager.onInactive();
      case AppLifecycleState.paused:
        await _networkManager.stop();
        await _vaultRepository.flush();
        await _messageInteractor.flush();
      case _:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
