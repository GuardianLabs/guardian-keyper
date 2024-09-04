import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';

import '../intro_presenter.dart';

class SetBiometricPage extends StatelessWidget {
  const SetBiometricPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: paddingAllDefault,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SvgPicture(AssetBytesLoader(
            'assets/images/intro_biometrics.svg.vec',
          )),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Text(
              'Enable biometric authentication?',
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: paddingT12,
            child: Text(
              'Use biometry for faster, easier and secure access to the app.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: paddingTDefault,
            child: Row(children: [
              Expanded(
                child: FilledButton(
                  onPressed: () async {
                    await context
                        .read<IntroPresenter>()
                        .setIsBiometricsEnabled(false);
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  child: const Text('No'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () async {
                    await context
                        .read<IntroPresenter>()
                        .setIsBiometricsEnabled(true);
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  child: const Text('Yes'),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
