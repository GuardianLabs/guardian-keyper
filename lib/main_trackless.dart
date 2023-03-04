import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'src/core/app.dart';
import 'src/core/di_container.dart';
import 'src/core/theme/theme.dart';
import 'src/core/utils/init_os.dart';

Future<void> main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: await init(statusBarColor: clIndigo900),
  );
  runApp(App(diContainer: await initDIC()));
  FlutterNativeSplash.remove();
}
