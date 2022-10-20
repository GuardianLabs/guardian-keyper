class AnalyticsService {
  static Future<void> _logEvent(
    eventType, {
    eventProperties,
    outOfSession,
  }) async {}

  final Future<void> Function(
    String eventType, {
    Map<String, dynamic>? eventProperties,
    bool? outOfSession,
  }) logEvent;

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
