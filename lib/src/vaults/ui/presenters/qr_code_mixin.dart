import 'dart:async';
import 'package:flutter/services.dart';

import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

import 'vault_presenter_base.dart';

mixin QrCodeMixin on VaultPresenterBase {
  MessageModel? get qrCode => _qrCode;

  bool get canUseClipboard => _canUseClipboard;

  MessageCode get messageCode;

  void checkClipboard() => Clipboard.hasStrings().then(
        (final bool hasStrings) {
          _canUseClipboard = hasStrings;
          notifyListeners();
        },
      );

  Future<String?> getCodeFromClipboard() async {
    _canUseClipboard = false;
    notifyListeners();
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    var code = clipboardData?.text;
    if (code != null) {
      code = code.trim();
      final whiteSpace = code.lastIndexOf('\n');
      code = whiteSpace == -1 ? code : code.substring(whiteSpace).trim();
    }
    return code;
  }

  void parseCode(final String? code, final void Function() onError) {
    if (_qrCode != null) return;
    final message = MessageModel.tryFromBase64(code);
    if (message?.code == messageCode) {
      _qrCode = message;
      nextPage();
    } else {
      onError();
    }
  }

  bool _canUseClipboard = false;

  MessageModel? _qrCode;
}
