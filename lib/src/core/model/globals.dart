part of 'core_model.dart';

@immutable
class Globals {
  final String bsPeerId, bsAddressV4, bsAddressV6, amplitudeKey;

  final int bsPort, maxForwardsLimit, maxStoredHeaders;

  final Duration retryNetworkTimeout, keepalivePeriod;

  const Globals({
    this.amplitudeKey = const String.fromEnvironment('AMPLITUDE_KEY'),
    this.bsPeerId = const String.fromEnvironment('BS_ID'),
    this.bsAddressV4 = const String.fromEnvironment('BS_V4'),
    this.bsAddressV6 = const String.fromEnvironment('BS_V6'),
    this.bsPort = const int.fromEnvironment('BS_PORT'),
    this.maxForwardsLimit = 3,
    this.maxStoredHeaders = 10,
    this.retryNetworkTimeout = const Duration(seconds: 3),
    this.keepalivePeriod = const Duration(seconds: 10),
  });
}
