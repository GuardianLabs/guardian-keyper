import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/src/vaults/domain/vault_interactor.dart';
import 'package:guardian_keyper/src/message/domain/messages_interactor.dart';
import 'package:guardian_keyper/src/settings/domain/settings_interactor.dart';

import '../consts.dart';
import '../data/mdns_manager.dart';
import '../data/network_manager.dart';
import '../data/platform_manager.dart';
import '../ui/widgets/auth/auth.dart';

class AppLifecycleObserver extends StatefulWidget {
  const AppLifecycleObserver({super.key, required this.child});

  final Widget child;

  @override
  State<AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends State<AppLifecycleObserver>
    with WidgetsBindingObserver {
  _AppLifecycleObserverState() {
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() async {
      _settingsInteractor.passCode.isEmpty
          ? await Navigator.of(context).pushNamed(routeIntro)
          : await showDemandPassCode(
              context: context,
              onVibrate: _platformManager.vibrate,
              currentPassCode: _settingsInteractor.passCode,
              useBiometrics: _settingsInteractor.useBiometrics,
              localAuthenticate: _platformManager.localAuthenticate,
            );
      _messagesInteractor.start();
      await _networkManager.start();
      await _mdnsManager.startDiscovery();
    });
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) async {
    if (kDebugMode) print(state);
    if (state == AppLifecycleState.resumed) {
      await _networkManager.start();
    } else {
      _networkManager.pause();
      await _vaultInteractor.flush();
      await _messagesInteractor.pause();
      await _mdnsManager.stopDiscovery();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _networkManager.stop();
    Future.wait([
      _mdnsManager.dispose(),
      _messagesInteractor.stop(),
    ]);
    super.dispose();
  }

  final _mdnsManager = GetIt.I<MdnsManager>();
  final _networkManager = GetIt.I<NetworkManager>();
  final _platformManager = GetIt.I<PlatformManager>();
  final _vaultInteractor = GetIt.I<VaultInteractor>();
  final _messagesInteractor = GetIt.I<MessagesInteractor>();
  final _settingsInteractor = GetIt.I<SettingsInteractor>();

  @override
  Widget build(final BuildContext context) => widget.child;
}
