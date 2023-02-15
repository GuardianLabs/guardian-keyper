import 'package:amplitude_flutter/amplitude.dart';

typedef EventLogger = Future<void> Function(
  String eventType, {
  Map<String, dynamic>? eventProperties,
  bool? outOfSession,
});

class AnalyticsService {
  static Future<AnalyticsService> init(final String apiKey) async {
    final amplitude = Amplitude.getInstance();
    await amplitude.init(apiKey);
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
}

const eventStartCreateVault = 'Start CreateVault';
const eventFinishCreateVault = 'Finish CreateVault';

const eventStartRestoreVault = 'Start RestoreVault';
const eventFinishRestoreVault = 'Finish RestoreVault';

const eventStartAddGuardian = 'Start AddGuardian';
const eventFinishAddGuardian = 'Finish AddGuardian';

const eventStartAddSecret = 'Start AddSecret';
const eventFinishAddSecret = 'Finish AddSecret';

const eventStartRestoreSecret = 'Start RestoreSecret';
const eventFinishRestoreSecret = 'Finish RestoreSecret';
