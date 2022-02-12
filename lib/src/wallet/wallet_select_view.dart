import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/widgets/common.dart';

class WalletSelectView extends StatelessWidget {
  const WalletSelectView({Key? key}) : super(key: key);

  static const routeName = '/wallet_select';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        primary: true,
        body: Column(
          children: [
            // Header
            const HeaderBar(
              title: HeaderBarTitleLogo(),
              backButton: HeaderBarBackButton(),
              // closeButton: HeaderBarCloseButton(),
            ),
            Expanded(child: Container()),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                  child: Image(
                    width: 40,
                    image: AssetImage('assets/images/icon_connect.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        children: const <TextSpan>[
                          TextSpan(
                              text: 'Select a Poligon wallet to connect\nto '),
                          TextSpan(
                              text: 'Guardian Network',
                              style: TextStyle(color: Color(0xFF54BAF9))),
                          TextSpan(text: ':'),
                        ],
                      )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: ListTile(
                        title: const Text('MetaMask'),
                        trailing: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          foregroundImage: AssetImage('assets/images/logo.png'),
                        ),
                        onTap: () {
                          // Navigator.restorablePushNamed(context, Page.routeName);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: ListTile(
                        title: const Text('Torus'),
                        trailing: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          foregroundImage: AssetImage('assets/images/logo.png'),
                        ),
                        onTap: () {
                          // Navigator.restorablePushNamed(context, Page.routeName);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: ListTile(
                        title: const Text('Portis'),
                        trailing: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          foregroundImage: AssetImage('assets/images/logo.png'),
                        ),
                        onTap: () {
                          // Navigator.restorablePushNamed(context, Page.routeName);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: ListTile(
                        title: const Text('Formatic'),
                        trailing: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          foregroundImage: AssetImage('assets/images/logo.png'),
                        ),
                        onTap: () {
                          // Navigator.restorablePushNamed(context, Page.routeName);
                        }),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
            // Footer
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  children: const <TextSpan>[
                    TextSpan(text: 'New to Polygon?\n'),
                    TextSpan(
                        text: 'Learn how to set up your wallet.',
                        style: TextStyle(color: Color(0xFF54BAF9))),
                  ],
                )),
            Container(height: 50),
          ],
        ));
  }
}
