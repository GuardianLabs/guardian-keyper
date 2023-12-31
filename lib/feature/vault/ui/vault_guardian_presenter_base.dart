import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';

import 'vault_presenter_base.dart';

abstract base class VaultGuardianPresenterBase extends VaultPresenterBase {
  VaultGuardianPresenterBase({required super.pageCount});

  final _vaultInteractor = GetIt.I<VaultInteractor>();

  MessageModel? _qrCode;

  VaultId? get vaultId;

  MessageCode get messageCode;

  MessageModel? get qrCode => _qrCode;

  bool isNotValidMessage(MessageModel message, VaultId? vaultId) {
    if (isNotWaiting) return true;
    if (qrCode == null) return true;
    if (message.hasNoResponse) return true;
    if (message.code != messageCode) return true;
    if (message.peerId != qrCode!.peerId) return true;
    if (vaultId != null && message.vaultId != vaultId) return true;
    if (message.version != MessageModel.currentVersion) return true;
    return false;
  }

  void setCode(String? code) {
    if (code == null || _qrCode != null) return;
    if (code.isEmpty) throw const SetCodeEmptyException();

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
    late final hasPeer = _vaultInteractor
        .getVaultById(vaultId!)
        ?.guardians
        .containsKey(message.peerId);
    if (vaultId != null && (hasPeer ?? false)) {
      throw SetCodeDuplicateException(message);
    }

    _qrCode = message;
    nextPage();
  }
}

class SetCodeEmptyException implements Exception {
  const SetCodeEmptyException();
}

class SetCodeFailException implements Exception {
  const SetCodeFailException();
}

class SetCodeVersionLowException implements Exception {
  const SetCodeVersionLowException();
}

class SetCodeVersionHighException implements Exception {
  const SetCodeVersionHighException();
}

class SetCodeDuplicateException implements Exception {
  const SetCodeDuplicateException(this.message);

  final MessageModel message;
}
