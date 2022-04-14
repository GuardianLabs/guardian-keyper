import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme_data.dart';
import '../../core/widgets/common.dart';

class IntroPage2View extends StatelessWidget {
  const IntroPage2View({Key? key, required this.onPressed}) : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height > 700 ? 120 : 100;
    return Column(
      children: [
        const HeaderBar(title: HeaderBarTitleLogo()),
        Expanded(child: Container()),
        Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: height,
              child: Image(
                height: height,
                image: const AssetImage('assets/images/icon_connect.png'),
              ),
            ),
            Positioned(
              bottom: -20,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF54BAF9), width: 2),
                  color: clIndigo700,
                  shape: BoxShape.circle,
                ),
                height: 40,
                width: 40,
                child: Center(
                    child: Text(
                  '2',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                )),
              ),
            ),
          ],
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
        ),
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
                children: const <TextSpan>[
                  TextSpan(text: 'Connect your\n'),
                  TextSpan(
                      text: 'Polygon wallet',
                      style: TextStyle(color: Color(0xFF54BAF9))),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 40, right: 40),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                text:
                    'Lorem ipsum dolor sit amet security consectetur adipiscing elit',
              )),
        ),
        // DotBar
        const Padding(
          padding: EdgeInsets.only(top: 50, bottom: 40),
          child: DotBar(count: 4, active: 1),
        ),
        // Footer
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: PrimaryTextButton(text: 'Get Started', onPressed: onPressed),
        ),
        Container(height: 50),
      ],
    );
  }
}
