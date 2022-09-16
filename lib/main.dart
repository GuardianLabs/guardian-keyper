import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'src/app.dart';
import 'src/core/theme_data.dart';
import 'src/core/di_container.dart';
import 'src/core/model/core_model.dart';
import 'src/core/service/platform_service.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: clIndigo900,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
  ));
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  await SentryFlutter.init(
    (options) => options
      ..dsn = kDebugMode
          ? ''
          : 'https://3d977ba61e4c49dfb382705f89cbf048@o1289215.ingest.sentry.io/6507290'
      ..tracesSampleRate = 1.0,
    appRunner: () async {
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      runApp(App(
          diContainer: await DIContainer.bootstrap(
        globals: const GlobalsModel(
          bsAddressV4: '198.199.126.92',
          bsAddressV6: '2a03:b0c0:0:1010::43:3001',
        ),
        platformService: await PlatformService.bootstrap(),
      )));
      FlutterNativeSplash.remove();
    },
  );
}
