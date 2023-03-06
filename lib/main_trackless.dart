import 'package:flutter/material.dart';

import 'src/core/app.dart';
import 'src/core/di_container.dart';

Future<void> main() async {
  await App.init();
  runApp(App(diContainer: DIContainer()));
}
