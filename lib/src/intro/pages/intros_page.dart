import 'package:flutter_svg/flutter_svg.dart';

import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';

import '../intro_controller.dart';

class IntrosPage extends StatefulWidget {
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
  static final _pictures = [
    SvgPicture.asset('assets/images/intro_1.svg'),
    SvgPicture.asset('assets/images/intro_2.svg'),
    SvgPicture.asset('assets/images/intro_3.svg'),
    SvgPicture.asset('assets/images/intro_4.svg'),
  ];

  const IntrosPage({super.key});

  @override
  State<IntrosPage> createState() => _IntrosPageState();
}

class _IntrosPageState extends State<IntrosPage> {
  int _step = 0;

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx < -5) {
            if (_step == IntrosPage._titles.length - 1) {
              context.read<IntroController>().nextScreen();
            } else if (_step < IntrosPage._titles.length - 1) {
              setState(() => _step++);
            }
          } else if (details.velocity.pixelsPerSecond.dx > 5 && _step > 0) {
            setState(() => _step--);
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
                child: IntrosPage._pictures[_step],
              ),
              Padding(
                padding: paddingBottom12,
                child: Text(
                  IntrosPage._titles[_step],
                  style: textStylePoppins620.copyWith(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: paddingBottom20,
                child: Text(
                  IntrosPage._subtitles[_step],
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
                    onPressed: context.read<IntroController>().nextScreen,
                    child: Text('Skip', style: textStylePoppins616),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < IntrosPage._titles.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: DotColored(
                            color: i == _step ? clBlue : clIndigo600,
                          ),
                        ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _step == (IntrosPage._titles.length - 1)
                        ? context.read<IntroController>().nextScreen()
                        : setState(() => _step++),
                    child: Text('Next', style: textStylePoppins616),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
