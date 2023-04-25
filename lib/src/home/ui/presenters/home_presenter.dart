import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';
import 'package:guardian_keyper/src/core/ui/page_presenter_base.dart';

import 'package:guardian_keyper/src/vaults/ui/_dashboard/pages/vaults_page.dart';
import 'package:guardian_keyper/src/vaults/ui/_dashboard/pages/shards_page.dart';

import 'package:guardian_keyper/src/message/domain/messages_interactor.dart';
import 'package:guardian_keyper/src/message/ui/_dashboard/message_active_dialog.dart';

export 'package:provider/provider.dart';

class HomePresenter extends PagePresenterBase {
  HomePresenter({
    required final BuildContext context,
    required super.pages,
  }) {
    _messageStreamSubscription = _messagesInteractor
        .watchMessages()
        .listen((event) => _onMessage(context, event));
  }

  @override
  void dispose() {
    _messageStreamSubscription.cancel();
    super.dispose();
  }

  void gotoShardsPage() => gotoPage<ShardsPage>();

  void gotoVaultsPage() => gotoPage<VaultsPage>();

  final _messagesInteractor = GetIt.I<MessagesInteractor>();

  late final StreamSubscription<BoxEvent> _messageStreamSubscription;

  bool _canShowMessage = true;

  void _onMessage(final BuildContext context, final BoxEvent event) {
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
  }
}
