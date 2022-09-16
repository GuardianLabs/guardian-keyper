part of 'core_model.dart';

@immutable
abstract class EventBusEvent {}

@immutable
abstract class EventBusCommand {}

@immutable
class NewMessageProcessedEvent implements EventBusEvent {
  final MessageModel message;

  const NewMessageProcessedEvent({required this.message});
}
