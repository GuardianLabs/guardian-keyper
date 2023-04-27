import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

import '../../../domain/messages_interactor.dart';
import '../message_active_dialog.dart';

class MessageHandler extends StatefulWidget {
  const MessageHandler({super.key, required this.child});

  final Widget child;

  @override
  State<MessageHandler> createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  late final StreamSubscription<BoxEvent> _messageStreamSubscription;

  bool _canShowMessage = true;

  @override
  void initState() {
    super.initState();
    _messageStreamSubscription =
        GetIt.I<MessagesInteractor>().watchMessages().listen((event) {
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
  }

  @override
  void dispose() {
    _messageStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => widget.child;
}
