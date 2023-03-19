import '/src/core/consts.dart';

import 'platform_service.dart';
import 'analytics_service.dart';
import 'network/network_service.dart';

class ServiceRoot {
  static Future<ServiceRoot> bootstrap() async => ServiceRoot()
    ..analyticsService = await AnalyticsService.bootstrap(Envs.amplitudeKey)
    ..platformService = const PlatformService()
    ..networkService = NetworkService();

  late final AnalyticsService analyticsService;
  late final PlatformService platformService;
  late final NetworkService networkService;
}
