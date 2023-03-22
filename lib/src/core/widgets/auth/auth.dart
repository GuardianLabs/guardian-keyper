import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import '/src/core/consts.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

part 'ask_pass_code.dart';
part 'demand_pass_code.dart';
part 'create_pass_code.dart';
part 'change_pass_code.dart';

typedef OnConfirmed = Future<void> Function(String passCode);

typedef LocalAuthenticate = Future<bool> Function({
  bool biometricOnly,
  String localizedReason,
});

const _keyPadConfig = KeyPadConfig(clearOnLongPressed: true);

const _cancelButton = Text(
  'Cancel',
  maxLines: 1,
  softWrap: false,
  textAlign: TextAlign.center,
  overflow: TextOverflow.visible,
);

const _resetButton = Text(
  'Reset',
  maxLines: 1,
  softWrap: false,
  textAlign: TextAlign.center,
  overflow: TextOverflow.visible,
);

const _currentPassCodeTitle = Text('Please enter your current passcode');

const _biometricsIcon = IconOf.biometricLogon(
  bgColor: Colors.transparent,
  size: 48,
);

const _secretsConfig = SecretsConfig(
  secretConfig: SecretConfig(
    borderSize: 0,
    borderColor: Colors.transparent,
    disabledColor: Colors.white38,
    enabledColor: Colors.white,
  ),
);

final _screenLockConfig = ScreenLockConfig(
  backgroundColor: clIndigo900,
  textStyle: textStylePoppins616,
  titleTextStyle: textStylePoppins620,
  buttonStyle: ButtonStyle(
    backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
    foregroundColor: const MaterialStatePropertyAll(Colors.white),
    shape: const MaterialStatePropertyAll(CircleBorder()),
    textStyle: MaterialStatePropertyAll(
      textStylePoppins616.copyWith(overflow: TextOverflow.visible),
    ),
  ),
);

final _wrongPassCodeSnackbar = buildSnackBar(
  text: 'Wrong passcode!',
  duration: snackBarDuration,
  isFloating: true,
  isError: true,
);

EdgeInsets _getPadding(final BuildContext context) =>
    (MediaQuery.of(context).size.height > smallScreenHeight
        ? paddingV32
        : paddingV12) +
    paddingH20;
