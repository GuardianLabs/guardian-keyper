import 'package:flutter/material.dart';

import 'package:guardian_keyper/ui/utils/current_route_observer.dart';

import '../domain/use_case/message_interactor.dart';
import 'dialogs/on_message_active_dialog.dart';
import 'dialogs/on_qr_code_show_dialog.dart';

class RequestHandler extends StatefulWidget {
  const RequestHandler({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<RequestHandler> createState() => _RequestHandlerState();
}

class _RequestHandlerState extends State<RequestHandler> {
  final _routeObserver = GetIt.I<CurrentRouteObserver>();

  late final _requestsStream = GetIt.I<MessageInteractor>().watch().listen(
    (e) {
      if (!_canShowNotification || e.isDeleted) return;
      final message = e.message;
      if (message == null || message.isCreated) return;
      final currentRouteName = _routeObserver.currentRouteName;
      if (currentRouteName == '/' ||
          currentRouteName == OnQRCodeShowDialog.route) {
        if (message.isReceived || message.hasResponse) {
          _canShowNotification = false;
          OnMessageActiveDialog.show(
            context,
            message: message,
          ).then(
            (_) {
              _canShowNotification = true;
              if (mounted && currentRouteName == OnQRCodeShowDialog.route) {
                Navigator.of(context).popUntil((r) => r.isFirst);
              }
            },
          );
        }
      }
    },
  );

  bool _canShowNotification = true;

  @override
  void initState() {
    super.initState();
    _requestsStream.resume();
  }

  @override
  void dispose() {
    _requestsStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
