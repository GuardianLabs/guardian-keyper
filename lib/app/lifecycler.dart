import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/utils/current_route_observer.dart';

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
  final _routeObserver = GetIt.I<CurrentRouteObserver>();
  final _messageInteractor = GetIt.I<MessageInteractor>();

  late final StreamSubscription<MessageRepositoryEvent> _requestsStream;

  bool _canShowMessage = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestsStream = _messageInteractor.watch().listen(_onRequest);
    Future.microtask(_onFirstStart);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPushNext() {
    _canShowMessage = false;
    if (kDebugMode) print('Can Show Message: $_canShowMessage');
  }

  @override
  void didPopNext() {
    _canShowMessage = true;
    if (kDebugMode) print('Can Show Message: $_canShowMessage');
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
    return super.didPopRoute();
  }

  @override
  Future<AppExitResponse> didRequestAppExit() {
    if (kDebugMode) print('didRequestAppExit');
    return super.didRequestAppExit();
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    _routeObserver.unsubscribe(this);
    await _requestsStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const HomeScreen();

  void _onRequest(MessageRepositoryEvent event) {
    if (!_canShowMessage) return;
    if (event.isDeleted || event.message!.isNotReceived) return;
    OnMessageActiveDialog.show(context, message: event.message!);
  }

  Future<void> _onFirstStart() async {
    if (_authManager.passCode.isEmpty) {
      await Navigator.of(context).pushNamed(routeIntro);
    } else {
      unawaited(_messageInteractor.pruneMessages());
      await OnDemandAuthDialog.show(context);
    }
    await _networkManager.start();
  }
}
