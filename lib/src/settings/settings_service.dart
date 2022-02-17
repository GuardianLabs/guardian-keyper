import 'package:flutter/material.dart';

import '../core/service/kv_storage.dart';

class SettingsService {
  SettingsService(this._storage);

  final KVStorage _storage;

  // void init() async {
  //   if (!await _storage.containsKey(key: 'settings')) {}

  // }

  Future<ThemeMode> themeMode() async => ThemeMode.dark;

  Future<void> updateThemeMode(ThemeMode theme) async {
    if (!await _storage.containsKey(key: 'settings')) {}
  }
}
