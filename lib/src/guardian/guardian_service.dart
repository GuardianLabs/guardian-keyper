// ignore_for_file: unused_field

// import 'dart:typed_data';
// import 'package:p2plib/p2plib.dart';

// import 'guardian_model.dart';
import '../core/service/kv_storage.dart';

class GuardianService {
  const GuardianService({required KVStorage storage}) : _storage = storage;

  static const _guardianPath = 'guardian';

  final KVStorage _storage;
}
