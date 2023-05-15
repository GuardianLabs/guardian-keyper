import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

import '../domain/use_case/message_interactor.dart';

export 'package:provider/provider.dart';

class MessageHomePresenter extends ChangeNotifier {
  MessageHomePresenter() {
    // cache and sort messages
    for (final message in _messagesInteractor.messages) {
      if (message.peerId != _messagesInteractor.selfId) {
        message.isReceived
            ? _activeMessages.add(message)
            : _resolvedMessages.add(message);
      }
    }
    _sortActiveMessages();
    _sertResolvedMessages();
    _messagesInteractor.watch().listen(_onMessagesUpdates);
  }

  late final archivateMessage = _messagesInteractor.archivateMessage;

  List<MessageModel> get activeMessages => _activeMessages;
  List<MessageModel> get resolvedMessages => _resolvedMessages;

  // Private
  final _activeMessages = <MessageModel>[];
  final _resolvedMessages = <MessageModel>[];
  final _messagesInteractor = GetIt.I<MessageInteractor>();

  void _sortActiveMessages() =>
      _activeMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));

  void _sertResolvedMessages() =>
      _resolvedMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));

  void _onMessagesUpdates(final MessageEvent event) {
    if (event.isDeleted) {
      _activeMessages.removeWhere((e) => e.aKey == event.key);
      _resolvedMessages.removeWhere((e) => e.aKey == event.key);
    } else {
      final message = event.value as MessageModel;
      if (message.peerId == _messagesInteractor.selfId) return;
      if (message.isReceived) {
        final index = _activeMessages.indexOf(message);
        index < 0
            ? _activeMessages.add(message)
            : _activeMessages[index] = message;
        _sortActiveMessages();
      } else {
        final index = _resolvedMessages.indexOf(message);
        index < 0
            ? _resolvedMessages.add(message)
            : _resolvedMessages[index] = message;
        _sertResolvedMessages();
      }
    }
    notifyListeners();
  }
}
