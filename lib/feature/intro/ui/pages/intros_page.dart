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

  final _titles = const [
    'Welcome to Guardian Keyper',
    'Decentralized',
    'Secure',
    'Never forget again',
  ];
  final _subtitles = const [
    'Guardian Keyper is a secure way to store and recover secrets, such as seed'
        ' phrases. With Guardian Keyper, your Web3 assets are safe.',
    'Guardian Keyper splits a secret into a number of encrypted shards. Shards'
        ' are then stored on devices owned by “Guardians”, persons you trust.',
    'Each Shard is protected by state-of-the-art encryption algorithms and'
        ' can’t be reversed into a seed phrase without approval of Guardians.',
    'You can restore your seed phrase any time with the help of Guardians.'
        ' Even in case you’ve lost access to your device.',
  ];

  const IntrosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = context.watch<IntroPresenter>();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx < -5) {
          if (presenter.introStep == _titles.length - 1) {
            presenter.nextPage();
          } else if (presenter.introStep < _titles.length - 1) {
            presenter.introStep++;
          }
        } else if (details.velocity.pixelsPerSecond.dx > 5 &&
            presenter.introStep > 0) {
          presenter.introStep--;
        }
      },
      child: Padding(
        padding: paddingAll20,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(),
            ),
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
            Expanded(
              flex: 2,
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: presenter.nextPage,
                  child: Text('Skip', style: stylePoppins616),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < _titles.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: DotColored(
                            color: i == presenter.introStep
                                ? clBlue
                                : clIndigo600),
                      ),
                  ],
                ),
                TextButton(
                  onPressed: () => presenter.introStep == _titles.length - 1
                      ? presenter.nextPage()
                      : presenter.introStep++,
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
