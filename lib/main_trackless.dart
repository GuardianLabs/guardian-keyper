import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'init_os.dart';
import 'src/app.dart';
import 'src/core/theme/theme.dart';
import 'src/core/model/core_model.dart';
import 'src/core/utils/init_dependencies.dart';
import 'src/core/service/platform_service.dart';

Future<void> main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: await init(statusBarColor: clIndigo900),
  );
  runApp(App(
    diContainer: await initDependencies(
      globals: const Globals(
        bsAddressV4: String.fromEnvironment('BS_V4'),
        bsAddressV6: String.fromEnvironment('BS_V6'),
        bsPeerId: String.fromEnvironment('BS_ID'),
        bsPort: int.fromEnvironment('BS_PORT'),
      ),
      platformService: PlatformService(
        hasBiometrics: await PlatformService.checkIfHasBiometrics(),
      ),
    ),
  ));
  FlutterNativeSplash.remove();
}
