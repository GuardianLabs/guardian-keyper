import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/services/analytics_service.dart';

mixin class VaultAnalyticsMixin {
  late final logStartCreateVault = _analyticsService.logStartCreateVault;
  late final logFinishCreateVault = _analyticsService.logFinishCreateVault;
  late final logStartAddGuardian = _analyticsService.logStartAddGuardian;
  late final logFinishAddGuardian = _analyticsService.logFinishAddGuardian;
  late final logStartRestoreVault = _analyticsService.logStartRestoreVault;
  late final logFinishRestoreVault = _analyticsService.logFinishRestoreVault;
  late final logStartAddSecret = _analyticsService.logStartAddSecret;
  late final logFinishAddSecret = _analyticsService.logFinishAddSecret;
  late final logStartRestoreSecret = _analyticsService.logStartRestoreSecret;
  late final logFinishRestoreSecret = _analyticsService.logFinishRestoreSecret;

  final _analyticsService = GetIt.I<AnalyticsService>();
}
