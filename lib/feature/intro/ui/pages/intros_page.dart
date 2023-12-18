// ignore_for_file: no_adjacent_strings_in_list

import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';

import '../intro_presenter.dart';

class IntrosPage extends StatelessWidget {
  static const _pictures = [
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
    'Guardian Keyper is a secure way to store and recover secrets, such as seed'
        ' phrases. With Guardian Keyper, your Web3 assets are safe.',
    'Guardian Keyper splits a secret into a number of encrypted shards. Shards'
        ' are then stored on devices owned by “Guardians”, persons you trust.',
    'Each Shard is protected by state-of-the-art encryption algorithms and'
        ' can’t be reversed into a seed phrase without approval of Guardians.',
    'You can restore your seed phrase any time with the help of Guardians.'
        ' Even in case you’ve lost access to your device.',
  ];

  static final _slideCount = _pictures.length;

  const IntrosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = context.watch<IntroPresenter>();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx < -5) {
          presenter.nextSlide(_slideCount);
        } else if (details.velocity.pixelsPerSecond.dx > 5) {
          presenter.previousSlide();
        }
      },
      child: Padding(
        padding: paddingAll20,
        child: Column(
          children: [
            const Spacer(),
            // Slide
            Padding(
              padding: paddingB32,
              child: IntrosPage._pictures[presenter.introStep],
            ),
            Padding(
              padding: paddingB12,
              child: Text(
                _titles[presenter.introStep],
                style: stylePoppins620.copyWith(fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: paddingB20,
              child: Text(
                _subtitles[presenter.introStep],
                style: styleSourceSansPro416,
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
                  child: Text('Skip', style: stylePoppins616),
                ),
                // Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < _titles.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: DotColored(
                          color:
                              i == presenter.introStep ? clBlue : clIndigo700,
                        ),
                      ),
                  ],
                ),
                TextButton(
                  onPressed: () => presenter.nextSlide(_slideCount),
                  child: Text('Next', style: stylePoppins616),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
