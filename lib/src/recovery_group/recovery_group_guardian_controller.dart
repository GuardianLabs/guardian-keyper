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
    if (_qrCode == qrCode) return;
    _qrCode = qrCode;
    if (qrCode == null) return;
    for (final e in (qrCode.payload as PeerAddressList).addresses) {
      diContainer.networkService.addPeer(
        qrCode.peerId,
        e.address.rawAddress,
        e.port,
      );
      nextScreen();
    }
  }
}
