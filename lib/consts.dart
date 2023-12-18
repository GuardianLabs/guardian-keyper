const maxForwardsLimit = 3;
const maxStoredHeaders = 10;
const maxSecretLength = 256;
const passCodeLength = 6;
const shortKeyLength = 12;
const maxNameLength = 25;
const minNameLength = 3;
const defaultPort = 2022;

const pageChangeDuration = Duration(milliseconds: 250);
const retryNetworkTimeout = Duration(seconds: 3);
const keepalivePeriod = Duration(seconds: 10);
const snackBarDuration = Duration(seconds: 2);
const initTimeout = Duration(seconds: 5);

// Envs
const amplitudeKey = String.fromEnvironment('AMPLITUDE_KEY');
const urlPlayMarket = String.fromEnvironment('PLAY_MARKET');
const urlAppStore = String.fromEnvironment('APP_STORE');
const bsAddressV4 = String.fromEnvironment('BS_V4');
const bsAddressV6 = String.fromEnvironment('BS_V6');
const bsPeerId = String.fromEnvironment('BS_ID');
const bsPort = int.fromEnvironment('BS_PORT', defaultValue: defaultPort);

// Routes
const routeIntro = '/intro';
const routeSettings = '/settings';
const routeVaultShow = '/vault/show';
const routeVaultCreate = '/vault/create';
const routeVaultRestore = '/vault/restore';
const routeShardShow = '/vault/shard/show';
const routeVaultSecretAdd = '/vault/secret/add';
const routeVaultGuardianAdd = '/vault/guardian/add';
const routeVaultSecretRecovery = '/vault/secret/recovery';
