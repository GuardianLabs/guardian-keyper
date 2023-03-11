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
const snackBarDuration = Duration(seconds: 2);
const qrCodeExpires = Duration(days: 1);

const maxSecretLength = 256;
const passCodeLength = 6;
