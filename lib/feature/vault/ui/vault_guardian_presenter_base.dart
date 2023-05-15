import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:flutter/services.dart';

import 'package:guardian_keyper/domain/entity/_id/vault_id.dart';
import 'package:guardian_keyper/domain/entity/message_model.dart';

import '../domain/vault_interactor.dart';
import 'vault_presenter_base.dart';

abstract class VaultGuardianPresenterBase extends VaultPresenterBase {
  VaultGuardianPresenterBase({required super.pages});

  VaultId? get vaultId;

  MessageCode get messageCode;

  MessageModel? get qrCode => _qrCode;

  bool get canUseClipboard => _canUseClipboard;

  void checkClipboard() => Clipboard.hasStrings().then(
        (bool hasStrings) {
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

  void setCode(String? code) {
    if (code == null || _qrCode != null) return;
    final message = MessageModel.tryFromBase64(code);

    if (message == null || message.code != messageCode || message.isExpired) {
      throw const SetCodeFailException();
    }
    if (message.version > MessageModel.currentVersion) {
      throw const SetCodeVersionHighException();
    }
    if (message.version < MessageModel.currentVersion) {
      throw const SetCodeVersionLowException();
    }
    if (message.peerId == _vaultInteractor.selfId) {
      throw SetCodeDuplicateException(message);
    }
    if (vaultId != null &&
        _vaultInteractor
                .getVaultById(vaultId!)
                ?.guardians
                .containsKey(message.peerId) ==
            true) {
      throw SetCodeDuplicateException(message);
    }

    _qrCode = message;
    nextPage();
  }

  // Private
  final _vaultInteractor = GetIt.I<VaultInteractor>();

  bool _canUseClipboard = false;

  MessageModel? _qrCode;
}

class SetCodeFailException implements Exception {
  const SetCodeFailException();
}

class SetCodeDuplicateException implements Exception {
  const SetCodeDuplicateException(this.message);

  final MessageModel message;
}

class SetCodeVersionLowException implements Exception {
  const SetCodeVersionLowException();
}

class SetCodeVersionHighException implements Exception {
  const SetCodeVersionHighException();
}