import 'dart:async';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/message/ui/request_handler.dart';
import 'package:guardian_keyper/feature/auth/ui/dialogs/on_demand_auth_dialog.dart';
// import 'package:guardian_keyper/feature/onboarding/ui/onboarding_screen.dart';
import 'package:guardian_keyper/feature/home/ui/home_screen.dart';

import 'home_cubit.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  late final _cubit = GetIt.I<HomeCubit>();

  DateTime _lastExitTryAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(_cubit.start);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await _cubit.onResume();
      case AppLifecycleState.paused:
        await _cubit.onPause();
      case _:
    }
    super.didChangeAppLifecycleState(state);
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
  Widget build(BuildContext context) => BlocConsumer<HomeCubit, HomeState>(
        bloc: _cubit,
        buildWhen: (p, c) => c == HomeState.normal,
        builder: (context, state) => switch (state) {
          HomeState.normal => const RequestHandler(
              key: Key('RequestHandlerWidget'),
              child: HomeScreen(
                key: Key('HomeScreenWidget'),
              ),
            ),
          _ => Container(color: Theme.of(context).canvasColor),
        },
        listener: (context, state) {
          switch (state) {
            case HomeState.needAuth:
              OnDemandAuthDialog.show(context).then(_cubit.unlock);
            case HomeState.needOnboarding:
              Navigator.of(context).pushNamed(routeIntro).then(_cubit.unlock);
            case _:
          }
        },
      );
}
