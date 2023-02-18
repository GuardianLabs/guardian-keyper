part of 'recovery_group_controller.dart';

class RecoveryGroupGuardianController extends RecoveryGroupControllerBase {
  MessageModel? _qrCode;

  RecoveryGroupGuardianController({
    required super.diContainer,
    required super.pages,
    super.currentPage,
  });

  MessageModel? get qrCode => _qrCode;

  set qrCode(MessageModel? qrCode) {
    if (_qrCode != qrCode) {
      _qrCode = qrCode;
      if (qrCode != null) {
        assignPeersAddresses(
          qrCode.peerId,
          qrCode.payload as PeerAddressList,
        );
        nextScreen();
      }
    }
  }
}
