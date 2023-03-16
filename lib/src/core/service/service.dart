import '/src/core/consts.dart';

import 'platform_service.dart';
import 'analytics_service.dart';
import 'network/network_service.dart';

export 'platform_service.dart';
export 'analytics_service.dart';
export 'network/network_service.dart';
export 'storage/flutter_secure_storage_service.dart';

Future<void> registerServices() async {
  GetIt.I.registerSingleton<PlatformService>(const PlatformService());
  GetIt.I.registerSingleton<AnalyticsService>(
    await AnalyticsService.init(Envs.amplitudeKey),
  );
  GetIt.I.registerSingleton<NetworkService>(NetworkService());
}
