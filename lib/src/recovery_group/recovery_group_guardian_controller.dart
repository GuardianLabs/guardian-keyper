part of 'recovery_group_controller.dart';

class RecoveryGroupGuardianController extends RecoveryGroupControllerBase {
  MessageModel? _qrCode;

  RecoveryGroupGuardianController({
    required super.diContainer,
    required super.pages,
    super.currentPage,
  });

  MessageModel? get qrCode => _qrCode;

  set qrCode(MessageModel? value) {
    if (_qrCode != value) {
      _qrCode = value;
      if (_qrCode != null) nextScreen();
    }
  }
}
