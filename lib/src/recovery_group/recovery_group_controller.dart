import 'dart:async';

import '../core/service/service_root.dart';
import '../core/repository/repository_root.dart';
import '/src/core/controller/page_controller_base.dart';
import '/src/guardian/guardian_controller.dart';
import '/src/auth/auth_case.dart';

part 'recovery_group_controller_base.dart';
part 'recovery_group_secret_controller.dart';
part 'recovery_group_guardian_controller.dart';

typedef Callback = void Function(MessageModel message);
