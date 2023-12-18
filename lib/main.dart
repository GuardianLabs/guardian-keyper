import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app/app.dart';

Future<void> main() => SentryFlutter.init(
      (options) => options
        ..dsn = const String.fromEnvironment('SENTRY_URL')
        ..tracesSampleRate = 1.0,
      appRunner: () async => runApp(await App.init()),
    );
