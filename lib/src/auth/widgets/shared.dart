import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:vibration/vibration.dart';

import '/src/core/widgets/common.dart';

typedef OnConfirmed = Future<void> Function(String passCode);

const keyPadConfig = KeyPadConfig(clearOnLongPressed: true);

const cancelButton = Text(
  'Cancel',
  maxLines: 1,
  softWrap: false,
  textAlign: TextAlign.center,
  overflow: TextOverflow.visible,
);

const secretsConfig = SecretsConfig(
  secretConfig: SecretConfig(
    borderSize: 0,
    borderColor: Colors.transparent,
    disabledColor: Colors.white38,
    enabledColor: Colors.white,
  ),
);

final screenLockConfig = ScreenLockConfig(
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

EdgeInsets getPadding(final double screenHeight) =>
    (screenHeight > 600 ? paddingV32 : paddingV12) + paddingH20;

Future<bool> vibrate([int duration = 500]) async {
  final hasVibrator = await Vibration.hasVibrator() ?? false;
  if (hasVibrator) await Vibration.vibrate(duration: duration);
  return hasVibrator;
}
