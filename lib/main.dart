import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:guardian_keyper/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SentryFlutter.init(
    (options) => options
      ..dsn = const String.fromEnvironment('SENTRY_URL')
      ..ignoreErrors = [
        'SocketException',
        'AuthenticationNotFoundException',
      ]
      ..tracesSampleRate = 1.0,
    appRunner: () => runApp(const App()),
  );
}
