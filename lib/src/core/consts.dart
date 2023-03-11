const routeIntro = '/intro';
const routeHome = '/home';
const routeSettings = '/settings';
const routeGroupCreate = '/recovery_group/create';
const routeGroupEdit = '/recovery_group/edit';
const routeGroupAddGuardian = '/recovery_group/add_guardian';
const routeGroupAddSecret = '/recovery_group/add_secret';
const routeGroupRecoverSecret = '/recovery_group/recover_secret';
const routeGroupRestoreGroup = '/recovery_group/restore';

const pageChangeDuration = Duration(milliseconds: 250);
const retryNetworkTimeout = Duration(seconds: 3);
const keepalivePeriod = Duration(seconds: 10);
const snackBarDuration = Duration(seconds: 2);
const qrCodeExpires = Duration(days: 1);

const maxForwardsLimit = 3;
const maxStoredHeaders = 10;
const maxSecretLength = 256;
const passCodeLength = 6;

class Envs {
  static const amplitudeKey = String.fromEnvironment('AMPLITUDE_KEY');
  static const bsPeerId = String.fromEnvironment('BS_ID');
  static const bsAddressV4 = String.fromEnvironment('BS_V4');
  static const bsAddressV6 = String.fromEnvironment('BS_V6');
  static const bsPort = int.fromEnvironment('BS_PORT', defaultValue: 2022);
}
