import 'package:flutter_svg/flutter_svg.dart';

import '/src/core/consts.dart';
import '/src/core/widgets/common.dart';
import '../../settings/settings_controller.dart';

class SetBiometricPage extends StatelessWidget {
  const SetBiometricPage({super.key});

  @override
  Widget build(final BuildContext context) => Padding(
        padding: paddingAll20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/intro_biometrics.svg'),
            Padding(
              padding: paddingTop32,
              child: Text(
                'Enable biometric authentication?',
                style: textStylePoppins620.copyWith(fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: paddingTop12,
              child: Text(
                'Use biometry for faster, easier and secure access to the app.',
                style: textStyleSourceSansPro416,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: paddingTop20,
              child: Row(children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await GetIt.I<SettingsController>()
                          .setIsBiometricsEnabled(false);
                      if (context.mounted) {
                        Navigator.of(context).pushReplacementNamed(routeHome);
                      }
                    },
                    child: const Text('No'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryButton(
                    onPressed: () async {
                      await GetIt.I<SettingsController>()
                          .setIsBiometricsEnabled(true);
                      if (context.mounted) {
                        Navigator.of(context).pushReplacementNamed(routeHome);
                      }
                    },
                    text: 'Yes',
                  ),
                ),
              ]),
            ),
          ],
        ),
      );
}
