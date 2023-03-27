part of 'vault_presenter.dart';

class VaultGuardianPresenter extends VaultPresenterBase {
  MessageModel? _qrCode;

  VaultGuardianPresenter({required super.pages, super.currentPage});

  MessageModel? get qrCode => _qrCode;

  set qrCode(MessageModel? value) {
    if (_qrCode != value) {
      _qrCode = value;
      if (_qrCode != null) nextScreen();
    }
  }
}
