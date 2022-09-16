import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../di_container.dart';

abstract class BaseController extends ChangeNotifier {
  final DIContainer diContainer;

  BaseController({required this.diContainer});
}
