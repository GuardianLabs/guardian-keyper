import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/services/analytics_service.dart';

mixin class VaultAnalyticsMixin {
  final _analyticsService = GetIt.I<AnalyticsService>();

  void logStartCreateVault() => _analyticsService.logStartCreateVault();
  void logFinishCreateVault() => _analyticsService.logFinishCreateVault();
  void logStartAddGuardian() => _analyticsService.logStartAddGuardian();
  void logFinishAddGuardian() => _analyticsService.logFinishAddGuardian();
  void logStartRestoreVault() => _analyticsService.logStartRestoreVault();
  void logFinishRestoreVault() => _analyticsService.logFinishRestoreVault();
  void logStartAddSecret() => _analyticsService.logStartAddSecret();
  void logFinishAddSecret() => _analyticsService.logFinishAddSecret();
  void logStartRestoreSecret() => _analyticsService.logStartRestoreSecret();
  void logFinishRestoreSecret() => _analyticsService.logFinishRestoreSecret();
}
