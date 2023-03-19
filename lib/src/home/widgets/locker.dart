import '/src/core/widgets/common.dart';
import '/src/core/model/core_model.dart';

import '/src/guardian/widgets/message_list_tile.dart';

import '../home_presenter.dart';

class Locker extends StatefulWidget {
  const Locker({super.key});

  @override
  State<Locker> createState() => _LockerState();
}

class _LockerState extends State<Locker> with WidgetsBindingObserver {
  _LockerState() {
    WidgetsBinding.instance.addObserver(this);
  }

  late final _controller = context.read<HomePresenter>();

  @override
  void initState() {
    super.initState();

    _controller.messageStreamSubscription.onData((event) {
      if (ModalRoute.of(context)?.isCurrent != true) return;
      if (event.deleted) return;
      final message = event.value as MessageModel;
      if (message.isNotReceived) return;
      MessageListTile.showActiveMessage(context, message);
    });

    Future.microtask(() => _controller.init(context));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      _controller.demandPassCode(context);
    }
  }

  @override
  Widget build(final BuildContext context) => const Offstage();
}
