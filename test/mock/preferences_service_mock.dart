import 'package:guardian_keyper/data/services/preferences_service.dart';

class PreferencesServiceMock implements PreferencesService {
  @override
  late String pathAppDir;

  @override
  Future<T?> get<T extends Object>(PreferencesKeys key) {
    throw UnimplementedError();
  }

  @override
  Future<PreferencesService> init() {
    throw UnimplementedError();
  }

  @override
  String get pathDataDir => throw UnimplementedError();

  @override
  Future<void> set<T extends Object>(PreferencesKeys key, T value) {
    throw UnimplementedError();
  }
}
