import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

export 'package:flutter_screen_lock/flutter_screen_lock.dart';

import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';
import '/src/core/theme/theme.dart';
import '/src/core/widgets/icon_of.dart';

const secretsConfig = SecretsConfig(
  secretConfig: SecretConfig(
    borderSize: 0,
    borderColor: Colors.transparent,
    disabledColor: Colors.white38,
    enabledColor: Colors.white,
  ),
);
final keyPadConfig = KeyPadConfig(
  buttonConfig: KeyPadButtonConfig(
    buttonStyle: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
    ),
  ),
  clearOnLongPressed: true,
);
const screenLockConfig = ScreenLockConfig(backgroundColor: clIndigo900);

class BiometricLogonButton extends StatefulWidget {
  final void Function() callback;

  const BiometricLogonButton({super.key, required this.callback});

  @override
  State<BiometricLogonButton> createState() => _BiometricLogonButtonState();
}

class _BiometricLogonButtonState extends State<BiometricLogonButton> {
  @override
  void initState() {
    super.initState();
    if (context.read<DIContainer>().boxSettings.isBiometricsEnabled) {
      _authenticate();
    }
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<Box<SettingsModel>>(
        valueListenable: context.read<DIContainer>().boxSettings.listenable(),
        builder: (_, boxSettings, __) => boxSettings.isBiometricsEnabled
            ? IconButton(
                iconSize: 48,
                icon: const IconOf.biometricLogon(
                  bgColor: Colors.transparent,
                  size: 48,
                ),
                onPressed: _authenticate,
              )
            : const Offstage(),
      );

  void _authenticate() async {
    final didAuthenticate =
        await context.read<DIContainer>().platformService.authenticate(
              localizedReason: 'Please authenticate to log into the app',
            );
    if (didAuthenticate && mounted) widget.callback();
  }
}
