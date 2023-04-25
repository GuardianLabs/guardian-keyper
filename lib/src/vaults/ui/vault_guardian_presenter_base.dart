part of 'vault_presenter_base.dart';

abstract class VaultGuardianPresenterBase extends VaultPresenterBase {
  MessageModel? _qrCode;

  VaultGuardianPresenterBase({required super.pages, super.currentPage});

  late final addGuardian = _vaultInteractor.addGuardian;

  late final logStartAddGuardian = _vaultInteractor.logStartAddGuardian;
  late final logFinishAddGuardian = _vaultInteractor.logFinishAddGuardian;

  MessageModel? get qrCode => _qrCode;

  set qrCode(MessageModel? value) {
    if (_qrCode != value) {
      _qrCode = value;
      if (_qrCode != null) nextPage();
    }
  }
}
