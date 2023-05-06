import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/data/mdns_manager.dart';
import 'package:guardian_keyper/src/core/data/network_manager.dart';
import 'package:guardian_keyper/src/core/data/platform_manager.dart';
import 'package:guardian_keyper/src/core/ui/page_presenter_base.dart';
import 'package:guardian_keyper/src/core/ui/widgets/auth/auth.dart';

import 'package:guardian_keyper/src/message/domain/message_model.dart';
import 'package:guardian_keyper/src/message/domain/messages_interactor.dart';
import 'package:guardian_keyper/src/message/ui/_dashboard/message_active_dialog.dart';
import 'package:guardian_keyper/src/settings/domain/settings_interactor.dart';
import 'package:guardian_keyper/src/vaults/domain/vault_interactor.dart';

export 'package:provider/provider.dart';

class HomePresenter extends PagePresenterBase with WidgetsBindingObserver {
  HomePresenter({
    required super.pages,
    required final BuildContext context,
  }) {
    WidgetsBinding.instance.addObserver(this);

    _messageStreamSubscription =
        _messagesInteractor.watchMessages().listen((event) {
      if (!_canShowMessage) return;
      if (event.deleted) return;
      final message = event.value as MessageModel;
      if (message.isNotReceived) return;
      final routeName = ModalRoute.of(context)?.settings.name;
      if (routeName == '/' || routeName == routeShowQrCode) {
        _canShowMessage = false;
        Navigator.of(context).popUntil((r) => r.isFirst);
        MessageActiveDialog.show(context: context, message: message)
            .then((_) => _canShowMessage = true);
      }
    });

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
    super.didChangeAppLifecycleState(state);
    if (kDebugMode) print(state);
    if (state == AppLifecycleState.resumed) {
      await _networkManager.start();
    } else if (state == AppLifecycleState.paused) {
      _networkManager.pause();
      await _vaultInteractor.pause();
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
      _messageStreamSubscription.cancel(),
    ]);
    super.dispose();
  }

  // Private
  final _mdnsManager = GetIt.I<MdnsManager>();
  final _networkManager = GetIt.I<NetworkManager>();
  final _platformManager = GetIt.I<PlatformManager>();
  final _vaultInteractor = GetIt.I<VaultInteractor>();
  final _messagesInteractor = GetIt.I<MessagesInteractor>();
  final _settingsInteractor = GetIt.I<SettingsInteractor>();

  late final StreamSubscription<BoxEvent> _messageStreamSubscription;

  bool _canShowMessage = true;
}
