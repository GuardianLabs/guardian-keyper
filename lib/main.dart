import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'src/core/app.dart';
import 'src/core/di_container.dart';
import 'src/core/theme/theme.dart';
import 'src/core/utils/init_os.dart';
import 'src/core/service/analytics_service.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) => options
      ..dsn = const String.fromEnvironment('SENTRY_URL')
      ..tracesSampleRate = 1.0,
    appRunner: () async {
      FlutterNativeSplash.preserve(
        widgetsBinding: await init(statusBarColor: clIndigo900),
      );
      runApp(
        App(
          diContainer: await initDIC(
            analyticsService: await AnalyticsService.init(
              const String.fromEnvironment('AMPLITUDE_KEY'),
            ),
          ),
        ),
      );
      FlutterNativeSplash.remove();
    },
  );
}
