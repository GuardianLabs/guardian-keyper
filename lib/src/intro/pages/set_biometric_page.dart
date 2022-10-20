import 'package:flutter_svg/flutter_svg.dart';

import '/src/core/di_container.dart';
import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';

class SetBiometricPage extends StatelessWidget {
  const SetBiometricPage({super.key});

  @override
  Widget build(BuildContext context) => Padding(
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
                  onPressed: () {
                    context
                        .read<DIContainer>()
                        .boxSettings
                        .isBiometricsEnabled = false;
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                  child: const Text('No'),
                )),
                const SizedBox(width: 10),
                Expanded(
                    child: PrimaryButton(
                  onPressed: () {
                    context
                        .read<DIContainer>()
                        .boxSettings
                        .isBiometricsEnabled = true;
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                  text: 'Yes',
                )),
              ]),
            ),
          ],
        ),
      );
}
