import 'package:guardian_keyper/app/consts.dart';

class Env {
  const Env({
    this.amplitudeKey = const String.fromEnvironment('AMPLITUDE_KEY'),
    this.urlPlayMarket = const String.fromEnvironment('PLAY_MARKET'),
    this.urlAppStore = const String.fromEnvironment('APP_STORE'),
    this.bsAddressV4 = const String.fromEnvironment('BS_V4'),
    this.bsAddressV6 = const String.fromEnvironment('BS_V6'),
    this.bsPeerId = const String.fromEnvironment('BS_ID'),
    this.bsPort = const int.fromEnvironment(
      'BS_PORT',
      defaultValue: defaultPort,
    ),
  });

  final int bsPort;
  final String bsPeerId,
      bsAddressV4,
      bsAddressV6,
      amplitudeKey,
      urlPlayMarket,
      urlAppStore;
}
