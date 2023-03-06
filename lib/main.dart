import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'src/core/app.dart';
import 'src/core/di_container.dart';
import 'src/core/service/analytics_service.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) => options
      ..dsn = const String.fromEnvironment('SENTRY_URL')
      ..tracesSampleRate = 1.0,
    appRunner: () async {
      await App.init();
      runApp(App(
        diContainer: DIContainer(
          analyticsService: await AnalyticsService.init(
            const String.fromEnvironment('AMPLITUDE_KEY'),
          ),
        ),
      ));
    },
  );
}
