import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../domain/message_model.dart';
import '../../../domain/messages_interactor.dart';

export 'package:provider/provider.dart';

class MessagesPresenter extends ChangeNotifier {
  late final archivateMessage = _messagesInteractor.archivateMessage;

  List<MessageModel> get activeMessages => _activeMessages;
  List<MessageModel> get resolvedMessages => _resolvedMessages;

  MessagesPresenter() {
    // cache and sort messages
    for (final message in _messagesInteractor.messages) {
      if (message.peerId != _messagesInteractor.selfId) {
        message.isReceived
            ? _activeMessages.add(message)
            : _resolvedMessages.add(message);
      }
    }
    _activeMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    _resolvedMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    _messagesUpdatesSubscription =
        _messagesInteractor.watchMessages().listen(_onMessagesUpdates);
  }

  final _activeMessages = <MessageModel>[];
  final _resolvedMessages = <MessageModel>[];
  final _messagesInteractor = GetIt.I<MessagesInteractor>();

  late final StreamSubscription<BoxEvent> _messagesUpdatesSubscription;

  @override
  void dispose() {
    _messagesUpdatesSubscription.cancel();
    super.dispose();
  }

  void _onMessagesUpdates(final BoxEvent event) {
    if (event.deleted) {
      final key = event.key as String;
      _activeMessages.removeWhere((e) => e.aKey == key);
      _resolvedMessages.removeWhere((e) => e.aKey == key);
    } else {
      final message = event.value as MessageModel;
      if (message.peerId == _messagesInteractor.selfId) return;
      if (message.isReceived) {
        final index = _activeMessages.indexOf(message);
        index < 0
            ? _activeMessages.add(message)
            : _activeMessages[index] = message;
      } else {
        final index = _resolvedMessages.indexOf(message);
        index < 0
            ? _resolvedMessages.add(message)
            : _resolvedMessages[index] = message;
      }
    }
    notifyListeners();
  }
}
