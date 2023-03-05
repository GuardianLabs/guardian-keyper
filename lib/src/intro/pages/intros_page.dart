import 'package:flutter_svg/flutter_svg.dart';

import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';

import '../intro_controller.dart';

class IntrosPage extends StatelessWidget {
  static final _pictures = [
    SvgPicture.asset('assets/images/intro_1.svg'),
    SvgPicture.asset('assets/images/intro_2.svg'),
    SvgPicture.asset('assets/images/intro_3.svg'),
    SvgPicture.asset('assets/images/intro_4.svg'),
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
    final controller = context.watch<IntroController>();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx < -5) {
          if (controller.introStep == _titles.length - 1) {
            controller.nextScreen();
          } else if (controller.introStep < _titles.length - 1) {
            controller.introStep++;
          }
        } else if (details.velocity.pixelsPerSecond.dx > 5 &&
            controller.introStep > 0) {
          controller.introStep--;
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
              padding: paddingBottom32,
              child: IntrosPage._pictures[controller.introStep],
            ),
            Padding(
              padding: paddingBottom12,
              child: Text(
                _titles[controller.introStep],
                style: textStylePoppins620.copyWith(fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: paddingBottom20,
              child: Text(
                _subtitles[controller.introStep],
                style: textStyleSourceSansPro416,
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
                  onPressed: controller.nextScreen,
                  child: Text('Skip', style: textStylePoppins616),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < _titles.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: DotColored(
                            color: i == controller.introStep
                                ? clBlue
                                : clIndigo600),
                      ),
                  ],
                ),
                TextButton(
                  onPressed: () => controller.introStep == _titles.length - 1
                      ? controller.nextScreen()
                      : controller.introStep++,
                  child: Text('Next', style: textStylePoppins616),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
