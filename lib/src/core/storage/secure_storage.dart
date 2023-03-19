import 'dart:async';

enum Storages { settings }

abstract class SecureStorage {
  Future<T?> get<T extends Object>(final Object key);

  Future<T> getOr<T extends Object>(final Object key, final T defaultValue);

  Future<T?> set<T extends Object>(final Object key, final T? value);

  Future<Object> delete(final Object key);
}

class ValueFormatException extends FormatException {
  const ValueFormatException() : super('Unsupported value type');
}
