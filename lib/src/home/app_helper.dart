import 'dart:async';

import '/src/core/consts.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/auth/auth.dart';
import '/src/core/service/service_root.dart';
import '/src/core/repository/repository_root.dart';

import '/src/message/ui/widgets/message_action_widget.dart';

class AppHelper extends StatefulWidget {
  final Widget child;

  const AppHelper({super.key, required this.child});

  @override
  State<AppHelper> createState() => _AppHelperState();
}

class _AppHelperState extends State<AppHelper> with WidgetsBindingObserver {
  final _serviceRoot = GetIt.I<ServiceRoot>();
  final _repositoryRoot = GetIt.I<RepositoryRoot>();

  late final StreamSubscription<BoxEvent> _messageStreamSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _messageStreamSubscription =
        _repositoryRoot.messageRepository.watch().listen((event) {
      if (ModalRoute.of(context)?.isCurrent != true) return;
      if (event.deleted) return;
      final message = event.value as MessageModel;
      if (message.isNotReceived) return;
      MessageActionBottomSheet.show(context, message);
    });

    Future.microtask(() async {
      if (_repositoryRoot.settingsRepository.state.passCode.isEmpty) {
        await Navigator.of(context).pushNamed(routeIntro);
      } else {
        await _demandPassCode(context);
        await _pruneMessages();
      }
      await _serviceRoot.networkService.start();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await _demandPassCode(context);
      await _serviceRoot.networkService.start();
    } else {
      await _serviceRoot.networkService.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => widget.child;

  Future<void> _demandPassCode(final BuildContext context) =>
      showDemandPassCode(
        context: context,
        onVibrate: _serviceRoot.platformService.vibrate,
        currentPassCode: _repositoryRoot.settingsRepository.state.passCode,
        localAuthenticate: _serviceRoot.platformService.localAuthenticate,
        useBiometrics: _repositoryRoot.settingsRepository.state.hasBiometrics &&
            _repositoryRoot.settingsRepository.state.isBiometricsEnabled,
      );

  Future<void> _pruneMessages() async {
    if (_repositoryRoot.messageRepository.isEmpty) return;
    final expired = _repositoryRoot.messageRepository.values
        .where((e) =>
            e.isRequested &&
            (e.code == MessageCode.createGroup ||
                e.code == MessageCode.takeGroup) &&
            e.timestamp
                .isBefore(DateTime.now().subtract(const Duration(days: 1))))
        .toList(growable: false);
    await _repositoryRoot.messageRepository
        .deleteAll(expired.map((e) => e.aKey));
    await _repositoryRoot.messageRepository.compact();
  }
}
