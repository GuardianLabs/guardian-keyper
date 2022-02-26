// ignore_for_file: unused_field

// import 'dart:typed_data';
// import 'package:p2plib/p2plib.dart' as p2p;

import '../core/service/kv_storage.dart';

// import 'guardian_model.dart';
// import 'service/keeper_handler.dart';

class GuardianService {
  GuardianService({
    required KVStorage storage,
    // required p2p.Router router,
  }) : _storage = storage;

  static const _guardianPath = 'guardian';

  final KVStorage _storage;
}
