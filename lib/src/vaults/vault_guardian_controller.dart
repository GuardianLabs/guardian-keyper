part of 'vault_controller.dart';

class VaultGuardianController extends VaultControllerBase {
  MessageModel? _qrCode;

  VaultGuardianController({required super.pages, super.currentPage});

  MessageModel? get qrCode => _qrCode;

  set qrCode(MessageModel? value) {
    if (_qrCode != value) {
      _qrCode = value;
      if (_qrCode != null) nextScreen();
    }
  }
}
