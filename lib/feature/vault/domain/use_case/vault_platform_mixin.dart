import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/services/platform_service.dart';

mixin class VaultPlatformMixin {
  final _platformService = GetIt.I<PlatformService>();

  Future<bool> openMarket() => _platformService.openMarket();

  Future<void> wakelockEnable() => _platformService.wakelockEnable();

  Future<void> wakelockDisable() => _platformService.wakelockDisable();

  Future<bool> copyToClipboard(String text) =>
      _platformService.copyToClipboard(text);

  Future<bool> hasStringsInClipboard() =>
      _platformService.hasStringsInClipboard();

  Future<String?> getCodeFromClipboard() async {
    var code = await _platformService.copyFromClipboard();
    if (code != null) {
      code = code.trim();
      final whiteSpace = code.lastIndexOf('\n');
      code = whiteSpace == -1 ? code : code.substring(whiteSpace).trim();
    }
    return code;
  }
}
