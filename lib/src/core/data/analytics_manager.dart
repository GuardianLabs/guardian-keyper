import 'package:get_it/get_it.dart';
import 'package:amplitude_flutter/amplitude.dart';

import '../domain/entity/core_model.dart';

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
