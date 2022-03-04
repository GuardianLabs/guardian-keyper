// ignore_for_file: unused_field

import 'package:flutter/widgets.dart';
import 'package:p2plib/p2plib.dart' as p2p;

import '../core/utils.dart';
import '../core/service/event_bus.dart';

import 'recovery_group_model.dart';
import 'recovery_group_service.dart';

class RecoveryGroupController with ChangeNotifier {
  RecoveryGroupController({
    required RecoveryGroupService recoveryGroupService,
    required EventBus eventBus,
    required p2p.Router p2pRouter,
  })  : _recoveryGroupService = recoveryGroupService,
        _eventBus = eventBus,
        _p2pRouter = p2pRouter {
    eventBus.on<RecoveryGroupClearCommand>().listen((event) => clear());
  }

  final RecoveryGroupService _recoveryGroupService;
  final p2p.Router _p2pRouter;
  final EventBus _eventBus;
  late Map<String, RecoveryGroupModel> _groups;

  Map<String, RecoveryGroupModel> get groups => _groups;
  String get qrCode => getRandomString(100);

  Future<void> load() async {
    _groups = await _recoveryGroupService.getGroups();
  }

  Future<void> _save() async {
    await _recoveryGroupService.setGroups(_groups);
    notifyListeners();
  }

  Future<void> clear() async {
    await _recoveryGroupService.clearGroups();
    _groups.clear();
    notifyListeners();
  }

  Future<void> addGroup(RecoveryGroupModel group) async {
    if (_groups.containsKey(group.name)) {
      throw RecoveryGroupAlreadyExists();
    }
    _groups[group.name] = group;
    await _save();
  }

  Future<void> addGuardian(
    String groupName,
    RecoveryGroupGuardianModel guardian,
  ) async {
    if (!_groups.containsKey(groupName)) {
      throw RecoveryGroupDoesNotExist();
    }
    final group = _groups[groupName]!;
    _groups[groupName] = group.addGuardian(guardian);
    await _save();
  }

  Future<void> addSecret(
    String groupName,
    RecoveryGroupSecretModel secret,
  ) async {
    // TBD: do all checks
    // if (_groups.containsKey(groupName)) {
    //   throw RecoveryGroupAlreadyExists();
    // }
    final group = _groups[groupName]!;
    final updatedgroup = group.addSecret(secret);
    _groups[groupName] = updatedgroup;
    await _save();
  }
}

class RecoveryGroupAlreadyExists implements Exception {
  static const description = 'Group with given name already exists!';
}

class RecoveryGroupDoesNotExist implements Exception {
  static const description = 'Group with given name does not exist!';
}
