import 'dart:async';

abstract class StorageService {
  Future<T?> get<T extends Object>(final String key);

  Future<T> getOr<T extends Object>(final String key, final T defaultValue);

  Future<void> set<T extends Object>(final String key, final T? value);

  Future<void> delete(final String key);
}

class ValueFormatException extends FormatException {
  const ValueFormatException() : super('Unsupported value type');
}
