const maxForwardsLimit = 3;
const maxStoredHeaders = 10;
const maxSecretLength = 256;
const passCodeLength = 6;
const maxNameLength = 25;
const minNameLength = 3;
const defaultPort = 2022;

const pageChangeDuration = Duration(milliseconds: 250);
const retryNetworkTimeout = Duration(seconds: 3);
const keepalivePeriod = Duration(seconds: 10);
const snackBarDuration = Duration(seconds: 2);
const initTimeout = Duration(seconds: 5);
const qrCodeExpires = Duration(days: 1);
