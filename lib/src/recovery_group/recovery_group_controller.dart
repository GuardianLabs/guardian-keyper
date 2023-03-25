import 'dart:async';

import '/src/core/service/service_root.dart';
import '/src/core/data/repository_root.dart';
import '/src/core/ui/page_presenter_base.dart';

part 'recovery_group_controller_base.dart';
part 'recovery_group_secret_controller.dart';
part 'recovery_group_guardian_controller.dart';

typedef Callback = void Function(MessageModel message);
