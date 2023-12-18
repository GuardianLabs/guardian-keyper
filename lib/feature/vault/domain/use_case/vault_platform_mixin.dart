import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/services/platform_service.dart';

mixin class VaultPlatformMixin {
  final _platformService = GetIt.I<PlatformService>();

  Future<bool> openMarket() => _platformService.openMarket();

  Future<void> wakelockEnable() => _platformService.wakelockEnable();

  Future<void> wakelockDisable() => _platformService.wakelockDisable();
}
