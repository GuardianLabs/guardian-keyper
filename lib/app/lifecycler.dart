import 'dart:ui';
import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';
import 'package:guardian_keyper/feature/message/data/message_repository.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

import 'package:guardian_keyper/feature/home/ui/home_screen.dart';
import 'package:guardian_keyper/feature/auth/ui/dialogs/on_demand_auth_dialog.dart';
import 'package:guardian_keyper/feature/message/ui/dialogs/on_message_active_dialog.dart';

class Lifecycler extends StatefulWidget {
  const Lifecycler({super.key});

  @override
  State<Lifecycler> createState() => _LifecyclerState();
}

class _LifecyclerState extends State<Lifecycler>
    with WidgetsBindingObserver, RouteAware {
  final _authManager = GetIt.I<AuthManager>();
  final _networkManager = GetIt.I<NetworkManager>();
  final _messageInteractor = GetIt.I<MessageInteractor>();

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
        if (e.isDeleted) return;
        if (_canShowNotification && e.message!.isReceived) {
          _canShowNotification = false;
          OnMessageActiveDialog.show(
            context,
            message: e.message!,
          ).then((_) => _canShowNotification = true);
        }
      },
    );
    // Do stuff on start
    Future.microtask(() async {
      if (_authManager.passCode.isEmpty) {
        await Navigator.of(context).pushNamed(routeIntro);
      } else {
        unawaited(_messageInteractor.pruneMessages());
        await OnDemandAuthDialog.show(context);
      }
      await _networkManager.start();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didPushNext() {
    _canShowNotification = false;
    if (kDebugMode) print('Can Show Message: $_canShowNotification');
  }

  @override
  void didPopNext() {
    _canShowNotification = true;
    if (kDebugMode) print('Can Show Message: $_canShowNotification');
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //     case AppLifecycleState.paused:
  //     case _:
  //   }
  //   super.didChangeAppLifecycleState(state);
  // }

  @override
  void didHaveMemoryPressure() {
    if (kDebugMode) print('didHaveMemoryPressure');
    super.didHaveMemoryPressure();
  }

  @override
  Future<bool> didPopRoute() {
    if (kDebugMode) print('didPopRoute');
    // _canShowNotification == true means this route is current
    if (_canShowNotification) {
      final now = DateTime.timestamp();
      if (_lastExitTryAt.isBefore(now.subtract(snackBarDuration))) {
        _lastExitTryAt = now;
        showSnackBar(
          context,
          text: 'Tap back again to exit',
        );
        return Future.value(true);
      }
    }
    return super.didPopRoute();
  }

  @override
  Future<AppExitResponse> didRequestAppExit() {
    if (kDebugMode) print('didRequestAppExit');
    return super.didRequestAppExit();
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
