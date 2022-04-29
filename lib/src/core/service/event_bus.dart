import 'package:event_bus/event_bus.dart' as event_bus;
import 'package:flutter/material.dart' show immutable;

class EventBus extends event_bus.EventBus {}

@immutable
class RecoveryGroupClearCommand {}

@immutable
class GuardianShardsClearCommand {}

@immutable
class GuardianPeersClearCommand {}

@immutable
class SettingsChangedEvent {
  final String deviceName;

  const SettingsChangedEvent({required this.deviceName});
}
