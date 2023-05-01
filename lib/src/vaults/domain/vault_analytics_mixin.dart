import 'package:get_it/get_it.dart';
import 'package:guardian_keyper/src/core/data/analytics_manager.dart';

mixin VaultAnalyticsMixin {
  Future<void> logStartCreateVault() =>
      _analyticsManager.logEvent(eventStartCreateVault);

  Future<void> logFinishCreateVault() =>
      _analyticsManager.logEvent(eventFinishCreateVault);

  Future<void> logStartAddGuardian() =>
      _analyticsManager.logEvent(eventStartAddGuardian);

  Future<void> logFinishAddGuardian() =>
      _analyticsManager.logEvent(eventFinishAddGuardian);

  Future<void> logStartRestoreVault() =>
      _analyticsManager.logEvent(eventStartRestoreVault);

  Future<void> logFinishRestoreVault() =>
      _analyticsManager.logEvent(eventFinishRestoreVault);

  Future<void> logStartAddSecret() =>
      _analyticsManager.logEvent(eventStartAddSecret);

  Future<void> logFinishAddSecret() =>
      _analyticsManager.logEvent(eventFinishAddSecret);

  Future<void> logStartRestoreSecret() =>
      _analyticsManager.logEvent(eventStartRestoreSecret);

  Future<void> logFinishRestoreSecret() =>
      _analyticsManager.logEvent(eventFinishRestoreSecret);

  final _analyticsManager = GetIt.I<AnalyticsManager>();
}
