import '/src/core/consts.dart';

import 'platform_service.dart';
import 'analytics_service.dart';
import 'network/network_service.dart';

class ServiceRoot {
  static Future<ServiceRoot> init() async {
    final rootService = ServiceRoot()
      ..analyticsService = await AnalyticsService.init(Envs.amplitudeKey)
      ..platformService = const PlatformService()
      ..networkService = NetworkService();
    GetIt.I.registerSingleton<ServiceRoot>(rootService);
    return rootService;
  }

  late final AnalyticsService analyticsService;
  late final PlatformService platformService;
  late final NetworkService networkService;
}
