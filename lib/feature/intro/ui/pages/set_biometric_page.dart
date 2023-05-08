import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';

import '../intro_presenter.dart';

class SetBiometricPage extends StatelessWidget {
  const SetBiometricPage({super.key});

  @override
  Widget build(final BuildContext context) => Padding(
        padding: paddingAll20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SvgPicture(AssetBytesLoader(
              'assets/images/intro_biometrics.svg.vec',
            )),
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
                      await context
                          .read<IntroPresenter>()
                          .setIsBiometricsEnabled(false);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    child: const Text('No'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryButton(
                    onPressed: () async {
                      await context
                          .read<IntroPresenter>()
                          .setIsBiometricsEnabled(true);
                      if (context.mounted) Navigator.of(context).pop();
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
