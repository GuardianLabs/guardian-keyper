import 'package:flutter/material.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/misc.dart';

class IntroPage1View extends StatelessWidget {
  const IntroPage1View({Key? key, required this.onPressed}) : super(key: key);

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
            CircleAvatar(backgroundColor: Colors.white, radius: height),
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
                    child: Text('1', style: textStyleSourceSansProBold14)),
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
                style: textStylePoppinsBold20,
                children: const <TextSpan>[
                  TextSpan(text: 'Secure your secrets\n'),
                  TextSpan(
                      text: 'Decentralized', style: TextStyle(color: clBlue)),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 40, right: 40),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: textStyleSourceSansProBold16,
                text:
                    'Guardian Network is a decentralized app to store your secret phrases, and private keys',
              )),
        ),
        // DotBar
        const Padding(
          padding: EdgeInsets.only(top: 50, bottom: 40),
          child: DotBar(count: 4),
        ),
        // Footer
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: PrimaryButtonBig(text: 'Get Started', onPressed: onPressed),
        ),
        Container(height: 50),
      ],
    );
  }
}
