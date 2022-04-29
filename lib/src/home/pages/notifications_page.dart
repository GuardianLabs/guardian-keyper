import 'package:flutter/material.dart';
import 'package:guardian_network/src/core/widgets/common.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/icon_of.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        const HeaderBar(caption: 'Notifications'),
        // Body
        Expanded(child: Container()),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: paddingBottom20,
              child: IconOf.notitications(radius: 40, size: 40),
            ),
            RichText(
              textAlign: TextAlign.center,
              softWrap: true,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'You don’t have any\n',
                    style: textStylePoppinsBold20,
                  ),
                  TextSpan(
                    text: 'notifications yet',
                    style: textStylePoppinsBold20Blue,
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(flex: 3, child: Container()),
      ],
    );
  }
}
