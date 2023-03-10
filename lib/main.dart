import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'src/core/app.dart';

Future<void> main() async {
  const sentryUrl = String.fromEnvironment('SENTRY_URL');
  sentryUrl.isEmpty
      ? await appRunner()
      : await SentryFlutter.init(
          (options) => options
            ..dsn = sentryUrl
            ..tracesSampleRate = 1.0,
          appRunner: appRunner,
        );
}

Future<void> appRunner() async {
  await App.init();
  runApp(const App());
}
