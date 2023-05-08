import 'package:get_it/get_it.dart';
import 'package:amplitude_flutter/amplitude.dart';

import '../domain/entity/env.dart';

typedef EventLogger = Future<void> Function(
  String eventType, {
  Map<String, dynamic>? eventProperties,
  bool? outOfSession,
});

class AnalyticsManager {
  static Future<AnalyticsManager> init() async {
    final amplitude = Amplitude.getInstance();
    final apiKey = GetIt.I<Env>().amplitudeKey;
    if (apiKey.isEmpty) return const AnalyticsManager();
    await amplitude.init(apiKey);
    await amplitude.trackingSessionEvents(true);
    // Enable COPPA privacy guard.
    // This is useful when you choose not to report sensitive user information.
    await amplitude.enableCoppaControl();
    return AnalyticsManager(logEvent: amplitude.logEvent);
  }

  static Future<void> _logEvent(
    String eventType, {
    Map<String, dynamic>? eventProperties,
    bool? outOfSession,
  }) async {}

  final EventLogger logEvent;

  const AnalyticsManager({this.logEvent = _logEvent});

  Future<void> logStartCreateVault() => logEvent('Start CreateVault');
  Future<void> logFinishCreateVault() => logEvent('Finish CreateVault');

  Future<void> logStartRestoreVault() => logEvent('Start RestoreVault');
  Future<void> logFinishRestoreVault() => logEvent('Finish RestoreVault');

  Future<void> logStartAddGuardian() => logEvent('Start AddGuardian');
  Future<void> logFinishAddGuardian() => logEvent('Finish AddGuardian');

  Future<void> logStartAddSecret() => logEvent('Start AddSecret');
  Future<void> logFinishAddSecret() => logEvent('Finish AddSecret');

  Future<void> logStartRestoreSecret() => logEvent('Start RestoreSecret');
  Future<void> logFinishRestoreSecret() => logEvent('Finish RestoreSecret');
}
