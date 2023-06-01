import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/services/platform_service.dart';

mixin class VaultPlatformMixin {
  late final openMarket = _platformService.openMarket;
  late final wakelockEnable = _platformService.wakelockEnable;
  late final wakelockDisable = _platformService.wakelockDisable;
  late final copyToClipboard = _platformService.copyToClipboard;
  late final hasStringsInClipboard = _platformService.hasStringsInClipboard;

  final _platformService = GetIt.I<PlatformService>();

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
