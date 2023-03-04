part of 'core_model.dart';

@immutable
class Globals {
  final String storageName, bsPeerId, bsAddressV4, bsAddressV6;

  final int bsPort,
      maxNameLength,
      minNameLength,
      passCodeLength,
      maxSecretLength,
      maxForwardsLimit,
      maxStoredHeaders;

  final Duration pageChangeDuration,
      retryNetworkTimeout,
      keepalivePeriod,
      snackBarDuration,
      qrCodeExpires;

  const Globals({
    this.storageName = 'data',
    this.bsPeerId = const String.fromEnvironment('BS_ID'),
    this.bsAddressV4 = const String.fromEnvironment('BS_V4'),
    this.bsAddressV6 = const String.fromEnvironment('BS_V6'),
    this.bsPort = const int.fromEnvironment('BS_PORT'),
    this.maxNameLength = 25,
    this.minNameLength = 3,
    this.passCodeLength = 6,
    this.maxSecretLength = 256,
    this.maxForwardsLimit = 3,
    this.maxStoredHeaders = 10,
    this.pageChangeDuration = const Duration(milliseconds: 250),
    this.retryNetworkTimeout = const Duration(seconds: 3),
    this.keepalivePeriod = const Duration(seconds: 10),
    this.snackBarDuration = const Duration(seconds: 3),
    this.qrCodeExpires = const Duration(days: 1),
  });
}
