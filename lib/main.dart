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
  // ACHTUNG! Due to a quirk in String.fromEnvironment:
  // "is only guaranteed to work when invoked as const", so it MUST have
  // defaultValue defined - otherwise, running the app in AndroidStudio
  // with environment variables set through --dart-define doesn't work.
  const sentryUrl =
      kDebugMode ? '' : String.fromEnvironment('SENTRY_URL', defaultValue: "");
  const bsAddressV4 = bool.hasEnvironment("BS_V4")
      ? String.fromEnvironment("BS_V4", defaultValue: "")
      : null;
  const bsAddressV6 = bool.hasEnvironment("BS_V6")
      ? String.fromEnvironment("BS_V6", defaultValue: "")
      : null;
  await SentryFlutter.init(
    (options) => options
      ..dsn = sentryUrl
      ..tracesSampleRate = 1.0,
    appRunner: () async {
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      runApp(App(
          diContainer: await DIContainer.bootstrap(
        globals: const GlobalsModel(
          bsAddressV4: bsAddressV4,
          bsAddressV6: bsAddressV6,
        ),
        platformService: await PlatformService.bootstrap(),
      )));
      FlutterNativeSplash.remove();
    },
  );
}
