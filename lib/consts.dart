const kMaxForwardsLimit = 3;
const kMaxStoredHeaders = 10;
const kMaxSecretLength = 256;
const kPassCodeLength = 6;
const kShortKeyLength = 6;
const kMaxNameLength = 25;
const kMinNameLength = 3;
const kCornerRadius = 8.0;
const kButtonSize = 48.0;

const kKeepalivePeriod = Duration(seconds: 10);
const kRetryNetworkTimeout = Duration(seconds: 3);
const kPageChangeDuration = Duration(milliseconds: 250);
const kSnackBarDuration = Duration(seconds: 2);

// Envs
const bsPort = int.fromEnvironment('BS_PORT', defaultValue: 2022);
const amplitudeKey = String.fromEnvironment('AMPLITUDE_KEY');
const urlPlayMarket = String.fromEnvironment('PLAY_MARKET');
const urlAppStore = String.fromEnvironment('APP_STORE');
const bsName = String.fromEnvironment('BS_NAME');
const bsPeerId = String.fromEnvironment('BS_ID');
