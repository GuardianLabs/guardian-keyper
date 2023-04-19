const routeIntro = '/intro';
const routeSettings = '/settings';
const routeShowQrCode = '/show_qrcode';
const routeScanQrCode = '/scan_qrcode';
const routeVaultEdit = '/vault/edit';
const routeVaultCreate = '/vault/create';
const routeVaultRestore = '/vault/restore';
const routeVaultAddSecret = '/vault/add_secret';
const routeVaultAddGuardian = '/vault/add_guardian';
const routeVaultRecoverSecret = '/vault/recover_secret';

const pageChangeDuration = Duration(milliseconds: 250);
const retryNetworkTimeout = Duration(seconds: 3);
const keepalivePeriod = Duration(seconds: 10);
const snackBarDuration = Duration(seconds: 2);
const initTimeout = Duration(seconds: 5);
const qrCodeExpires = Duration(days: 1);

const defaultPort = 2022;
const maxForwardsLimit = 3;
const maxStoredHeaders = 10;
const maxSecretLength = 256;
const passCodeLength = 6;
const maxNameLength = 25;
const minNameLength = 3;

const smallScreenHeight = 600;
const mediumScreenHeight = 800;
const bigScreenHeight = 1200;
