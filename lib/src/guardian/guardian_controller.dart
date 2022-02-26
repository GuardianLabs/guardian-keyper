// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:p2plib/p2plib.dart' as p2p;

import '../core/service/event_bus.dart';
// import 'guardian_model.dart';
import 'guardian_service.dart';

class GuardianController with ChangeNotifier {
  GuardianController({
    required GuardianService guardianService,
    required EventBus eventBus,
    required p2p.Router p2pRouter,
  })  : _guardianService = guardianService,
        _eventBus = eventBus,
        _p2pRouter = p2pRouter;

  final GuardianService _guardianService;
  final EventBus _eventBus;
  final p2p.Router _p2pRouter; // Is it really needed?

  Future<void> load() async {
    notifyListeners();
  }

  // void clearRecoveryGroups() => _eventBus.fire(RecoveryGroupClearEvent());
}
