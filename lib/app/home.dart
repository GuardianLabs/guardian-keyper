import 'dart:async';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';
// import 'package:guardian_keyper/feature/wallet/data/wallet_manager.dart';
import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

import 'package:guardian_keyper/feature/message/ui/request_handler.dart';
import 'package:guardian_keyper/feature/auth/ui/dialogs/on_demand_auth_dialog.dart';
// import 'package:guardian_keyper/feature/onboarding/ui/onboarding_screen.dart';
import 'package:guardian_keyper/feature/home/ui/home_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final _authManager = GetIt.I<AuthManager>();
  // final _walletManager = GetIt.I<WalletManager>();
  final _networkManager = GetIt.I<NetworkManager>();
  final _vaultRepository = GetIt.I<VaultRepository>();
  final _messageInteractor = GetIt.I<MessageInteractor>();

  DateTime _lastExitTryAt = DateTime.now();

  bool _canShowHome = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() async {
      // if (_walletManager.hasNoEntropy) {
      if (_authManager.passCode.isEmpty) {
        Navigator.of(context).pushNamed(routeIntro).then(_unlock);
      } else if (_authManager.passCode.isNotEmpty) {
        OnDemandAuthDialog.show(context).then(_unlock);
        await _messageInteractor.pruneMessages();
      }
    });
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        await _authManager.onResumed();
        if (_authManager.needPasscode && mounted) {
          OnDemandAuthDialog.show(context).then(_unlock);
        }
      case AppLifecycleState.paused:
        await _authManager.onPause();
        await _networkManager.stop();
        await _vaultRepository.flush();
        await _messageInteractor.flush();
      case _:
    }
  }

  @override
  Future<bool> didPopRoute() {
    final now = DateTime.now();
    if (_lastExitTryAt.isBefore(now.subtract(snackBarDuration))) {
      _lastExitTryAt = now;
      showSnackBar(context, text: 'Tap back again to exit');
      return Future.value(true);
    }
    return super.didPopRoute();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _canShowHome
      ? const RequestHandler(child: HomeScreen())
      : Container(color: Theme.of(context).canvasColor);

  Future<void> _unlock([_]) async {
    setState(() => _canShowHome = true);
    await _networkManager.start();
  }
}
