import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/consts.dart';

export 'package:flutter/foundation.dart';

mixin NameHelperMixin on ChangeNotifier {
  String _name = '';

  String get name => _name;

  bool get isNameTooShort => _name.length < kMinNameLength;

  set name(String value) {
    // Value become less than minimum
    if (value.length < kMinNameLength && _name.length == kMinNameLength) {
      _name = value;
      return notifyListeners();
    }
    // Value reach minimum
    if (value.length >= kMinNameLength && _name.length < kMinNameLength) {
      _name = value;
      return notifyListeners();
    }
    _name = value;
  }
}
