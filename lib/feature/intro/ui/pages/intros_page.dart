// ignore_for_file: no_adjacent_strings_in_list

import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';

import '../intro_presenter.dart';

class IntrosPage extends StatelessWidget {
  static const slides = [
    SvgPicture(AssetBytesLoader('assets/images/intro_1.svg.vec')),
    SvgPicture(AssetBytesLoader('assets/images/intro_2.svg.vec')),
    SvgPicture(AssetBytesLoader('assets/images/intro_3.svg.vec')),
    SvgPicture(AssetBytesLoader('assets/images/intro_4.svg.vec')),
  ];

  static const _titles = [
    'Welcome to Guardian Keyper',
    'Decentralized',
    'Secure',
    'Never forget again',
  ];

  static const _subtitles = [
    'Guardian Keyper is a secure solution for storing and recovering your secrets, '
        'such as seed phrases. With Guardian Keyper, your assets remain safe.',
    'Guardian Keyper splits your secret into several encrypted shards, which '
        'are then stored on devices owned by Guardians – your trusted individuals.',
    'Each shard is protected by state-of-the-art encryption algorithms and '
        'cannot be reconstructed into a seed phrase without the approval of your Guardians.',
    'You can restore your seed phrase anytime with the assistance of your Guardians, '
        'even if you lose access to your device.',
  ];

  const IntrosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = context.watch<IntroPresenter>();
    final theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx < -5) {
          presenter.nextSlide();
        } else if (details.velocity.pixelsPerSecond.dx > 5) {
          presenter.previousSlide();
        }
      },
      child: Padding(
        padding: paddingAllDefault,
        child: Column(
          children: [
            const Spacer(),
            // Slide
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: IntrosPage.slides[presenter.introStep],
            ),
            Padding(
              padding: paddingB12,
              child: Text(
                _titles[presenter.introStep],
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: paddingBDefault,
              child: Text(
                _subtitles[presenter.introStep],
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(flex: 2),
            // Control bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: presenter.nextPage,
                  child: Text(
                    'Skip',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                // Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < _titles.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: i == presenter.introStep
                                ? theme.colorScheme.onSecondary
                                : theme.colorScheme.secondary,
                            shape: BoxShape.circle,
                          ),
                          height: 8,
                          width: 8,
                        ),
                      ),
                  ],
                ),
                TextButton(
                  onPressed: presenter.nextSlide,
                  child: Text(
                    'Next',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
