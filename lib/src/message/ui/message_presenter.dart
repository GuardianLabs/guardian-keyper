import 'dart:async';
import 'package:flutter/foundation.dart';

import '../data/message_repository.dart';
import '../domain/messages_interactor.dart';

export 'package:provider/provider.dart';

class MessagesPresenter extends ChangeNotifier {
  late final messageTTL = _messagesInteractor.messageTTL;
  late final archivateMessage = _messagesInteractor.archivateMessage;
  late final getPeerStatus = _messagesInteractor.getPeerStatus;
  late final pingPeer = _messagesInteractor.pingPeer;

  List<MessageModel> get activeMessages => _activeMessages;
  List<MessageModel> get resolvedMessages => _resolvedMessages;

  MessagesPresenter({MessagesInteractor? messagesInteractor})
      : _messagesInteractor = messagesInteractor ?? MessagesInteractor() {
    // cache and sort messages
    for (final message in _messagesInteractor.messages) {
      if (message.peerId == _messagesInteractor.myPeerId) continue;
      message.isReceived
          ? _activeMessages.add(message)
          : _resolvedMessages.add(message);
    }
    _activeMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    _resolvedMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    _messagesUpdatesSubscription =
        _messagesInteractor.watchMessages().listen(_onMessagesUpdates);
  }

  final _activeMessages = <MessageModel>[];
  final _resolvedMessages = <MessageModel>[];

  final MessagesInteractor _messagesInteractor;

  late final StreamSubscription<BoxEvent> _messagesUpdatesSubscription;

  @override
  void dispose() {
    _messagesUpdatesSubscription.cancel();
    super.dispose();
  }

  Future<void> sendRespone(final MessageModel response) {
    switch (response.code) {
      case MessageCode.createGroup:
        return _messagesInteractor.sendCreateGroupResponse(response);
      case MessageCode.setShard:
        return _messagesInteractor.sendSetShardResponse(response);
      case MessageCode.getShard:
        return _messagesInteractor.sendGetShardResponse(response);
      case MessageCode.takeGroup:
        return _messagesInteractor.sendTakeGroupResponse(response);
    }
  }

  // TBD: refactor!
  void _onMessagesUpdates(final BoxEvent event) {
    if (event.deleted) {
      final key = event.key as String;
      _activeMessages.removeWhere((e) => e.aKey == key);
      _resolvedMessages.removeWhere((e) => e.aKey == key);
    } else {
      final message = event.value as MessageModel;
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
