const maxForwardsLimit = 3;
const maxStoredHeaders = 10;
const maxSecretLength = 256;
const passCodeLength = 6;
const shortKeyLength = 6;
const maxNameLength = 25;
const minNameLength = 3;
const toolbarHeight = 68.0;
const cornerRadius = 8.0;
const buttonSize = 48.0;

const keepalivePeriod = Duration(seconds: 10);
const retryNetworkTimeout = Duration(seconds: 3);
const pageChangeDuration = Duration(milliseconds: 250);
const snackBarDuration = Duration(seconds: 2);

// Envs
const bsPort = int.fromEnvironment('BS_PORT', defaultValue: 2022);
const amplitudeKey = String.fromEnvironment('AMPLITUDE_KEY');
const urlPlayMarket = String.fromEnvironment('PLAY_MARKET');
const urlAppStore = String.fromEnvironment('APP_STORE');
const bsAddressV4 = String.fromEnvironment('BS_V4');
const bsAddressV6 = String.fromEnvironment('BS_V6');
const bsPeerId = String.fromEnvironment('BS_ID');
const buildV3 = bool.fromEnvironment('BUILD_V3');
