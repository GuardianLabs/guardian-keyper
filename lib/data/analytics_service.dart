import 'package:amplitude_flutter/amplitude.dart';

import '../consts.dart';

typedef EventLogger = Future<void> Function(
  String eventType, {
  Map<String, dynamic>? eventProperties,
  bool? outOfSession,
});

class AnalyticsService {
  static Future<AnalyticsService> init() async {
    final amplitude = Amplitude.getInstance();
    if (amplitudeKey.isEmpty) return const AnalyticsService();
    await amplitude.init(amplitudeKey);
    await amplitude.trackingSessionEvents(true);
    // Enable COPPA privacy guard.
    // This is useful when you choose not to report sensitive user information.
    await amplitude.enableCoppaControl();
    return AnalyticsService(logEvent: amplitude.logEvent);
  }

  static Future<void> _logEvent(
    String eventType, {
    Map<String, dynamic>? eventProperties,
    bool? outOfSession,
  }) async {}

  final EventLogger logEvent;

  const AnalyticsService({this.logEvent = _logEvent});

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
