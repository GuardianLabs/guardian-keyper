import 'dart:async';

import '/src/core/service/service_root.dart';
import '/src/core/repository/repository_root.dart';
import '/src/core/controller/page_controller_base.dart';
import '/src/guardian/guardian_controller.dart';

part 'recovery_group_controller_base.dart';
part 'recovery_group_secret_controller.dart';
part 'recovery_group_guardian_controller.dart';

typedef Callback = void Function(MessageModel message);
